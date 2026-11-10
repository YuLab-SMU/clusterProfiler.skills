#!/usr/bin/env Rscript
## compareCluster tool: the same gene sets analysed per cluster.
## Cluster membership is read from a long table (cluster, gene) supplied by the
## user; no group labels are invented inside the wrapper.  Everything scientific
## is delegated to clusterProfiler::compareCluster().

args_all <- commandArgs(trailingOnly = FALSE)
## Rscript encodes spaces in --file as "~+~"; decode before sourcing siblings so the
## package works from directories with spaces in their path.
script_dir <- gsub("~+~", " ", dirname(sub("^--file=", "", args_all[grep("^--file=", args_all)])), fixed = TRUE)
source(file.path(script_dir, "cp_common.R"))
activate_runtime()

suppressPackageStartupMessages({
    library(clusterProfiler)
    library(jsonlite)
})

cmd <- commandArgs(trailingOnly = TRUE)
if (length(cmd) < 1L) fail("a JSON spec path is required")
spec <- read_json_arg(cmd[[1]])
outdir <- spec$outdir
if (is.null(outdir) || !nzchar(outdir)) fail("outdir is required")
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

## Compare a function's formal arguments with the caller-supplied extras.
fun_env <- function(fun) {
    if (fun %in% c("groupGO", "enrichGO", "enrichKEGG", "gseGO", "gseKEGG")) {
        return(utils::getFromNamespace(fun, "clusterProfiler"))
    }
    get(fun, envir = globalenv())
}

## ---- clusters file ---------------------------------------------------
memb <- utils::read.delim(spec$clustersFile, stringsAsFactors = FALSE,
                          header = TRUE, check.names = FALSE)
if (ncol(memb) < 2L) {
    fail("clusters file must have columns: cluster, gene (and stat for GSEA)")
}
hdr <- tolower(colnames(memb))
if (!all(c("cluster", "gene") %in% hdr)) {
    fail(paste0("clusters file header must contain 'cluster' and 'gene', got: ",
                paste(colnames(memb), collapse = ", ")))
}
cluster_col <- match("cluster", hdr)
gene_col <- match("gene", hdr)
stat_col <- match("stat", hdr)

fun <- if (is.null(spec$fun)) "enrichGO" else spec$fun
ranked_fun <- fun %in% c("gseGO", "gseKEGG")

## fgsea's multilevel p-values depend on the RNG state.  Ranking-based funs are
## therefore run from a pinned seed so repeated calls on the same input agree.
seed <- if (is.null(spec$seed)) 0L else as.integer(spec$seed)
if (ranked_fun) set.seed(seed)

cluster_ids <- as.character(memb[[cluster_col]])
gene_ids <- as.character(memb[[gene_col]])
if (any(cluster_ids %in% c("", NA))) fail("clusters file contains empty cluster labels")
if (any(gene_ids %in% c("", NA))) fail("clusters file contains empty gene identifiers")

## A header such as (gene, cluster) passes the name check but silently analyses
## the wrong column.  Flag the swapped shape instead of returning empty results.
warnings <- character(0)
if (anyDuplicated(cluster_ids) == 0L && anyDuplicated(gene_ids) > 0L &&
    all(grepl("^[0-9]+$", cluster_ids)) && !all(grepl("^[0-9]+$", gene_ids))) {
    warnings <- c(warnings, paste0(
        "the 'cluster' column looks like gene identifiers (all unique, all numeric) ",
        "and the 'gene' column repeats; check whether the header columns are swapped"))
}

