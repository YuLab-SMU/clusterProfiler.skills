# clusterProfiler MCP server

Turns the [YuLab-SMU/clusterProfiler](https://github.com/YuLab-SMU/clusterProfiler) R package
into MCP tools, so an agent can run enrichment analysis through the package's own public API.

- Source revision: `YuLab-SMU/clusterProfiler` @ `RELEASE_3_22`
  (`1e8b585586a9319bbd366cf27955f565eac380ea`), package version **4.18.2**
- Bioconductor **3.22**, R **4.5.2** (tested on macOS arm64)

Every scientific computation is executed by the pinned R package. The Python layer only
validates inputs, calls `Rscript`, and serialises the CSV artifacts the R side writes.

## Delivered tools

| Tool | Upstream call | What it does |
| --- | --- | --- |
| `enrich_go` | `clusterProfiler::enrichGO` | GO over-representation analysis of a gene list |
| `enrich_kegg` | `clusterProfiler::enrichKEGG` | KEGG pathway over-representation analysis (online KEGG data) |
| `enrich_kegg_module` | `clusterProfiler::enrichMKEGG` | KEGG module over-representation analysis |
| `enrich_wikipathways` | `clusterProfiler::enrichWP` | WikiPathways over-representation analysis (live library) |
| `classify_go_levels` | `clusterProfiler::groupGO` | direct GO classification at a chosen level (no test) |
| `enrich_custom_sets` | `clusterProfiler::enricher` | ORA against user-supplied TERM2GENE/TERM2NAME files |
| `gsea_go` | `clusterProfiler::gseGO` | GO gene set enrichment of a ranked list |
| `gsea_kegg` | `clusterProfiler::gseKEGG` | KEGG pathway gene set enrichment |
| `gsea_kegg_module` | `clusterProfiler::gseMKEGG` | KEGG module gene set enrichment |
| `gsea_wikipathways` | `clusterProfiler::gseWP` | WikiPathways gene set enrichment |
| `compare_clusters` | `clusterProfiler::compareCluster` | per-cluster enrichment across gene clusters |
| `simplify_go` | `clusterProfiler::simplify` | reduce redundant GO terms after ORA (returns before/after counts, `measure` = Wang/Resnik/Rel/Jiang/Lin) |
| `plot_ora` | `enrichplot::dotplot` / `barplot` | dot or bar plot of an ORA result, saved as PNG |
| `map_gene_ids` | `clusterProfiler::bitr` | identifier mapping between key types |
| `list_key_types` | `clusterProfiler::idType` | key types an OrgDb supports |
| `load_gmt` | `clusterProfiler::read.gmt` | load a GMT library as a reusable TERM2GENE table |
| `build_go_sets` | `clusterProfiler::gson_GO` | build the GO gene set library for an OrgDb |
| `build_kegg_sets` | `clusterProfiler::gson_KEGG` | build the KEGG pathway gene set library |

Every result carries `rows` (or `sets` for the library tools), `columns`, a `preview` (first 25
rows), and `artifacts` (absolute paths to the complete CSV/TSV, plus a PNG for `plot_ora`).
`plot_ora` is the only tool that returns an image; the plotting is done by enrichplot itself,
not by the wrapper.

## Requirements

- R 4.2+ with the package set recorded in `r-runtime/renv.lock` (built and tested on 4.5.2).
  The lockfile pins `clusterProfiler` 4.18.2, `org.Hs.eg.db` 3.22.0, `GO.db` 3.22.0,
  `enrichplot` 1.30.5, `DOSE` 4.4.0, `GOSemSim` 2.36.0, `fgsea` 1.36.2 and their closure.
- Python 3.11+ with `fastmcp` (see `src/requirements.txt`).
- Network access for `enrich_kegg` / `gsea_kegg` unless you pass `use_internal_data=True`
  and have an offline KEGG snapshot.

## Install

```bash
# 1. Python runtime
python3 -m venv .venv
.venv/bin/pip install -r src/requirements.txt

# 2. R runtime (independent library restored from the lockfile)
Rscript -e 'install.packages("renv", repos = "https://cloud.r-project.org")'
Rscript -e 'renv::restore(project = "r-runtime", library = "r-runtime/renv/library",
                          prompt = FALSE, clean = TRUE)'
```

`renv::restore()` needs write access to `r-runtime/`. On a shared cluster, restore into
your own `renv` library path and point `P2A_R_LIBRARY` at it instead.

## Start the server

```bash
.venv/bin/python src/project_mcp.py        # stdio transport
```

Environment variables (all optional):

| Variable | Meaning |
| --- | --- |
| `P2A_RSCRIPT` | `Rscript` executable to use (default: first on `PATH`) |
| `P2A_R_LIBRARY` | absolute R library to put first on `.libPaths()` (clean/relocated runtimes) |
| `P2A_R_PROJECT` | renv project root; defaults to the package's own `r-runtime/` |
| `P2A_OUTPUT_ROOT` | directory for per-call artifact folders (default: system temp) |
| `P2A_R_TIMEOUT` | per-call timeout in seconds (default 900) |

## Client configuration

```json
{
  "mcpServers": {
    "clusterProfiler": {
      "command": "/absolute/path/to/.venv/bin/python",
      "args": ["/absolute/path/to/clusterProfiler-mcp/src/project_mcp.py"]
    }
  }
}
```

## Input formats

- **Gene list**: JSON array of identifier strings in the key type you name (`enrich_go`,
  `enrich_kegg`, `classify_go_levels`, `map_gene_ids`, `enrich_custom_sets`).
- **Ranked list** (`gsea_go`, `gsea_kegg`): a two-column CSV/TSV with header,
  column 1 = identifier, column 2 = numeric statistic (e.g. log2 fold change). Unsorted input
  is sorted decreasing by the wrapper, matching the upstream contract.
- **TERM2GENE** (`enrich_custom_sets`): header-delimited file with columns `term`, `gene`;
  **TERM2NAME** optional, columns `term`, `name`.
- **Clusters** (`compare_clusters`): header-delimited file with columns `cluster`, `gene`.
  Group labels come from this file; the wrapper never invents them.

## Reproducibility notes

- `gsea_go` / `gsea_kegg` apply `set.seed(seed)` (default `0`) before the upstream call, because
  fgsea's multilevel p-values depend on the RNG. Identical inputs and seed reproduce the table;
  without a seed, repeated upstream runs legitimately differ in a few gene sets near the cutoff.
- `enrich_kegg` / `gsea_kegg` read live KEGG data unless `use_internal_data=True`; KEGG content
  changes over time, so results are only comparable within the same snapshot.

## Validation performed

- All 18 tools called through the MCP stdio client in three independent setups: the project
  environment, a clean environment with a separately restored R library, and the unzipped
  release inside a directory whose path contains a space.
- ORA tables compared row-by-row and ID-by-ID against direct `Rscript` runs of the same
  upstream functions, including p-value, adjusted p-value and q-value equality.
- Seeded GSEA tables reproduced exactly across repeated tool calls.
- Changed inputs (`ont`, `pvalue_cutoff`, `min_gs_size`) verified to change results, and invalid
  inputs (empty gene list, missing file, unknown `fun`) verified to return tool errors.

## Limits

- These 18 operations are exposed. Not included: the LLM interpretation layer
  (`interpret`, `mechanism_*`), topology-aware `enrichit` workflows (the dependency is not
  installable on Bioconductor 3.22, which is why the repo is pinned to `RELEASE_3_22`), the
  DAVID wrapper, and the remaining enrichplot views (`cnetplot`, `emapplot`, `gseaplot2`,
  `ridgeplot`, `heatplot`, `upsetplot`).
- `enrichDO`/`gseDO` are deliberately absent: DOSE 4.4.0 no longer ships the Disease Ontology
  annotation, so the upstream call fails with "ontology not supported yet".
- OrgDb packages other than `org.Hs.eg.db` must be installed in the R library before use.
- `compare_clusters` supports `enrichGO`, `enrichKEGG`, `enricher`, `groupGO`, `gseGO`, `gseKEGG`
  and forwards only the arguments each of those functions accepts.
- `enrich_wikipathways`, `gsea_wikipathways`, `enrich_kegg_module`, `gsea_kegg_module` and
  `build_kegg_sets` read live KEGG/WikiPathways data, so their results follow the current library
  rather than a pinned snapshot. Two runs weeks apart are not comparable.
- KEGG **modules** are few and large (about 130 for `hsa`), so `enrich_kegg_module` legitimately
  returns only a handful of rows even for a 1 200-gene list (4 at p < 0.05, 7 at p = 1). A short
  table is not a sign of failed mapping.
- `simplify_go` builds its semantic data from the OrgDb that produced the result and passes it to
  `simplify()` explicitly. Left to itself, `simplify()` calls `GOSemSim::godata(ont = ...)` with no
  OrgDb and therefore always uses the **human** GO structure, whichever organism was analysed. The
  response reports `sem_data_orgdb` so the provenance is visible.
- `load_gmt` reports `rows_read` and `dropped_empty_fields`: a GMT line with no genes produces no
  TERM2GENE row, and the count of such drops is returned rather than silently absorbed.
