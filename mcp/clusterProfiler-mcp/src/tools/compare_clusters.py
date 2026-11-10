"""Per-cluster comparison of enrichment results (clusterProfiler::compareCluster)."""

from __future__ import annotations

from pathlib import Path

from fastmcp import FastMCP

from _runtime import (ToolError, abs_path, check_cutoffs, check_sizes,
                      read_csv, run_r)

mcp = FastMCP("clusterprofiler-compare")

PREVIEW_ROWS = 25
# "enricher" is supported by compareCluster() but needs TERM2GENE; it is handled
# separately below.  All of these are dispatched by clusterProfiler itself.
ALLOWED_FUN = {"enrichGO", "enrichKEGG", "enricher", "groupGO", "gseGO", "gseKEGG"}


@mcp.tool
def compare_clusters(
    clusters_path: str,
    fun: str = "enrichGO",
    orgdb: str = "org.Hs.eg.db",
    ont: str = "BP",
    key_type: str = "ENTREZID",
    organism: str = "hsa",
    level: int = 2,
    pvalue_cutoff: float = 0.05,
    p_adjust_method: str = "BH",
    qvalue_cutoff: float = 0.2,
    min_gs_size: int = 10,
    max_gs_size: int = 500,
    term2gene_path: str | None = None,
    term2name_path: str | None = None,
    seed: int = 0,
) -> dict:
    """Compare enrichment across gene clusters (clusterProfiler::compareCluster).

    clusters_path is a header-delimited file with columns (cluster, gene); for
    fun = "gseGO"/"gseKEGG" it must also carry a numeric "stat" column used to
    rank each cluster.  fun = "enricher" requires term2gene_path.  Parameters a
    given fun does not accept are ignored (reported in the response) instead of
    being forwarded and rejected by R.
    """
    check_sizes(min_gs_size, max_gs_size)
    check_cutoffs(pvalue_cutoff, qvalue_cutoff)
    if fun not in ALLOWED_FUN:
        raise ToolError(f"fun must be one of {sorted(ALLOWED_FUN)}")
    if not Path(clusters_path).expanduser().is_file():
        raise ToolError(f"clusters file not found: {clusters_path}")
    for label, path in (("term2gene", term2gene_path), ("term2name", term2name_path)):
        if path is not None and not Path(path).expanduser().is_file():
            raise ToolError(f"{label} file not found: {path}")
    if fun == "enricher" and term2gene_path is None:
        raise ToolError("fun = 'enricher' requires term2gene_path")
    payload = run_r("compare_clusters.R", None, {
        "clustersFile": abs_path(clusters_path), "fun": fun, "OrgDb": orgdb,
        "ont": ont, "keyType": key_type, "organism": organism, "level": level,
        "pvalueCutoff": pvalue_cutoff, "pAdjustMethod": p_adjust_method,
        "qvalueCutoff": qvalue_cutoff, "minGSSize": min_gs_size,
        "maxGSSize": max_gs_size,
        "seed": seed,
        "term2gene": abs_path(term2gene_path) if term2gene_path else None,
        "term2name": abs_path(term2name_path) if term2name_path else None,
    }, "compareCluster")
    table = Path(payload["_artifact_dir"]) / "compareCluster.csv"
    return {
        "rows": payload.get("rows", 0),
        "fun": payload.get("fun"),
        "clusters": payload.get("clusters", []),
        "cluster_sizes": payload.get("cluster_sizes", []),
        "ranked": payload.get("ranked", False),
        "seed": payload.get("seed"),
        "ignored_args": payload.get("ignored_args", []),
        "notes": payload.get("notes", []),
        "warnings": payload.get("warnings", []),
        "columns": payload.get("columns", []),
        "artifacts": [{"path": str(table), "kind": "csv",
                       "description": "Full compareCluster result table"}],
        "preview": read_csv(table, PREVIEW_ROWS) if table.exists() else [],
        "diagnostics": (payload.get("_stderr") or "")[-800:],
    }
