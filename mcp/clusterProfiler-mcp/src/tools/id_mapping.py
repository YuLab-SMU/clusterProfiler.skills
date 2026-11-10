"""Identifier utilities backed by the pinned clusterProfiler package."""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import ToolError, read_csv, run_r

mcp = FastMCP("clusterprofiler-ids")

PREVIEW_ROWS = 50


@mcp.tool
def map_gene_ids(
    gene: list[str],
    to_type: list[str],
    from_type: str = "ENTREZID",
    orgdb: str = "org.Hs.eg.db",
) -> dict:
    """Map gene identifiers between key types (clusterProfiler::bitr).

    Uses the OrgDb annotation package for the organism; unmapped identifiers are
    reported explicitly instead of being silently dropped.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    if not to_type:
        raise ToolError("to_type must contain at least one key type")
    payload = run_r("id_mapping.R", "bitr", {
        "gene": list(gene), "toType": list(to_type), "fromType": from_type,
        "OrgDb": orgdb,
    }, "bitr")
    table = Path(payload["_artifact_dir"]) / "bitr.csv"
    return {
        "input_count": payload.get("input_count"),
        "mapped_count": payload.get("mapped_count"),
        "unmapped_count": payload.get("unmapped_count"),
        "mapping_rows": payload.get("rows"),
        "columns": payload.get("columns", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": "Identifier mapping table"}],
        "preview": read_csv(table, PREVIEW_ROWS) if table.exists() else [],
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


@mcp.tool
def list_key_types(orgdb: str = "org.Hs.eg.db") -> dict:
    """List the identifier key types an OrgDb annotation package supports."""
    payload = run_r("id_mapping.R", "idType", {"OrgDb": orgdb}, "idType")
    table = Path(payload["_artifact_dir"]) / "idType.csv"
    return {
        "orgdb": payload.get("OrgDb", orgdb),
        "key_types": payload.get("key_types", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": "Supported key types"}],
    }
