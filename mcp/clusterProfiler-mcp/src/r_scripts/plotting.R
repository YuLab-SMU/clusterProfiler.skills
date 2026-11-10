#!/usr/bin/env Rscript
## Enrichment plots: run the upstream ORA/GSEA, then hand the result object to the
## upstream plotting function (enrichplot::dotplot / barplot / gseaplot2).
## The PNG is written next to the CSV; no plot is redrawn by hand.

args_all <- commandArgs(trailingOnly = FALSE)
## Rscript encodes spaces in --file as "~+~"; decode before sourcing siblings so the
## package works from directories with spaces in their path.
script_dir <- gsub("~+~", " ", dirname(sub("^--file=", "", args_all[grep("^--file=", args_all)])), fixed = TRUE)
source(file.path(script_dir, "cp_common.R"))
activate_runtime()

suppressPackageStartupMessages({
    library(clusterProfiler)
    library(enrichplot)
    library(jsonlite)
    library(ggplot2)
})

cmd <- commandArgs(trailingOnly = TRUE)
action <- cmd[[1]]
spec <- read_json_arg(cmd[[2]])
outdir <- spec$outdir
if (is.null(outdir) || !nzchar(outdir)) fail("outdir is required")
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

width <- if (is.null(spec$width)) 8 else as.numeric(spec$width)
height <- if (is.null(spec$height)) 6 else as.numeric(spec$height)
dpi <- if (is.null(spec$dpi)) 150 else as.numeric(spec$dpi)
show_n <- if (is.null(spec$show_n)) 20L else as.integer(spec$show_n)

## rebuild the result object the plot needs, using the same upstream call as the
## corresponding analysis tool
enrich_result <- function() {
    if (!is.null(spec$gene)) {
        return(enrichGO(
            gene = as_chr(spec$gene),
            OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
            keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
            ont = if (is.null(spec$ont)) "BP" else spec$ont,
            pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
            pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
            qvalueCutoff = if (is.null(spec$qvalueCutoff)) 0.2 else as.numeric(spec$qvalueCutoff),
            minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
            maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize)
        ))
    }
    gl <- read_ranked_list(spec$geneListFile)
    gseGO(
        geneList = gl,
        OrgDb = if (is.null(spec$OrgDb)) "org.Hs.eg.db" else spec$OrgDb,
        keyType = if (is.null(spec$keyType)) "ENTREZID" else spec$keyType,
        ont = if (is.null(spec$ont)) "BP" else spec$ont,
        pvalueCutoff = if (is.null(spec$pvalueCutoff)) 0.05 else as.numeric(spec$pvalueCutoff),
        pAdjustMethod = if (is.null(spec$pAdjustMethod)) "BH" else spec$pAdjustMethod,
        minGSSize = if (is.null(spec$minGSSize)) 10L else as.integer(spec$minGSSize),
        maxGSSize = if (is.null(spec$maxGSSize)) 500L else as.integer(spec$maxGSSize),
        verbose = FALSE,
        seed = FALSE
    )
}

res <- enrich_result()
df <- res_to_df(res)
if (is.null(df) || nrow(df) == 0L) fail("the upstream analysis returned no terms to plot")

csv_path <- write_result_table(df, outdir, "plot_data.csv")
png_path <- file.path(outdir, paste0(action, ".png"))

p <- switch(action,
    dotplot = enrichplot::dotplot(res, showCategory = show_n),
    barplot = barplot(res, showCategory = show_n),
    fail(paste0("unknown plot action: ", action))
)

ggplot2::ggsave(png_path, plot = p, width = width, height = height, dpi = dpi, bg = "white")
if (!file.exists(png_path)) fail("plot file was not created")

emit(tool = action, terms_plotted = min(show_n, nrow(df)), rows = nrow(df),
     artifact = png_path, data_artifact = csv_path,
     width = width, height = height, dpi = dpi)
