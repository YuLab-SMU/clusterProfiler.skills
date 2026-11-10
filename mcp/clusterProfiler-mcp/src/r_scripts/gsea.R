#!/usr/bin/env Rscript
## GSEA tools: gseGO / gseKEGG.
## The ranked list is read from a two-column file (identifier, statistic) and is
## passed to the upstream clusterProfiler API unchanged.

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
action <- cmd[[1]]
spec <- read_json_arg(cmd[[2]])
outdir <- spec$outdir
if (is.null(outdir) || !nzchar(outdir)) fail("outdir is required")
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)


result_table <- function(res, tag) {
    df <- res_to_df(res)
    if (is.null(df) || nrow(df) == 0L) {
        path <- write_result_table(data.frame(), outdir, paste0(tag, ".csv"))
        return(list(path = path, rows = 0L, columns = character(0)))
    }
    path <- write_result_table(df, outdir, paste0(tag, ".csv"))
    list(path = path, rows = nrow(df), columns = colnames(df))
}

## fgsea's multilevel p-values depend on the RNG state, so the wrapper pins both the
## generator kind and the seed. Pinning RNGkind matters: without it the result depends
## on whatever RNG the caller's R session happened to be using.
seed <- if (is.null(spec$seed)) 0L else as.integer(spec$seed)
suppressWarnings(RNGkind(kind = "Mersenne-Twister", normal.kind = "Inversion",
                         sample.kind = "Rejection"))
set.seed(seed)

switch(action,
    gseGO = {
        gl <- read_ranked_list(spec$geneListFile)
        res <- gseGO(
            geneList = gl,
            ont = if (is.null(spec$ont)) "BP" else spec$ont,
            OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
            keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
            exponent = if (is.null(spec$exponent)) 1 else as.numeric(spec$exponent),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            eps = if (is.null(spec$eps)) 1e-10 else as.numeric(spec$eps),
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            verbose = FALSE,
            by = if (is.null(spec$by)) "fgsea" else spec$by,
            seed = FALSE
        )
        info <- result_table(res, "gseGO")
        emit(tool = "gseGO", ontology = if (is.null(spec$ont)) "BP" else spec$ont,
             seed = seed, rows = info$rows, columns = I(info$columns),
             artifact = info$path, ranked_list_size = length(gl))
    },
    gseKEGG = {
        gl <- read_ranked_list(spec$geneListFile)
        res <- gseKEGG(
            geneList = gl,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            keyType = if (is.null(spec$keyType)) "kegg" else spec$keyType,
            exponent = if (is.null(spec$exponent)) 1 else as.numeric(spec$exponent),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            eps = if (is.null(spec$eps)) 1e-10 else as.numeric(spec$eps),
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            verbose = FALSE,
            use_internal_data = isTRUE(spec$use_internal_data),
            by = if (is.null(spec$by)) "fgsea" else spec$by,
            seed = FALSE
        )
        info <- result_table(res, "gseKEGG")
        emit(tool = "gseKEGG", organism = if (is.null(spec$organism)) "hsa" else spec$organism,
             seed = seed, rows = info$rows, columns = I(info$columns),
             artifact = info$path, ranked_list_size = length(gl))
    },
    gseDO = {
        gl <- read_ranked_list(spec$geneListFile)
        res <- gseDO(
            geneList = gl,
            ont = if (is.null(spec$ont)) "DO" else spec$ont,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            exponent = if (is.null(spec$exponent)) 1 else as.numeric(spec$exponent),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            verbose = FALSE,
            by = if (is.null(spec$by)) "fgsea" else spec$by,
            seed = FALSE
        )
        info <- result_table(res, "gseDO")
        emit(tool = "gseDO", ontology = if (is.null(spec$ont)) "DO" else spec$ont,
             seed = seed, rows = info$rows, columns = I(info$columns),
             artifact = info$path, ranked_list_size = length(gl))
    },
    gseMKEGG = {
        gl <- read_ranked_list(spec$geneListFile)
        res <- gseMKEGG(
            geneList = gl,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            keyType = if (is.null(spec$keyType)) "kegg" else spec$keyType,
            exponent = if (is.null(spec$exponent)) 1 else as.numeric(spec$exponent),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            eps = if (is.null(spec$eps)) 1e-10 else as.numeric(spec$eps),
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            verbose = FALSE,
            by = if (is.null(spec$by)) "fgsea" else spec$by,
            seed = FALSE
        )
        info <- result_table(res, "gseMKEGG")
        emit(tool = "gseMKEGG", organism = if (is.null(spec$organism)) "hsa" else spec$organism,
             seed = seed, rows = info$rows, columns = I(info$columns),
             artifact = info$path, ranked_list_size = length(gl))
    },
    gseWP = {
        gl <- read_ranked_list(spec$geneListFile)
        wp_organism <- if (is.null(spec$organism)) "Homo sapiens" else spec$organism
        check_wp_organism(wp_organism)
        res <- gseWP(
            geneList = gl,
            organism = wp_organism,
            exponent = if (is.null(spec$exponent)) 1 else as.numeric(spec$exponent),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            verbose = FALSE,
            by = if (is.null(spec$by)) "fgsea" else spec$by,
            seed = FALSE
        )
        info <- result_table(res, "gseWP")
        emit(tool = "gseWP", organism = wp_organism,
             seed = seed, rows = info$rows, columns = I(info$columns),
             artifact = info$path, ranked_list_size = length(gl))
    },
    fail(paste0("unknown action for this module: ", action))
)
