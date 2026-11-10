"""GSEA tools running the pinned clusterProfiler gene set enrichment analysis."""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import (ToolError, abs_path, check_cutoffs, check_sizes,
                      read_csv, run_r)

mcp = FastMCP("clusterprofiler-gsea")

PREVIEW_ROWS = 25


def _check_ranked(path: str) -> str:
    p = Path(path).expanduser()
    if not p.is_file():
        raise ToolError(f"ranked list file not found: {path}")
    # The R dispatcher runs with cwd=src, so hand it an absolute path.
    return abs_path(path)


def _result(payload: dict, tag: str) -> dict:
    table = Path(payload["_artifact_dir"]) / f"{tag}.csv"
    preview = read_csv(table, PREVIEW_ROWS) if table.exists() else []
    return {
        "rows": payload.get("rows", 0),
        "seed": payload.get("seed"),
        "ranked_list_size": payload.get("ranked_list_size"),
        "columns": payload.get("columns", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": f"Full {tag} result table"}],
        "preview": preview,
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }


@mcp.tool
def gsea_go(
    gene_list_path: str,
    ont: str = "BP",
    orgdb: str = "org.Hs.eg.db",
    key_type: str = "ENTREZID",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    eps: float = 1e-10,
    exponent: float = 1.0,
    seed: int = 0,
) -> dict:
    """GO gene set enrichment analysis of a ranked list (clusterProfiler::gseGO).

    gene_list_path is a two-column file: identifier, statistic (e.g. log2 fold
    change). fgsea's multilevel p-values depend on the random number generator,
    so a seed is applied before the upstream call; identical inputs and seed
    reproduce the same table.
    """
    ranked = _check_ranked(gene_list_path)
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff)
    payload = run_r("gsea.R", "gseGO", {
        "geneListFile": ranked, "ont": ont, "OrgDb": orgdb,
        "keyType": key_type, "pvalueCutoff": pvalue_cutoff,
        "pAdjustMethod": p_adjust_method, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "eps": eps, "exponent": exponent,
        "seed": seed,
    }, "gseGO")
    return _result(payload, "gseGO")


@mcp.tool
def gsea_kegg(
    gene_list_path: str,
    organism: str = "hsa",
    key_type: str = "kegg",
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    eps: float = 1e-10,
    exponent: float = 1.0,
    use_internal_data: bool = False,
    seed: int = 0,
) -> dict:
    """KEGG gene set enrichment analysis of a ranked list (clusterProfiler::gseKEGG).

    KEGG annotations are retrieved online unless use_internal_data is true; a
    seed is applied before the upstream call for reproducible fgsea p-values.
    """
    ranked = _check_ranked(gene_list_path)
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff)
    payload = run_r("gsea.R", "gseKEGG", {
        "geneListFile": ranked, "organism": organism,
        "keyType": key_type, "pvalueCutoff": pvalue_cutoff,
        "pAdjustMethod": p_adjust_method, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size, "eps": eps, "exponent": exponent,
        "use_internal_data": use_internal_data, "seed": seed,
    }, "gseKEGG")
    return _result(payload, "gseKEGG")
