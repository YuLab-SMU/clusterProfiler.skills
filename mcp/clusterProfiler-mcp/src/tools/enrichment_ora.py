"""ORA tools: GO / KEGG / GO-level classification / user gene-set enrichment.

Each tool forwards to the pinned clusterProfiler public API through
src/r_scripts/enrichment_ora.R. No statistics are recomputed in Python.
"""

from __future__ import annotations

import tempfile
from pathlib import Path

from fastmcp import FastMCP

from _runtime import (ToolError, abs_path, check_cutoffs, check_sizes,
                      cleanup, read_csv, run_r)

mcp = FastMCP("clusterprofiler-ora")

PREVIEW_ROWS = 25


def _result(payload: dict, tag: str) -> dict:
    table = Path(payload["_artifact_dir"]) / f"{tag}.csv"
    preview = read_csv(table, PREVIEW_ROWS) if table.exists() else []
    return {
        "rows": payload.get("rows", 0),
        "columns": payload.get("columns", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": f"Full {tag} result table"}],
        "preview": preview,
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


@mcp.tool
def enrich_go(
    gene: list[str],
    ont: str = "MF",
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    readable: bool = False,
    pool: bool = False,
    universe: list[str] | None = None,
) -> dict:
    """GO over-representation analysis of a gene list (clusterProfiler::enrichGO).

    Provide gene identifiers of one key type (default Entrez IDs) and the
    OrgDb annotation package name, e.g. "org.Hs.eg.db". Returns the enrichment
    table plus a CSV artifact.

    Defaults mirror the upstream signature exactly, including ont = "MF".
    Pass ont="BP" or ont="CC" explicitly for the other ontologies.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    payload = run_r("enrichment_ora.R", "enrichGO", {
        "gene": list(gene), "ont": ont, "OrgDb": orgdb, "keyType": key_type,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "readable": readable, "pool": pool,
        "universe": universe,
    }, "enrichGO")
    return _result(payload, "enrichGO")


@mcp.tool
def enrich_kegg(
    gene: list[str],
    organism: str = "hsa",
    key_type: str = "kegg",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    use_internal_data: bool = False,
    universe: list[str] | None = None,
) -> dict:
    """KEGG pathway over-representation analysis (clusterProfiler::enrichKEGG).

    KEGG annotations are downloaded online unless use_internal_data is true and
    an internal KEGG snapshot is available for that organism.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    payload = run_r("enrichment_ora.R", "enrichKEGG", {
        "gene": list(gene), "organism": organism, "keyType": key_type,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "use_internal_data": use_internal_data,
        "universe": universe,
    }, "enrichKEGG")
    return _result(payload, "enrichKEGG")


@mcp.tool
def classify_go_levels(
    gene: list[str],
    ont: str = "CC",
    level: int = 2,
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
    readable: bool = False,
) -> dict:
    """Direct GO classification at a chosen level (clusterProfiler::groupGO).

    Unlike enrichment, this only counts which genes fall under each GO term at
    the requested depth; it performs no statistical test.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    if level < 1:
        raise ToolError("level must be a positive integer")
    payload = run_r("enrichment_ora.R", "groupGO", {
        "gene": list(gene), "ont": ont, "level": level, "OrgDb": orgdb,
        "keyType": key_type, "readable": readable,
    }, "groupGO")
    return _result(payload, "groupGO")


@mcp.tool
def enrich_custom_sets(
    gene: list[str],
    term2gene_path: str,
    term2name_path: str | None = None,
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    universe: list[str] | None = None,
) -> dict:
    """Enrichment against user-supplied gene sets (clusterProfiler::enricher).

    term2gene_path is a header-delimited file with columns (term, gene);
    term2name_path is optional with columns (term, name).
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    if not Path(term2gene_path).expanduser().is_file():
        raise ToolError(f"term2gene file not found: {term2gene_path}")
    if term2name_path is not None and not Path(term2name_path).expanduser().is_file():
        raise ToolError(f"term2name file not found: {term2name_path}")
    payload = run_r("enrichment_ora.R", "enricher", {
        "gene": list(gene), "term2gene": abs_path(term2gene_path),
        "term2name": abs_path(term2name_path) if term2name_path is not None else None,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "universe": universe,
    }, "enricher")
    return _result(payload, "enricher")
