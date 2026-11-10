#!/usr/bin/env python3
"""clusterProfiler MCP server.

Mounts the tool modules generated from the YuLab-SMU/clusterProfiler repository.
All scientific computation runs in the pinned R package; this process only
validates inputs, invokes the R dispatchers and serialises their results.
"""

from __future__ import annotations

import sys
from pathlib import Path

from fastmcp import FastMCP

SRC = Path(__file__).resolve().parent
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

TOOLS = SRC / "tools"
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

from tools import (compare_clusters, enrichment_ora, extra_backends,  # noqa: E402
                   gene_sets, gsea, id_mapping, postprocess)

mcp = FastMCP("clusterProfiler")

mcp.mount(enrichment_ora.mcp)
mcp.mount(gsea.mcp)
mcp.mount(compare_clusters.mcp)
mcp.mount(id_mapping.mcp)
mcp.mount(extra_backends.mcp)
mcp.mount(postprocess.mcp)
mcp.mount(gene_sets.mcp)


if __name__ == "__main__":
    mcp.run()
