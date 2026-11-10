"""Gene set libraries: load a GMT file or build one from an OrgDb / KEGG.

The library is written as a TERM2GENE table that enrich_custom_sets accepts, so a
user can inspect or reuse exactly the gene sets that an analysis would use.
"""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import ToolError, abs_path, run_r

mcp = FastMCP("clusterprofiler-genesets")


def _finish(payload: dict, label: str) -> dict:
    table = Path(payload["artifact"])
    return {
        "sets": payload.get("sets", 0),
        "genes": payload.get("genes", 0),
        "memberships": payload.get("memberships", 0),
        "rows_read": payload.get("rows_read"),
        "dropped_empty_fields": payload.get("dropped_empty_fields", 0),
        "set_size_median": payload.get("set_size_median"),
        "artifacts": [{"path": str(table), "kind": "tsv",
                       "description": f"TERM2GENE table for {label}"}],
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


@mcp.tool
def load_gmt(gmt_path: str) -> dict:
    """Load a GMT gene set library (clusterProfiler::read.gmt).

    Returns the number of gene sets, genes and memberships, plus the library as a
    TERM2GENE TSV that enrich_custom_sets can consume directly.
    """
    if not Path(gmt_path).expanduser().is_file():
        raise ToolError(f"GMT file not found: {gmt_path}")
    payload = run_r("gene_sets.R", "readGMT", {"gmtFile": abs_path(gmt_path)}, "readGMT")
    return _finish(payload, "the supplied GMT")


@mcp.tool
def build_go_sets(
    ont: str = "BP",
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
) -> dict:
    """Build the GO gene set library for an OrgDb (clusterProfiler::gson_GO).

    Useful to see which gene sets exist before running an enrichment, and to reuse
    the same library through enrich_custom_sets.
    """
    if ont not in {"BP", "CC", "MF", "ALL"}:
        raise ToolError("ont must be BP, CC, MF or ALL")
    payload = run_r("gene_sets.R", "gsonGO", {
        "OrgDb": orgdb, "keyType": key_type, "ont": ont,
    }, "gsonGO")
    return _finish(payload, f"GO {ont} from {orgdb}")


@mcp.tool
def build_kegg_sets(organism: str = "hsa", key_type: str = "kegg") -> dict:
    """Build the KEGG pathway gene set library (clusterProfiler::gson_KEGG).

    Needs network access to rest.kegg.jp.
    """
    payload = run_r("gene_sets.R", "gsonKEGG", {
        "organism": organism, "keyType": key_type,
    }, "gsonKEGG")
    return _finish(payload, f"KEGG {organism}")
