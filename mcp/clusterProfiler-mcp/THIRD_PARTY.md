# Provenance and licences

## clusterProfiler

- Repository: https://github.com/YuLab-SMU/clusterProfiler
- Revision: `1e8b585586a9319bbd366cf27955f565eac380ea` (branch `RELEASE_3_22`), version 4.18.2
- Licence: Artistic-2.0
- Citation: Xu S, Hu E, Cai Y, et al. Using clusterProfiler to characterize multiomics data.
  *Nature Protocols* 19:3292-3320 (2024). doi:10.1038/s41596-024-01020-z
- The package is **not** vendored here; it is installed from Bioconductor 3.22 as pinned by
  `r-runtime/renv.lock`. The R scripts in `src/r_scripts/` only call its public API.

## Annotation data

- `org.Hs.eg.db` 3.22.0, `GO.db` 3.22.0 (Bioconductor annotation packages)
- KEGG pathway data is fetched at runtime from `rest.kegg.jp` (KEGG usage terms apply).

## Python

- `fastmcp` (Apache-2.0), `mcp` (MIT). Installed from PyPI via `src/requirements.txt`.
