"""Post-processing and visualisation of enrichment results.

These tools run the upstream analysis and then hand the resulting S4 object to
the upstream post-processing / plotting function (clusterProfiler::simplify,
enrichplot::dotplot / barplot). No term reduction or drawing is reimplemented.
"""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import (ToolError, abs_path, check_cutoffs, check_sizes,
                      read_csv, run_r)

mcp = FastMCP("clusterprofiler-post")

PREVIEW_ROWS = 25


@mcp.tool
def simplify_go(
    gene: list[str],
    ont: str = "BP",
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    cutoff: float = 0.7,
    measure: str = "Wang",
    readable: bool = False,
) -> dict:
    """Remove redundant GO terms after ORA (clusterProfiler::simplify).

    Runs enrichGO with the given settings, then reduces terms whose semantic
    similarity exceeds `cutoff`. Returns both the number of terms before and after
    reduction, so the effect of simplification is visible.

    measure is one of Wang, Resnik, Rel, Jiang or Lin. The semantic data is built
    from the same OrgDb that produced the result and passed to simplify()
    explicitly: left to itself, simplify() always uses the human GO structure,
    whichever organism was analysed.
    """
    if measure not in {"Wang", "Resnik", "Rel", "Jiang", "Lin"}:
        raise ToolError("measure must be Wang, Resnik, Rel, Jiang or Lin")
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    if not 0.0 < cutoff <= 1.0:
        raise ToolError("cutoff must be in (0, 1]")
    payload = run_r("simplify_go.R", None, {
        "gene": list(gene), "ont": ont, "OrgDb": orgdb, "keyType": key_type,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "cutoff": cutoff, "measure": measure,
        "readable": readable,
    }, "simplifyGO")
    table = Path(payload["_artifact_dir"]) / "simplifyGO.csv"
    return {
        "rows_before": payload.get("rows_before", 0),
        "rows": payload.get("rows", 0),
        "measure": payload.get("measure"),
        "sem_data_orgdb": payload.get("semData_orgdb"),
        "sem_data_ont": payload.get("semData_ont"),
        "columns": payload.get("columns", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": "Simplified GO result table"}],
        "preview": read_csv(table, PREVIEW_ROWS) if table.exists() else [],
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


def _plot(kind: str, spec: dict, show_n: int, width: float, height: float,
          dpi: int) -> dict:
    payload = run_r("plotting.R", kind, {
        **spec, "show_n": show_n, "width": width, "height": height, "dpi": dpi,
    }, kind)
    png = Path(payload["artifact"])
    if not png.exists():
        raise ToolError(f"the upstream plot function did not produce {png}")
    return {
        "rows": payload.get("rows", 0),
        "terms_plotted": payload.get("terms_plotted", 0),
        "artifacts": [
            {"path": str(png), "kind": "image",
             "description": f"{kind} of the enrichment result ({width}x{height} in at {dpi} dpi)"},
            {"path": str(payload["data_artifact"]), "kind": "csv",
             "description": "The table that was plotted"},
        ],
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


@mcp.tool
def plot_ora(
    gene: list[str],
    kind: str = "dotplot",
    ont: str = "BP",
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    show_n: int = 20,
    width: float = 8.0,
    height: float = 6.0,
    dpi: int = 150,
) -> dict:
    """Dot or bar plot of a GO over-representation result (enrichplot::dotplot / barplot).

    Runs enrichGO, then draws the result with the upstream plotting function and
    saves a PNG. kind is "dotplot" or "barplot".
    """
    if kind not in {"dotplot", "barplot"}:
        raise ToolError("kind must be 'dotplot' or 'barplot'")
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    if show_n < 1:
        raise ToolError("show_n must be at least 1")
    return _plot(kind, {
        "gene": list(gene), "ont": ont, "OrgDb": orgdb, "keyType": key_type,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size,
    }, show_n, width, height, dpi)
