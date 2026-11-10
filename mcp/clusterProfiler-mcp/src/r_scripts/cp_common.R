## Shared helpers for the clusterProfiler MCP wrappers.
## Every entry script activates the project renv library before loading packages.
## Nothing here reimplements clusterProfiler statistics; these helpers only
## resolve the runtime, read/write the file-based contract and serialise results.

## The R side must not depend on how the caller quotes the path: normalize it first.
normalize_path <- function(p) {
    p <- gsub("~+~", " ", p, fixed = TRUE)          # Rscript escapes spaces this way in some builds
    normalizePath(p, winslash = "/", mustWork = FALSE)
}

activate_runtime <- function() {
    ## 1. explicit library override (used by clean-runtime validation)
    lib <- normalize_path(Sys.getenv("P2A_R_LIBRARY", unset = ""))
    if (nzchar(lib) && dir.exists(lib)) {
        .libPaths(c(lib, .libPaths()))
        return(invisible(TRUE))
    }

    ## 2. project renv library, located deterministically from P2A_R_PROJECT
    proj <- Sys.getenv("P2A_R_PROJECT", unset = "")
    if (!nzchar(proj)) {
        proj <- file.path(dirname(dirname(dirname(normalizePath(sys.frame(1)$ofile %||% ".")))))
    }
    proj <- normalize_path(proj)
    renv_lib <- Sys.getenv("P2A_RENV_LIBRARY", unset = "")
    if (!nzchar(renv_lib) && nzchar(proj)) {
        root <- file.path(proj, "renv", "library")
        ## renv nests libraries as <root>/<platform>/<R-x.y>/<arch>, but a restored
        ## library may sit directly at <root>; accept any directory that really is a
        ## package library (many children with DESCRIPTION files).
        roots <- if (dir.exists(root)) c(root, list.dirs(root, recursive = TRUE)) else character(0)
        is_lib <- vapply(roots, function(d) {
            entries <- list.files(d, full.names = TRUE)
            entries <- entries[dir.exists(entries)]
            sum(file.exists(file.path(entries, "DESCRIPTION"))) >= 10L
        }, logical(1))
        roots <- roots[is_lib]
        if (length(roots)) {
            ## prefer the library that actually contains clusterProfiler
            has_pkg <- file.exists(file.path(roots, "clusterProfiler", "DESCRIPTION"))
            if (any(has_pkg)) roots <- roots[has_pkg]
            roots <- roots[order(file.info(roots)$mtime, decreasing = TRUE)]
            renv_lib <- roots[[1]]
        }
    }
    if (nzchar(renv_lib) && dir.exists(renv_lib)) {
        .libPaths(c(normalize_path(renv_lib), .libPaths()))
    }
    invisible(TRUE)
}

`%||%` <- function(x, y) if (is.null(x) || !length(x) || !nzchar(x[1])) y else x

read_json_arg <- function(path) {
    jsonlite::fromJSON(path, simplifyVector = FALSE)
}

## Accepts a JSON array of strings or a character vector.
as_chr <- function(x) {
    if (is.null(x)) return(NULL)
    v <- unlist(x, use.names = FALSE)
    as.character(v)
}

read_gene_vector <- function(path) {
    if (grepl("\\.rds$", path, ignore.case = TRUE)) {
        return(readRDS(path))
    }
    tbl <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    if (ncol(tbl) < 1L || nrow(tbl) < 1L) {
        stop("Gene file must contain at least one row and one column: ", path)
    }
    list(data = tbl)
}

write_result_table <- function(df, outdir, name = "result.csv") {
    dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
    path <- file.path(outdir, name)
    if (is.null(df) || nrow(df) == 0L || ncol(df) == 0L) {
        ## An empty upstream result has no columns; write a genuinely empty file
        ## rather than write.csv(data.frame()), which emits a stray '""' header.
        file.create(path)
        return(path)
    }
    utils::write.csv(df, path, row.names = FALSE)
    path
}

res_to_df <- function(res) {
    if (is.null(res)) return(NULL)
    as.data.frame(res)
}

## Emit the machine-readable contract: a single JSON line on stdout.
emit <- function(...) {
    payload <- list(...)
    cat(jsonlite::toJSON(payload, auto_unbox = TRUE, null = "null", digits = NA), "\n")
}

fail <- function(message, class = "P2AToolError") {
    cond <- structure(class = c(class, "error", "condition"),
                      list(message = message, call = NULL))
    stop(cond)
}

## WikiPathways: get_wp_data() matches the organism against the published GMT
## file names with grep(); an unknown organism therefore selects *no* file and
## read.gmt.wp() quietly yields an empty library, which enrichWP()/gseWP() turn
## into NULL -> a "0 enriched terms" success.  Validate against the organism
## list clusterProfiler itself publishes and fail loudly instead.
## If the listing cannot be fetched the check is skipped: the real call will
## then fail with the upstream network error, which is the honest message.
check_wp_organism <- function(organism) {
    supported <- tryCatch(get_wp_organisms(), error = function(e) NULL)
    if (is.null(supported) || !length(supported)) return(invisible(organism))
    if (!organism %in% supported) {
        fail(paste0("unsupported WikiPathways organism: ", organism,
                    ". Supported organisms: ",
                    paste(supported, collapse = "; ")))
    }
    invisible(organism)
}

## paths ---------------------------------------------------------------
arg_paths <- function(args, outdir, tag) {
    dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
    list(dir = outdir,
         table = file.path(outdir, paste0(tag, ".csv")),
         json = file.path(outdir, paste0(tag, ".json")))
}

## A ranked list is a two-column table (identifier, statistic). Sorting and naming
## here reproduces the upstream geneList contract for gseGO()/gseKEGG().
read_ranked_list <- function(path) {
    tbl <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    if (ncol(tbl) < 2L) fail("ranked list file must have two columns: identifier and statistic")
    ids <- as.character(tbl[[1]])
    stats <- suppressWarnings(as.numeric(tbl[[2]]))
    if (anyNA(stats)) fail("ranked list statistic column must be numeric")
    if (anyDuplicated(ids)) fail("ranked list identifiers must be unique")
    ord <- order(stats, decreasing = TRUE)
    stats <- stats[ord]
    names(stats) <- ids[ord]
    stats
}
