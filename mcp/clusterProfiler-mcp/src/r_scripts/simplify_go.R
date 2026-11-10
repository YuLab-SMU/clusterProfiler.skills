#!/usr/bin/env Rscript
## GO term simplification: run enrichGO, then reduce redundant terms with
## clusterProfiler::simplify(). Both steps are upstream calls; this script only
## marshals arguments and writes the reduced table.

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
spec_path <- cmd[[1]]
spec <- read_json_arg(spec_path)
outdir <- spec$outdir
if (is.null(outdir) || !nzchar(outdir)) fail("outdir is required")
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

gene <- as_chr(spec$gene)
if (length(gene) < 1L) fail("gene must contain at least one identifier")

## 1. upstream ORA
ego <- enrichGO(
    gene = gene,
    OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
    keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
    ont = if (is.null(spec$ont)) "BP" else spec$ont,
    pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
    pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
    qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
    minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
    maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
    readable = isTRUE(spec$readable)
)

before <- nrow(as.data.frame(ego))

## 2. upstream simplification
## simplify() would call GOSemSim::godata(ont = ontology) with no OrgDb, which always
## returns the *human* GO structure no matter which organism was analysed. Build the
## semantic data from the OrgDb that produced this result and pass it explicitly, so a
## non-human analysis cannot silently be simplified against human GO similarity.
measure <- if (is.null(spec$measure)) "Wang" else spec$measure
orgdb <- if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb
if (!orgdb %in% rownames(installed.packages())) {
    fail(paste0("OrgDb package is not installed: ", orgdb))
}
## IC-based measures (Resnik/Rel/Jiang/Lin) need computeIC = TRUE; Wang does not.
sem <- GOSemSim::godata(OrgDb = orgdb, ont = if (is.null(spec$ont)) "BP" else spec$ont,
                        computeIC = !identical(measure, "Wang"))
sim <- simplify(
    ego,
    cutoff = if (is.null(spec$cutoff)) 0.7 else as.numeric(spec$cutoff),
    by = if (is.null(spec$by)) "p.adjust" else spec$by,
    select_fun = min,
    measure = measure,
    semData = sem
)

df <- res_to_df(sim)
path <- write_result_table(df, outdir, "simplifyGO.csv")
emit(tool = "simplifyGO", ontology = if (is.null(spec$ont)) "BP" else spec$ont,
     cutoff = if (is.null(spec$cutoff)) 0.7 else as.numeric(spec$cutoff),
     measure = measure, semData_orgdb = orgdb, semData_ont = sem@ont,
     rows_before = before, rows = if (is.null(df)) 0L else nrow(df),
     columns = I(if (is.null(df)) character(0) else colnames(df)),
     artifact = path, gene_count = length(gene))