if (ranked_fun) {
    if (is.na(stat_col)) {
        fail(paste0("fun = '", fun,
                    "' needs a ranked gene list: the clusters file must have a third ",
                    "column named 'stat' holding the ranking statistic"))
    }
    stats <- suppressWarnings(as.numeric(memb[[stat_col]]))
    if (anyNA(stats)) fail("the 'stat' column must be numeric")
    dup <- duplicated(paste(cluster_ids, gene_ids, sep = "\r"))
    if (any(dup)) fail("each gene may appear only once per cluster in the clusters file")
    groups <- split(seq_along(gene_ids), cluster_ids)
    clusters <- lapply(groups, function(idx) {
        v <- stats[idx]
        names(v) <- gene_ids[idx]
        sort(v, decreasing = TRUE)
    })
} else {
    groups <- split(gene_ids, cluster_ids)
    clusters <- lapply(groups, function(x) unique(x[x != ""]))
}
if (length(clusters) < 1L) fail("no clusters were found in the clusters file")

## ---- optional user gene sets (fun = "enricher") ----------------------
dots <- list()
if (identical(fun, "enricher")) {
    if (is.null(spec$term2gene)) {
        fail("fun = 'enricher' requires term2gene_path in the clusters tool")
    }
    t2g <- utils::read.delim(spec$term2gene, stringsAsFactors = FALSE, header = TRUE)
    if (ncol(t2g) < 2L) fail("term2gene must have at least two columns (term, gene)")
    dots$TERM2GENE <- t2g[, 1:2]
    if (!is.null(spec$term2name)) {
        t2n <- utils::read.delim(spec$term2name, stringsAsFactors = FALSE, header = TRUE)
        if (ncol(t2n) < 2L) fail("term2name must have at least two columns (term, name)")
        dots$TERM2NAME <- t2n[, 1:2]
    }
}

## ---- forward only parameters the chosen function understands ---------
## KEGG interfaces accept only kegg/ncbi-geneid/ncbi-proteinid/uniprot as keyType.
## The tool-wide default keyType is ENTREZID (the GO default); when it reaches a
## KEGG fun unmodified we fall back to the upstream KEGG default ("kegg") and
## report the substitution, instead of failing on a value the caller never chose.
KEGG_KEYTYPES <- c("kegg", "ncbi-geneid", "ncbi-proteinid", "uniprot")
key_type <- spec$keyType
notes <- character(0)
if (grepl("KEGG", fun, ignore.case = TRUE) && !is.null(key_type) &&
    !key_type %in% KEGG_KEYTYPES) {
    notes <- c(notes, paste0("keyType '", key_type,
                             "' is not a KEGG key type; used upstream default 'kegg'"))
    key_type <- NULL
}

maybe <- list(OrgDb = spec$OrgDb, ont = spec$ont, keyType = key_type,
              organism = spec$organism, level = spec$level,
              pvalueCutoff = if (is.null(spec$pvalueCutoff)) NULL else as.numeric(spec$pvalueCutoff),
              pAdjustMethod = spec$pAdjustMethod,
              qvalueCutoff = if (is.null(spec$qvalueCutoff)) NULL else as.numeric(spec$qvalueCutoff),
              minGSSize = if (is.null(spec$minGSSize)) NULL else as.integer(spec$minGSSize),
              maxGSSize = if (is.null(spec$maxGSSize)) NULL else as.integer(spec$maxGSSize))
maybe <- maybe[!vapply(maybe, is.null, logical(1))]
allowed <- names(formals(fun_env(fun)))
ignored <- setdiff(names(maybe), allowed)
dots <- c(dots, maybe[intersect(names(maybe), allowed)])

res <- do.call(compareCluster, c(list(geneClusters = clusters, fun = fun), dots))
df <- res_to_df(res)
if (is.null(df)) df <- data.frame()
path <- write_result_table(df, outdir, "compareCluster.csv")
emit(tool = "compareCluster", fun = fun, clusters = I(names(clusters)),
     cluster_sizes = I(as.integer(vapply(clusters, length, integer(1)))),
     ranked = ranked_fun, seed = seed, ignored_args = I(as.character(ignored)),
     notes = I(notes), warnings = I(warnings),
     rows = nrow(df), columns = I(colnames(df)), artifact = path)
