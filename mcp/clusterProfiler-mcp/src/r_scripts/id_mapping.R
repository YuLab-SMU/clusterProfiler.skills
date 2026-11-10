#!/usr/bin/env Rscript
## Identifier utilities: bitr and idType.
## These call the upstream AnnotationDbi-backed clusterProfiler helpers; no
## identifier mapping is reimplemented here.

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

switch(action,
    bitr = {
        genes <- as_chr(spec$gene)
        if (length(genes) < 1L) fail("gene must contain at least one identifier")
        orgdb <- if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb
        to_type <- as_chr(spec$toType)
        if (length(to_type) < 1L) fail("toType must contain at least one key type")
        from_type <- if (is.null(spec$fromType)) "ENTREZID" else spec$fromType
        df <- suppressWarnings(bitr(genes, fromType = from_type, toType = to_type, OrgDb = orgdb))
        path <- file.path(outdir, "bitr.csv")
        utils::write.csv(df, path, row.names = FALSE)
        ## bitr() drops unmapped keys and can return several rows per key
        ## (1:many mappings), so report both counts explicitly.
        mapped_keys <- unique(as.character(df[[from_type]]))
        emit(tool = "bitr", OrgDb = orgdb, fromType = from_type, toType = I(to_type),
             input_count = length(unique(genes)),
             mapped_count = length(mapped_keys),
             rows = nrow(df),
             unmapped_count = length(setdiff(unique(genes), mapped_keys)),
             columns = I(colnames(df)), artifact = path)
    },
    idType = {
        orgdb <- if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb
        types <- idType(orgdb)
        path <- file.path(outdir, "idType.csv")
        utils::write.csv(data.frame(keyType = types), path, row.names = FALSE)
        emit(tool = "idType", OrgDb = orgdb, key_types = I(as.character(types)),
             artifact = path)
    },
    fail(paste0("unknown action for this module: ", action))
)
