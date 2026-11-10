#!/usr/bin/env Rscript
## Gene-set libraries: load a GMT file or build one from an OrgDb with the upstream
## readers (clusterProfiler::read.gmt, gson_GO / gson_KEGG), then hand the result to
## enrich_custom_sets. Nothing here parses GMT itself.

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

as_term2gene <- function(obj) {
    ## gson_GO()/gson_KEGG() return a GSON S4 object whose gsid2gene slot is already
    ## a (term, gene) table.
    if (isS4(obj) && "gsid2gene" %in% slotNames(obj)) {
        t2g <- slot(obj, "gsid2gene")
        if (ncol(t2g) < 2L) fail("GSON object has no gene table")
        return(data.frame(term = as.character(t2g[[1]]), gene = as.character(t2g[[2]]),
                          stringsAsFactors = FALSE))
    }
    if (is.data.frame(obj)) {
        if (ncol(obj) < 2L) fail("gene set table must have at least two columns")
        return(data.frame(term = as.character(obj[[1]]), gene = as.character(obj[[2]]),
                          stringsAsFactors = FALSE))
    }
    if (is.list(obj)) {
        return(data.frame(term = rep(names(obj), lengths(obj)),
                          gene = unlist(obj, use.names = FALSE),
                          stringsAsFactors = FALSE))
    }
    fail("unsupported gene set object")
}

switch(action,
    readGMT = {
        gmt <- spec$gmtFile
        if (is.null(gmt) || !file.exists(gmt)) fail(paste0("GMT file not found: ", gmt))
        obj <- read.gmt(gmt)
        t2g <- as_term2gene(obj)
    },
    gsonGO = {
        obj <- gson_GO(
            OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
            keytype = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
            ont = if (is.null(spec$ont)) "BP" else spec$ont
        )
        t2g <- as_term2gene(obj)
    },
    gsonKEGG = {
        ## gson_KEGG() forwards KEGG_Type straight to download_KEGG(), which only
        ## branches on `keggType == "KEGG"`: anything else silently becomes the
        ## KEGG *module* library.  Keep the upstream default ("KEGG" = pathways)
        ## so build_kegg_sets really returns pathway gene sets.
        obj <- gson_KEGG(
            species = if (is.null(spec$organism)) "hsa" else spec$organism,
            KEGG_Type = if (is.null(spec$keggType)) "KEGG" else spec$keggType,
            keyType = if (is.null(spec$keyType)) "kegg" else spec$keyType
        )
        t2g <- as_term2gene(obj)
    },
    fail(paste0("unknown action for this module: ", action))
)

raw_rows <- nrow(t2g)
keep <- !is.na(t2g$term) & !is.na(t2g$gene) & nzchar(t2g$term) & nzchar(t2g$gene)
dropped <- raw_rows - sum(keep)
t2g <- t2g[keep, , drop = FALSE]
if (nrow(t2g) == 0L) fail("the gene set library is empty")

path <- file.path(outdir, "gene_sets.tsv")
utils::write.table(t2g, path, sep = "\t", quote = FALSE, row.names = FALSE)

emit(tool = action, sets = length(unique(t2g$term)), genes = length(unique(t2g$gene)),
     memberships = nrow(t2g), artifact = path,
     rows_read = raw_rows, dropped_empty_fields = dropped,
     set_size_median = stats::median(as.integer(table(t2g$term))))
