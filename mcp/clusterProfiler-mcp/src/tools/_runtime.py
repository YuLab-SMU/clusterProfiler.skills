"""Shared runtime bindings for the generated clusterProfiler MCP tools.

The R script is the only place where scientific work happens; this module
locates the pinned R runtime and the R dispatcher scripts, then enforces the
file-based result contract (JSON summary on stdout + artifact files on disk).
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

MODULE_DIR = Path(__file__).resolve().parent
SKILL_SRC = MODULE_DIR.parent
R_SCRIPT_DIR = SKILL_SRC / "r_scripts"
DEFAULT_R_PROJECT = SKILL_SRC.parent / "r-runtime"

R_TIMEOUT = int(os.environ.get("P2A_R_TIMEOUT", "900"))


class ToolError(RuntimeError):
    """Raised when the upstream R call fails or returns an invalid contract."""


def rscript() -> str:
    explicit = os.environ.get("P2A_RSCRIPT")
    if explicit:
        return explicit
    found = shutil.which("Rscript")
    if not found:
        raise ToolError(
            "Rscript was not found. Set P2A_RSCRIPT to an Rscript executable "
            "of an R installation that can load the pinned clusterProfiler library."
        )
    return found


def abs_path(path: str) -> str:
    """Resolve a user-supplied path to an absolute path.

    The R dispatcher runs with cwd=src, so a relative path validated in the
    server process would otherwise be re-read relative to a different directory.
    """
    return str(Path(path).expanduser().resolve())


def check_sizes(min_gs_size: int, max_gs_size: int) -> None:
    """Reject an impossible gene-set size window before calling R."""
    if min_gs_size < 1:
        raise ToolError("min_gs_size must be a positive integer")
    if max_gs_size < min_gs_size:
        raise ToolError(
            f"max_gs_size ({max_gs_size}) must be greater than or equal to "
            f"min_gs_size ({min_gs_size})"
        )


def check_cutoffs(pvalue_cutoff: float, qvalue_cutoff: float | None = None) -> None:
    """Reject cutoffs outside [0, 1]; the R side treats them as filters only."""
    if not 0.0 <= pvalue_cutoff <= 1.0:
        raise ToolError("pvalue_cutoff must be between 0 and 1")
    if qvalue_cutoff is not None and not 0.0 <= qvalue_cutoff <= 1.0:
        raise ToolError("qvalue_cutoff must be between 0 and 1")


def r_project() -> Path:
    explicit = os.environ.get("P2A_R_PROJECT")
    if explicit:
        return Path(explicit)
    return DEFAULT_R_PROJECT


def _render_paths(outdir: Path, tag: str) -> dict:
    return {"dir": outdir, "table": outdir / f"{tag}.csv"}


def run_r(module: str, action: str | None, spec: dict, tag: str) -> dict:
    """Run one R dispatcher and return its parsed JSON summary."""
    script = R_SCRIPT_DIR / module
    if not script.exists():
        raise ToolError(f"R dispatcher missing: {script}")

    root = os.environ.get("P2A_OUTPUT_ROOT")
    if root:
        Path(root).mkdir(parents=True, exist_ok=True)
        outdir = Path(tempfile.mkdtemp(prefix="clusterprofiler-", dir=root))
    else:
        outdir = Path(tempfile.mkdtemp(prefix="clusterprofiler-"))
    spec = dict(spec)
    spec["outdir"] = str(outdir)

    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False, encoding="utf-8") as fh:
        json.dump(spec, fh)
        spec_path = fh.name

    env = os.environ.copy()
    env.setdefault("P2A_R_PROJECT", str(r_project()))
    env.setdefault("RENV_PROJECT", str(r_project()))

    cmd = [rscript(), str(script)]
    if action:
        cmd.append(action)
    cmd.append(spec_path)

    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, env=env, timeout=R_TIMEOUT,
            cwd=str(SKILL_SRC),
        )
    except subprocess.TimeoutExpired as exc:
        shutil.rmtree(outdir, ignore_errors=True)
        raise ToolError(f"R execution exceeded {R_TIMEOUT}s") from exc
    finally:
        try:
            os.unlink(spec_path)
        except OSError:
            pass

    if proc.returncode != 0:
        shutil.rmtree(outdir, ignore_errors=True)
        detail = (proc.stderr or proc.stdout or "").strip()
        raise ToolError(f"R execution failed (exit {proc.returncode}): {detail[-2000:]}")

    payload = None
    for line in reversed(proc.stdout.strip().splitlines()):
        line = line.strip()
        if line.startswith("{") and line.endswith("}"):
            try:
                payload = json.loads(line)
                break
            except json.JSONDecodeError:
                continue
    if payload is None:
        shutil.rmtree(outdir, ignore_errors=True)
        raise ToolError(
            "R execution produced no JSON summary; stderr: "
            + (proc.stderr or "").strip()[-1500:]
        )

    payload["_artifact_dir"] = str(outdir)
    payload["_stderr"] = (proc.stderr or "").strip()[-1500:]
    return payload


def cleanup(payload: dict) -> None:
    directory = payload.get("_artifact_dir")
    if directory:
        shutil.rmtree(directory, ignore_errors=True)


def read_csv(path: str | Path, limit: int | None = None) -> list[dict]:
    import csv

    rows: list[dict] = []
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        for i, row in enumerate(reader):
            if limit is not None and i >= limit:
                break
            rows.append(dict(row))
    return rows


def die(message: str) -> None:
    print(json.dumps({"error": message}), file=sys.stderr)
    raise SystemExit(1)
