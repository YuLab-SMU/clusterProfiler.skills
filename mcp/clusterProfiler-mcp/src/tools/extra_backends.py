"""Additional enrichment backends: Disease Ontology, KEGG module, WikiPathways.

Each tool forwards to the pinned clusterProfiler public API through
src/r_scripts/enrichment_ora.R or src/r_scripts/gsea.R.
"""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import (ToolError, abs_path, check_cutoffs, check_sizes,
                      read_csv, run_r)

mcp = FastMCP("clusterprofiler-backends")

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


def _ranked(path: str) -> str:
    if not Path(path).expanduser().is_file():
        raise ToolError(f"ranked list file not found: {path}")
    return abs_path(path)


@mcp.tool
def enrich_kegg_module(
    gene: list[str],
    organism: str = "hsa",
    key_type: str = "kegg",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
) -> dict:
    """KEGG module over-representation analysis (clusterProfiler::enrichMKEGG).

    Modules are the KEGG orthology groupings, a coarser view than pathways.
    Needs network access to rest.kegg.jp.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    payload = run_r("enrichment_ora.R", "enrichMKEGG", {
        "gene": list(gene), "organism": organism, "keyType": key_type,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size,
    }, "enrichMKEGG")
    return _result(payload, "enrichMKEGG")


@mcp.tool
def enrich_wikipathways(
    gene: list[str],
    organism: str = "Homo sapiens",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
) -> dict:
    """WikiPathways over-representation analysis (clusterProfiler::enrichWP).

    Downloads the current WikiPathways GMT on each call, so results follow the
    live library rather than a pinned snapshot.
    """
    if not gene:
        raise ToolError("gene must contain at least one identifier")
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    payload = run_r("enrichment_ora.R", "enrichWP", {
        "gene": list(gene), "organism": organism,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size,
    }, "enrichWP")
    return _result(payload, "enrichWP")


@mcp.tool
def gsea_kegg_module(
    gene_list_path: str,
    organism: str = "hsa",
    key_type: str = "kegg",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    exponent: float = 1.0,
    eps: float = 1e-10,
    seed: int = 0,
) -> dict:
    """KEGG module gene set enrichment (clusterProfiler::gseMKEGG)."""
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff)
    payload = run_r("gsea.R", "gseMKEGG", {
        "geneListFile": _ranked(gene_list_path), "organism": organism,
        "keyType": key_type, "pvalueCutoff": pvalue_cutoff,
        "pAdjustMethod": p_adjust_method, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "exponent": exponent, "eps": eps, "seed": seed,
    }, "gseMKEGG")
    out = _result(payload, "gseMKEGG")
    out["seed"] = payload.get("seed")
    out["ranked_list_size"] = payload.get("ranked_list_size")
    return out


@mcp.tool
def gsea_wikipathways(
    gene_list_path: str,
    organism: str = "Homo sapiens",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    exponent: float = 1.0,
    seed: int = 0,
) -> dict:
    """WikiPathways gene set enrichment (clusterProfiler::gseWP).

    Downloads the current WikiPathways library on each call.
    """
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff)
    payload = run_r("gsea.R", "gseWP", {
        "geneListFile": _ranked(gene_list_path), "organism": organism,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "minGSSize": min_gs_size, "maxGSSize": max_gs_size,
        "exponent": exponent, "seed": seed,
    }, "gseWP")
    out = _result(payload, "gseWP")
    out["seed"] = payload.get("seed")
    out["ranked_list_size"] = payload.get("ranked_list_size")
    return out
