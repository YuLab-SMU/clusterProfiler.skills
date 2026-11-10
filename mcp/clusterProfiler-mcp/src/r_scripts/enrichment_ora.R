#!/usr/bin/env Rscript
## ORA tools: enrichGO / enrichKEGG / groupGO / enricher.
## Every function call is the upstream clusterProfiler public API; this script
## only performs contract checks, argument marshalling and result serialisation.

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
spec_path <- cmd[[2]]

spec <- read_json_arg(spec_path)
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

switch(action,
    enrichGO = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        orgdb <- if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb
        res <- enrichGO(
            gene = gene,
            OrgDb = orgdb,
            keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
            ont = if (is.null(spec$ont)) "BP" else spec$ont,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            universe = if (is.null(spec$universe)) NULL else as_chr(spec$universe),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            readable = isTRUE(spec$readable),
            pool = isTRUE(spec$pool)
        )
        info <- result_table(res, "enrichGO")
        emit(tool = "enrichGO", organism = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
             ontology = if (is.null(spec$ont)) "BP" else spec$ont,
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    enrichKEGG = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        res <- enrichKEGG(
            gene = gene,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            keyType = if (is.null(spec$keyType)) "kegg" else spec$keyType,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            universe = if (is.null(spec$universe)) NULL else as_chr(spec$universe),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
            use_internal_data = isTRUE(spec$use_internal_data)
        )
        info <- result_table(res, "enrichKEGG")
        emit(tool = "enrichKEGG", organism = if (is.null(spec$organism)) "hsa" else spec$organism,
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    groupGO = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        res <- groupGO(
            gene = gene,
            OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
            keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
            ont = if (is.null(spec$ont)) "CC" else spec$ont,
            level = if (is.null(spec$level)) 2L else as.integer(spec$level),
            readable = isTRUE(spec$readable)
        )
        info <- result_table(res, "groupGO")
        emit(tool = "groupGO", ontology = if (is.null(spec$ont)) "CC" else spec$ont,
             level = if (is.null(spec$level)) 2L else as.integer(spec$level),
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    enrichDO = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        res <- enrichDO(
            gene = gene,
            ont = if (is.null(spec$ont)) "DO" else spec$ont,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            universe = if (is.null(spec$universe)) NULL else as_chr(spec$universe),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
            readable = isTRUE(spec$readable)
        )
        info <- result_table(res, "enrichDO")
        emit(tool = "enrichDO", ontology = if (is.null(spec$ont)) "DO" else spec$ont,
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    enrichMKEGG = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        res <- enrichMKEGG(
            gene = gene,
            organism = if (is.null(spec$organism)) "hsa" else spec$organism,
            keyType = if (is.null(spec$keyType)) "kegg" else spec$keyType,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            universe = if (is.null(spec$universe)) NULL else as_chr(spec$universe),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff)
        )
        info <- result_table(res, "enrichMKEGG")
        emit(tool = "enrichMKEGG", organism = if (is.null(spec$organism)) "hsa" else spec$organism,
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    enrichWP = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        wp_organism <- if (is.null(spec$organism)) "Homo sapiens" else spec$organism
        check_wp_organism(wp_organism)
        res <- enrichWP(
            gene = gene,
            organism = wp_organism,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff)
        )
        info <- result_table(res, "enrichWP")
        emit(tool = "enrichWP", organism = wp_organism,
             rows = info$rows, columns = I(info$columns), artifact = info$path,
             gene_count = length(gene))
    },
    enricher = {
        gene <- as_chr(spec$gene)
        if (length(gene) < 1L) fail("gene must contain at least one identifier")
        t2g <- utils::read.delim(spec$term2gene, stringsAsFactors = FALSE, header = TRUE)
        if (ncol(t2g) < 2L) fail("term2gene must have at least two columns (term, gene)")
        t2n <- NULL
        if (!is.null(spec$term2name)) {
            t2n <- utils::read.delim(spec$term2name, stringsAsFactors = FALSE, header = TRUE)
        }
        res <- enricher(
            gene = gene,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            universe = if (is.null(spec$universe)) NULL else as_chr(spec$universe),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
            TERM2GENE = t2g[, 1:2],
            TERM2NAME = if (is.null(t2n)) NA else t2n[, 1:2]
        )
        info <- result_table(res, "enricher")
        emit(tool = "enricher", rows = info$rows, columns = I(info$columns),
             artifact = info$path, gene_count = length(gene),
             term_count = length(unique(t2g[[1]])))
    },
    fail(paste0("unknown action for this module: ", action))
)
