# clusterProfiler.skills

Agent-readable material for [clusterProfiler](https://github.com/YuLab-SMU/clusterProfiler),
built from the package's own publications and a pinned release of its source code.

| Component | Path | Contents |
| --- | --- | --- |
| Paper skill | [`skills/clusterprofiler-papers/`](skills/clusterprofiler-papers/) | 22 files — reading guide, reviewed full texts, figures and tables of four papers |
| MCP server | [`mcp/clusterProfiler-mcp/`](mcp/clusterProfiler-mcp/) | Python MCP server exposing 18 clusterProfiler operations over stdio |
| MCP archive | [`mcp/clusterProfiler-mcp.zip`](mcp/clusterProfiler-mcp.zip) | the same server, packaged; sha256 `aa5a6f3d…` |

Both components were produced by a Paper2Agent conversion: the paper skill is a reviewed reading
package, and every MCP tool is a thin wrapper over the pinned R package rather than a
reimplementation of its statistics.

## Papers

- Yu G (2024). Thirteen years of clusterProfiler. *The Innovation* 5(6):100722.
  doi:[10.1016/j.xinn.2024.100722](https://doi.org/10.1016/j.xinn.2024.100722)
- Xu S, Hu E, Cai Y, et al. (2024). Using clusterProfiler to characterize multiomics data.
  *Nature Protocols* 19(11):3292–3320. doi:[10.1038/s41596-024-01020-z](https://doi.org/10.1038/s41596-024-01020-z)
- Wu T, Hu E, Xu S, et al. (2021). clusterProfiler 4.0: a universal enrichment tool for
  interpreting omics data. *The Innovation* 2(3):100141.
  doi:[10.1016/j.xinn.2021.100141](https://doi.org/10.1016/j.xinn.2021.100141)
- Yu G, Wang L-G, Han Y, He Q-Y (2012). clusterProfiler: an R package for comparing biological
  themes among gene clusters. *OMICS* 16(5):284–287.
  doi:[10.1089/omi.2011.0118](https://doi.org/10.1089/omi.2011.0118)

## Use the paper skill

Copy or symlink `skills/clusterprofiler-papers/` into your agent's skill directory — for DeepSeek
Harness that is `~/.agents/skills/`. It has no runtime dependency: markdown, JPEG and CSV only.

`SKILL.md` routes an agent to `references/index.md`; from there the agent searches
`references/paper.md` and `references/supplement.md` by heading and reads figures and tables out of
`assets/`. Reading the whole of both documents is discouraged — they are ~195 000 characters of
continuous prose.

## Use the MCP server

```bash
unzip clusterProfiler-mcp.zip && cd clusterProfiler-mcp
python3 -m venv .venv && .venv/bin/pip install -r src/requirements.txt
Rscript -e 'renv::restore(project = "r-runtime", library = "r-runtime/renv/library", prompt = FALSE)'
.venv/bin/python src/project_mcp.py
```

The R library is restored from `r-runtime/renv.lock` at install time (26 packages, ~680 MB), which
is why the archive ships the lockfile rather than compiled binaries. `mcp/clusterProfiler-mcp/USAGE.md`
documents the 18 tools, their parameters, the input file formats, the environment variables and the
reproducibility rules.

Client configuration:

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

## What was verified

**Paper skill.** `paper_bundle.py verify --strict` exits 0 with status `reviewed_with_limitations`.
Every page of the four sources carries a page-specific review note, and each remaining extractor
diagnostic was adjudicated against the visible page (PMC furniture, per-reference link decorations,
fused superscripts, hyphenated DOIs, unreadable OCR form pages). Figures come from publisher
artwork, not crops of the printed pages.

**MCP server.** 18 tools, 22 acceptance cases, passing in three independent setups: the development
environment, a clean environment with a separately restored R library, and the unzipped release
inside a directory whose path contains a space. Tools were checked against direct `Rscript` runs of
the same upstream functions in two independent verification rounds (9 tools each, 8 defects found
and repaired). Runtime: R 4.5.2, Bioconductor 3.22, clusterProfiler 4.18.2 from
`YuLab-SMU/clusterProfiler@1e8b585`.

## Limitations

- The full texts of three papers come from PMC HTML printings: Cell Press and Mary Ann Liebert
  return 403 for the publisher PDFs and Europe PMC reports them as not open access. Their artwork
  nevertheless comes from publisher files. The Nature Protocols 2024 PDF is a copy supplied by its
  authors.
- `reviewed_with_limitations` is not a claim of scientific accuracy: it records that every page was
  read and every flagged diagnostic was adjudicated, on top of mechanical checks.
- The MCP server was validated on macOS arm64 only (R 4.5.2 / Bioconductor 3.22).
- Only `org.Hs.eg.db` is installed; `simplify_go` on a non-human OrgDb falls back to the human GO
  structure — an upstream trap the wrapper reports but does not block.
- `enrich_kegg`, `gsea_kegg` and the WikiPathways tools read live annotation services, so results
  follow the current library rather than a pinned snapshot. KEGG module analysis legitimately
  returns few rows.
- `enrichDO` / `gseaDO` are not delivered: DOSE 4.4.0 no longer ships the Disease Ontology
  annotation. `plot_gsea` is not delivered either, because its results were not reproducible.

## Licence and provenance

clusterProfiler is Artistic-2.0; annotation data carries its own Bioconductor and KEGG terms. See
`mcp/clusterProfiler-mcp/THIRD_PARTY.md`. The paper texts and figures remain under their
publishers' copyright and are reproduced here for reference alongside the corresponding citations;
the code in `mcp/` is distributed under the terms of the upstream package.
