# Supplementary information

# Thirteen years of clusterProfiler

Innovation (Camb). 2024 Oct 21;5(6):100722. doi: 10.1016/j.xinn.2024.100722

Guangchuang Yu<sup>1,∗</sup>

PMCID: PMC11551487  PMID: 39529960

Dear Editor,

When the human genome was fully sequenced in 2003, research focus shifted to functional genomics, particularly the spatiotemporal expression of genes, which is crucial for understanding organism development, functional regulation, and disease mechanisms. A key step in this process is uncovering the biological pathways involved. The first bioinformatics tool for analyzing biological pathways using Gene Ontology (GO) was GO::TermFinder, a Perl module published in 2004 that implemented the over-representation analysis method.<sup>1</sup> Shortly thereafter, in 2005, the gene set enrichment analysis (GSEA) method was introduced.<sup>2</sup> Various information content-based methods for measuring semantic similarity were adapted for use with GO, and in 2007, Wang proposed a graph-based approach to measure GO semantic similarity. In 2008, I developed GOSemSim, which implemented multiple GO semantic similarity measures, including information content and graph structure algorithms.<sup>3</sup> These tools, which mine biological knowledge, rely heavily on gene functional information accumulated during the Human Genome Project era.

However, these tools were primarily designed for model organisms. One of the motivations behind developing clusterProfiler was my desire to extend pathway analysis to non-model organisms. Additionally, all tools at that time were created for case-control experimental designs. I wanted to apply pathway analysis to more complex biological experiments with multiple conditions, which is the inspiration for the software’s name—it profiles biological themes across different gene clusters (Figure 1). This comparative approach to biological themes is an innovation of clusterProfiler. In the v.4.0 paper, we applied it to compare the pathways perturbed by different drugs over time.<sup>4</sup> In a protocol published in 2024, we demonstrated its use in comparing microbiome and metabolome data across disease subtypes, characterizing transcription factors and their functions activated under stress at different time points and analyzing cell type enrichment in single-cell clusters.<sup>5</sup>

Figure 1.

[Figure 1](../assets/supp_figs/supplementary-figure-pac2024-1.jpg)

clusterProfiler: Elucidating genomic insights with a Nuwa allegory

Through the lens of the Chinese myth of Nuwa creating humans, depicted in the style of Dunhuang murals, we can illustrate the function and value of clusterProfiler. In this analogy, clusterProfiler is the architect, like Nuwa, carefully analyzing coding and non-coding multiomics data across species. Its work is grounded in updated gene annotation references, represented by the mountain in the mural. Just as Nuwa shaped humanity, clusterProfiler provides a flexible platform for systematically exploring biological mechanisms and states, deepening our understanding of complex phenomena. The results it generates can be compared to the miniature humans Nuwa created. Like her hands, the clean interface of clusterProfiler allows researchers to easily access, manage, and visualize enrichment results. Moreover, as Nuwa created tribes with unique traits, clusterProfiler compares data from multiple treatments and time points in a single run, simplifying the process of identifying functional similarities and differences across conditions.

The development of clusterProfiler began in 2011, with the first version published in 2012.<sup>6</sup> We initially applied it to study biological pathways regulated by cobalt- and nickel-binding proteins in _Streptococcus pneumoniae_ and to compare host pathways regulated by human virus-encoded microRNAs.<sup>7,8</sup> We have continuously maintained and updated clusterProfiler, with over 12,000 commits to the codebase. In 2013, we added the GSEA method, and in 2016, we adopted the fgsea algorithm to accelerate the computation.<sup>9</sup> In early versions, KEGG.db was used as the data source of KEGG pathway analysis, but with changes to KEGG’s licensing, KEGG.db stopped updating. In 2015, clusterProfiler began supporting KEGG analysis by fetching the latest data online via HTTP, allowing analysis for all species available on the KEGG website. clusterProfiler also supports WikiPathways and PathwayCommons, and we developed tools for analyzing disease ontology, Reactome pathways, and Medical Subject Headings.<sup>10</sup>

Developing methods for specific biological knowledge databases cannot always keep up with newly emerging resources or support custom user-defined databases. To address this, in 2015, clusterProfiler began supporting general pathway enrichment analysis methods, enabling users to analyze new or custom databases, expanding the scope beyond just biological pathways. My other R packages have also supported clusterProfiler’s capabilities. These include GOSemSim for calculating semantic similarity, which can be used to remove redundant pathways for enrichment results<sup>3</sup>; ChIPseeker for annotating genomic locations, applicable to functional enrichment analysis of epigenomic data<sup>11</sup>; and ggtree for displaying the hierarchical relationships in enrichment results. Additionally, in the enrichplot package, we have continually developed new visualization methods to help users better interpret and present enrichment analysis results.

Each month, clusterProfiler is downloaded over 18,000 times via Bioconductor and has been integrated into more than 40 bioinformatics software tools, making it one of the foundational tools in bioinformatics analysis. Over 13 years of development, we have seen clusterProfiler applied to explore individual development, molecular mechanisms of diseases, and drug mechanisms of action. We have also witnessed its use in analyzing data from new technologies, including single-cell transcriptomics and spatial transcriptomics. In the future, I will continue to maintain, update, and add new features to meet the needs of new applications.

## Acknowledgments

This work was supported by a grant from the National Natural Science Foundation of China (32270677).

## Declaration of interests

The authors declared no competing interest.

Published Online: October 21, 2024

## References

1. Boyle E.I., Weng S., Gollub J., et al. GO::TermFinder—open source software for accessing Gene Ontology information and finding significantly enriched Gene Ontology terms associated with a list of genes. Bioinformatics. 2004;20:3710–3715. doi: 10.1093/bioinformatics/bth456.

2. Subramanian A., Tamayo P., Mootha V.K., et al. Gene set enrichment analysis: A knowledge-based approach for interpreting genome-wide expression profiles. Proc. Natl. Acad. Sci. USA. 2005;102:15545–15550. doi: 10.1073/pnas.0506580102.

3. Yu G., Li F., Qin Y., et al. GOSemSim: an R package for measuring semantic similarity among GO terms and gene products. Bioinformatics. 2010;26:976–978. doi: 10.1093/bioinformatics/btq064.

4. Wu T., Hu E., Xu S., et al. clusterProfiler 4.0: A universal enrichment tool for interpreting omics data. Innovation. 2021;2 doi: 10.1016/j.xinn.2021.100141.

5. Xu S., Hu E., Cai Y., et al. Using clusterProfiler to characterize multiomics data. Nat. Protoc. 2024;19:3292–3320. doi: 10.1038/s41596-024-01020-z.

6. Yu G., Wang L.G., Han Y., et al. clusterProfiler: an R Package for Comparing Biological Themes Among Gene Clusters. OMICS J. Integr. Biol. 2012;16:284–287. doi: 10.1089/omi.2011.0118.

7. Sun X., Yu G., Xu Q., et al. Putative cobalt- and nickel-binding proteins and motifs in Streptococcus pneumoniae. Metallomics. 2013;5:928–935. doi: 10.1039/C3MT00126A.

8. Yu G., He Q.Y. Functional similarity analysis of human virus-encoded miRNAs. J. Clin. Bioinf. 2011;1:15. doi: 10.1186/2043-9113-1-15.

9. Korotkevich G., Sukhov V., Budin N., et al. Fast gene set enrichment analysis. bioRxiv. 2021 doi: 10.1101/060012. Preprint at.

10. Yu G. Using meshes for MeSH term enrichment and semantic analyses. Bioinformatics. 2018;34:3766–3767. doi: 10.1093/bioinformatics/bty410.

11. Wang Q., Li M., Wu T., et al. Exploring Epigenomic Datasets by ChIPseeker. Curr. Protoc. 2022;2:e585. doi: 10.1002/cpz1.585.

OMICS. 2012 May;16(5):284–287. doi: 10.1089/omi.2011.0118

# clusterProfiler: an R Package for Comparing Biological Themes Among Gene Clusters

Guangchuang Yu<sup>1</sup>, Li-Gen Wang<sup>2</sup>, Yanyan Han<sup>1</sup>, Qing-Yu He<sup>1,✉</sup>

PMCID: PMC3339379  PMID: 22455463

## Abstract

Increasing quantitative data generated from transcriptomics and proteomics require integrative strategies for analysis. Here, we present an R package, clusterProfiler that automates the process of biological-term classification and the enrichment analysis of gene clusters. The analysis module and visualization module were combined into a reusable workflow. Currently, clusterProfiler supports three species, including humans, mice, and yeast. Methods provided in this package can be easily extended to other species and ontologies. The clusterProfiler package is released under Artistic-2.0 License within Bioconductor project. The source code and vignette are freely available at http://bioconductor.org/packages/release/bioc/html/clusterProfiler.html

## Introduction

In the current postgenomic era, high-throughput experimental techniques including microarray, RNA-Seq, and mass spectrometry were used to detect cellular molecules at the systems level. These kinds of analyses generate huge quantities of data, and thus drive the development of data-mining techniques to capture biological information. A commonly used approach is via clustering in the gene dimension for grouping different genes based on their similarities, such as expression pattern (Yeung et al., 2003), semantic similarity (Yu et al., 2010), and structure of PPI network (Asur et al., 2007). Clustering analysis is widely used to reveal the hidden patterns at the systems level, in particular, to look for shared promoters or regulators, to classify biological processes, to predict poorly characterized or novel genes in coexpression with known functions, and to detect protein communities.

Another common way for searching shared functions among genes is to incorporate the biological knowledge provided by biological ontologies. For instance, Gene Ontology (GO) (Ashburner et al., 2000) annotates genes to biological processes, molecular functions, and cellular components in a directed acyclic graph structure, Kyoto Encyclopedia of Genes and Genomes (KEGG) (Kanehisa et al., 2010) annotates genes to pathways, and Disease Ontology (DO) annotates genes with human disease association (Osborne et al., 2009). Related tools for identifying predominant biological themes in a collection of genes were developed to enhance data interpretation, including GO::TermFinder (Boyle et al., 2004) and GOstats (Falcon and Gentleman, 2007) for GO enrichment analysis, and SubpathwayMiner (Li et al., 2009) for detecting enriched pathways.

Although these tools can automatically calculate the statistically significant categories, the manual step to choose interesting clusters followed by enrichment analysis on each selected cluster is still slow and tedious. Therefore, several new tools such as ClueGO (Bindea et al., 2009) and goProfiles (Sánchez et al., 2007) were developed to partially resolve this problem. However, they only support comparison of two clusters of genes. TM4 MultiExperiment Viewer (MeV) (Saeed et al., 2003), which implements the Tree-EASE (TEASE) algorithm by combining hierarchical clustering with EASE (Hosack et al., 2003), can perform clustering analysis followed by GO enrichment calculation, but without tools designed for comparing and visualizing functional differences among clusters. Here, we present an R package called clusterProfiler for statistical analysis of GO and KEGG, allowing biological theme comparison among gene clusters.

## Materials and Methods

The clusterProfiler was implemented in R, an open-source programming environment (Ihaka and Gentleman, 1996), and was released under Artistic License 2.0 within Bioconductor project (Gentleman et al., 2004). The clusterProfiler package depends on the Bioconductor annotation data GO.db and KEGG.db to obtain the maps of the entire GO and KEGG corpus. Bioconductor annotation packages org.Hs.eg.db, org.Mm.eg.db, and org.Sc.sgd.db were imported for genome-wide annotation of mapping Entrez gene identifiers or ORF identifiers for humans, mice, and yeast, respectively.

The clusterProfiler package offers a gene classification method, namely _groupGO_, to classify genes based on their projection at a specific level of the GO corpus, and provides functions, _enrichGO_ and _enrichKEGG_, to calculate enrichment test for GO terms and KEGG pathways based on hypergeometric distribution. To prevent high false discovery rate (FDR) in multiple testing, _q_-values (Storey, 2002) are also estimated for FDR control. Furthermore, clusterProfiler supplies a function, compareCluster, to automatically calculate enriched functional categories of each gene clusters and provides several methods for visualization.

The comparison function was designed as a general package for comparing gene clusters of any kind of gene–ontology associations, not only GO and KEGG, but also other biological and biomedical ontologies, such as DO that annotates the human genome in terms of disease (Osborne et al., 2009). As demonstrated in the online vignette, clusterProfiler can cooperate with R package DOSE and compare gene–disease associations among gene clusters. Comparing gene clusters in the context of disease is a critical step in translating molecular findings from high-throughput methods into clinical relevance.

## Results

The clusterProfiler package is implemented for gene cluster comparison. It is not limited to gene clusters obtained from gene expression data, but can also be applied to gene clusters from other approaches, such as PPI modules and miRNA target genes (Yu and He, 2011).

To illustrate how clusterProfiler assesses and compares biological themes among gene clusters, we analyzed the publicly available expression dataset of breast tumour tissues from 200 patients (GSE11121, Gene Expression Omnibus) (Schmidt et al., 2008). We first identified 5230 differentially expressed genes (DEGs) using the significant analysis of microarray (SAM) algorithm (Schwender and Ickstadt, 2008), with cutoff of _p_-values <0.01 and FDR <0.05, and then identified eight gene clusters from these DEGs, which have different expression patterns across samples, using soft clustering algorithm (Kumar and Futschik, 2007). Finally, we used clusterProfiler to compare these gene clusters by their enriched biological processes, with the strict cutoff of _p_-values <0.01 and FDR <0.05.

As illustrated in Figure 1, clusterProfiler pinpointed different clusters of DEGs related to different biological processes, such as cluster 2 and cluster 5 related to cellular component organization, cluster 3 related to developmental process, and cluster 6 related to cell cycle.

FIG. 1.

Comparison of GO enrichment of gene clusters. Dots represent term enrichment with color coding: red indicates high enrichment, blue indicates low enrichment. The sizes of the dots represent the percentage of each row (GO category).

These results are consistent with the main findings of the previous studies, showing that high expression of proliferation-associated genes confers a good prognosis in breast cancer (Schmidt et al., 2008). This analysis provides valuable information for further investigations.

## Conclusion and Discussion

In this work, we present a new ontology-based tool, clusterProfiler, that offers three methods, _groupGO_, _enrichGO_ and _enrichKEGG_, for gene classification and enrichment analyses. Most importantly, clusterProfiler applies biological term classification and enrichment analyses to gene cluster comparison, helping to better understand higher order functions of biological system. We also adopted a model design with more flexibility. The comparison function of clusterProfiler is designed as a general framework for comparing any kind of biological and biomedical ontologies as demonstrated in the online vignette. In addition, clusterProfiler provides a visualization module for displaying analysis results.

This package is a simple-to-use tool, specifically designed for biologists who wish to analyze high-throughput data obtained from transcriptomics or proteomics. It can be easily extended to support new organisms, and integrated into pipelines for high-throughput data analysis, especially in cooperating with other Bioconductor packages.

We plan to employ three strategies to improve this package in the future. First, we will use semantic similarity among KEGG pathways and GO terms to aggregate closely related categories. This can be anticipated to result in more interpretable outcomes. Second, we will rank gene similarities in each cluster and then correlate them to search for enriched categories. This will provide more sensibility for finding active gene modules. Third, we will develop a statistical model based on the induced directed acyclic graph to compare functional profiles as a whole rather than a set of unrelated categories. These strategies will increase the versatility of clusterProfiler.

## Acknowledgments

This work was partially supported by National “973” Projects of China (2011CB910700), the 2007 Chang-Jiang Scholars Program, “211” Projects, National Natural Science Foundation of China (20871057), Guangdong Natural Science Research Grant (32209003), and the Fundamental Research Funds for the Central Universities (21611303 to G. Yu and 11610101 to Q.-Y. He).

## Author Disclosure Statement

The authors declare that no conflicting financial interests exist.

## References

1. Ashburner M. Ball C.A. Blake J.A. Botstein D. Butler H. Cherry J.M., et al. Gene Ontology: tool for the unification of biology. Nat Genet. 2000;25:25–29. doi: 10.1038/75556.

2. Asur S. Ucar D. Parthasarathy S. An ensemble framework for clustering protein–protein interaction networks. Bioinformatics. 2007;23:i29–i40. doi: 10.1093/bioinformatics/btm212.

3. Bindea G. Mlecnik B. Hackl H. Charoentong P. Tosolini M. Kirilovsky A., et al. ClueGO: a Cytoscape plug-in to decipher functionally grouped gene ontology and pathway annotation networks. Bioinformatics. 2009;25:1091–1093. doi: 10.1093/bioinformatics/btp101.

4. Boyle E.I. Weng S. Gollub J. Jin H. Botstein D. Cherry J.M., et al. GO::TermFinder—open source software for accessing Gene Ontology information and finding significantly enriched Gene Ontology terms associated with a list of genes. Bioinformatics. 2004;20:3710–3715. doi: 10.1093/bioinformatics/bth456.

5. Falcon S. Gentleman R. Using GOstats to test gene lists for GO term association. Bioinformatics. 2007;23:257–258. doi: 10.1093/bioinformatics/btl567.

6. Gentleman R.C. Carey V.J. Bates D.M. Bolstad B. Dettling M. Dudoit S., et al. Bioconductor: open software development for computational biology and bioinformatics. Genome Biol. 2004;5:R80. doi: 10.1186/gb-2004-5-10-r80.

7. Hosack D.A. Dennis G., Jr. Sherman B.T. Lane H.C. Lempicki R.A. Identifying biological themes within lists of genes with EASE. Genome Biol. 2003;4:R70. doi: 10.1186/gb-2003-4-10-r70.

8. Ihaka R. Gentleman R. R: a language for data analysis and graphics. J Comp Graph Stat. 1996;5:299–314.

9. Kanehisa M. Goto S. Furumichi M. Tanabe M. Hirakawa M. KEGG for representation and analysis of molecular networks involving diseases and drugs. Nucleic Acids Res. 2010;38:D355–D360. doi: 10.1093/nar/gkp896.

10. Kumar L. Futschik M.E. Mfuzz: a software package for soft clustering of microarray data. Bioinformation. 2007;2:5–7. doi: 10.6026/97320630002005.

11. Li C. Li X. Miao Y. Wang Q. Jiang W. Xu C., et al. SubpathwayMiner: a software package for flexible identification of pathways. Nucleic Acids Res. 2009;37:e131. doi: 10.1093/nar/gkp667.

12. Osborne J. Flatow J. Holko M. Lin S. Kibbe W. Zhu L., et al. Annotating the human genome with Disease Ontology. BMC Genomics. 2009;10:S6. doi: 10.1186/1471-2164-10-S1-S6.

13. Saeed A.I. Sharov V. White J. Li J. Liang W. Bhagabati N., et al. TM4: a free, open-source system for microarray data management and analysis. BioTechniques. 2003;34:374–378. doi: 10.2144/03342mt01.

14. Sánchez A. Salicrú M. Ocaña J. Statistical methods for the analysis of high-throughput data based on functional profiles derived from the Gene Ontology. J Stat Plann Inference. 2007;137:3975–3989.

15. Schmidt M. Böhm D. von Törne C. Steiner E. Puhl A. Pilch H., et al. The humoral immune system has a key prognostic impact in node-negative breast cancer. Cancer Res. 2008;68:5405–5413. doi: 10.1158/0008-5472.CAN-07-5206.

16. Schwender H. Ickstadt K. Empirical Bayes analysis of single nucleotide polymorphisms. BMC Bioinformatics. 2008;9:144. doi: 10.1186/1471-2105-9-144.

17. Storey J.D. A direct approach to false discovery rates. J R Stat Soc B. 2002;64:479–498.

18. Yeung K.Y. Medvedovic M. Bumgarner R.E. Clustering gene-expression data with repeated measurements. Genome Biol. 2003;4:R34. doi: 10.1186/gb-2003-4-5-r34.

19. Yu G. He Q.-Y. Functional similarity analysis of human virus-encoded miRNAs. J Clin Bioinformatics. 2011;1:15. doi: 10.1186/2043-9113-1-15.

20. Yu G. Li F. Qin Y. Bo X. Wu Y. Wang S. GOSemSim: an R package for measuring semantic similarity among GO terms and gene products. Bioinformatics. 2010;26:976–978. doi: 10.1093/bioinformatics/btq064.

Innovation (Camb). 2021 Jul 1;2(3):100141. doi: 10.1016/j.xinn.2021.100141

# clusterProfiler 4.0: A universal enrichment tool for interpreting omics data

Tianzhi Wu<sup>1,5</sup>, Erqiang Hu<sup>1,5</sup>, Shuangbin Xu<sup>1</sup>, Meijun Chen<sup>1</sup>, Pingfan Guo<sup>1</sup>, Zehan Dai<sup>1</sup>, Tingze Feng<sup>1</sup>, Lang Zhou<sup>1</sup>, Wenli Tang<sup>1</sup>, Li Zhan<sup>1</sup>, Xiaocong Fu<sup>1</sup>, Shanshan Liu<sup>1</sup>, Xiaochen Bo<sup>2,∗</sup>, Guangchuang Yu<sup>1,3,4,∗∗</sup>

PMCID: PMC8454663 PMID: 34557778

## Summary

Functional enrichment analysis is pivotal for interpreting high-throughput omics data in life science. It is crucial for this type of tool to use the latest annotation databases for as many organisms as possible. To meet these requirements, we present here an updated version of our popular Bioconductor package, clusterProfiler 4.0. This package has been enhanced considerably compared with its original version published 9 years ago. The new version provides a universal interface for functional enrichment analysis in thousands of organisms based on internally supported ontologies and pathways as well as annotation data provided by users or derived from online databases. It also extends the _dplyr_ and _ggplot2_ packages to offer tidy interfaces for data operation and visualization. Other new features include gene set enrichment analysis and comparison of enrichment results from multiple gene lists. We anticipate that clusterProfiler 4.0 will be applied to a wide range of scenarios across diverse organisms.

**Keywords:** clusterProfiler, biological knowledge mining, functional analysis, enrichment analysis, visualization

## Graphical abstract

## Public summary

- clusterProfiler supports exploring functional characteristics of both coding and non-coding genomics data for thousands of species with up-to-date gene annotation

- It provides a universal interface for gene functional annotation from a variety of sources and thus can be applied in diverse scenarios

- It provides a tidy interface to access, manipulate, and visualize enrichment results to help users achieve efficient data interpretation

- Datasets obtained from multiple treatments and time points can be analyzed and compared in a single run, easily revealing functional consensus and differences among distinct conditions

## Introduction

Functional enrichment analysis is one of the most widely used techniques for interpreting gene lists or genome-wide regions of interest (ROIs)<sup>1</sup> derived from various high-throughput studies. Although many tools have been developed for gene-centric or epigenomic enrichment analysis, most are designed for model organisms or specific domains (e.g., fungi,<sup>2</sup> plants<sup>3</sup>) embedded with particular annotations such as Gene Ontology (GO) and the Kyoto Encyclopedia of Genes and Genomes (KEGG).<sup>4</sup> Non-model organisms and functional annotations other than GO and KEGG are poorly supported. Moreover, the increasing concerns for the quality of gene annotation have raised an alarm in biomedical research. Because annotation databases have diverse or irregular update periods, many tools may fail to update the corresponding information in time. A previous study<sup>5</sup> reported that about 42% of the tools were outdated by more than 5 years and that functional significance was severely underestimated, with only 26% of biological processes or pathways captured in comparison with those employing up-to-date annotation. Such negative impacts of outdated annotation can be propagated for years and can hinder follow-up studies. Reanalyzing the GTEx dataset<sup>6</sup> published by the ENCODE consortium using clusterProfiler uncovered a large number of new pathways, which were missed in the analysis using out-of-date annotation (https://github.com/GuangchuangYu/enrichment4GTEx_clusterProfiler), and new hypotheses were generated based on these new pathways.

The clusterProfiler library was first published in 2012<sup>7</sup> and designed to perform over-representation analysis (ORA)<sup>8</sup> using GO and KEGG for several model organisms and to compare functional profiles of various conditions on one level (e.g., different treatment groups). Since then, clusterProfiler has matured substantially and currently supports several ontology and pathway annotations, thousands of species with up-to-date gene annotation, users’ annotation data for novel species, and emerging new annotations. Both ORA and gene set enrichment analysis (GSEA)<sup>9</sup> are supported. The comparison utility is extended to support a complex experimental design that allows comparison of functional profiles of various conditions on different levels. The clusterProfiler library has many unique features, including a tidy interface that can manipulate the enrichment result and directly support the visualization of the enrichment result using _ggplot2_ (Tables 1 and S2). Moreover, we have developed several packages to complement its functionalities, including ChIPseeker to connect functional analysis with genomic ROIs,<sup>10</sup> GOSemSim<sup>11</sup> to remove redundant GO terms, and enrichplot to visualize the enrichment results. These complementary packages enable clusterProfiler to stand out among other tools. The clusterProfiler library is one of the most popular Bioconductor packages. It has been incorporated in more than 30 CRAN and Bioconductor packages (Table S1), several pipelines (e.g., The Cancer Genome Atlas [TCGA] Workflow<sup>12</sup> and ViralLink<sup>13</sup>), and online platforms (e.g., NASQAR<sup>14</sup> and ABioTrans<sup>15</sup>).

**Table 1.**

Major clusterProfiler functions

[p0005-b002](../assets/supp_table/supplementary-table-cp4-1.csv)

| Function | Description |
| --- | --- |
| enrichGO | ORA using GO |
| enrichKEGG | ORA using KEGG pathway |
| enrichMKEGG | ORA using KEGG module |
| enrichWP | ORA using WikiPathways |
| enricher | general interface for ORA |
| gseGO | GSEA using GO |
| gseKEGG | GSEA using KEGG pathway |
| gseMKEGG | GSEA using KEGG module |
| gseWP | GSEA using WikiPathways |
| GSEA | general interface for GSEA |
| compareCluster | compare functional profiles for genes obtained from different conditions |
| merge_result | merge enrichment results for comparison |
| read.gmt | parse gene set file in GMT format |
| read.gmt.wp | parse WikiPathways GMT file |
| download_KEGG | download the latest version of the KEGG pathway/module |
| get_wp_organism | list supported organisms of WikiPathways |
| bitr | biological ID translator using OrgDb |
| bitr_kegg | biological ID translator using the KEGG database |
| setReadable | convert IDs in enrichment result to human-readable gene symbols using OrgDb |
| go2ont | convert GO ID to corresponding ontology (BP, CC, MF) |
| go2term | convert GO ID to a descriptive term |
| ko2name | convert KO ID to a descriptive name |
| buildGOmap | infer GO indirect annotation from direct annotation |
| browseKEGG | open specific KEGG pathway in a web browser with genes highlighted |
| dropGO | drop GO terms of specific level or a specific terms (mostly too general) from enrichment result |
| gofilter | restrict enrichment result at a specific GO level |
| geneInCategory | extract input genes (for ORA) or core enriched genes (for GSEA) that belong to a specific functional category |
| simplify | remove redundant GO terms from enrichment result |
| arrange | order enrichment result by the values of selected variables |
| filter | subset enrichment result that satisfies user conditions |
| group_by | group enrichment results by selected variable |
| mutate | add new variable to enrichment result |
| select | select variables in enrichment result |
| summarise | create summary statistics from enrichment result |

## Results

### Gene ontology

The clusterProfiler package provides the _enrichGO_ and _gseGO_ functions for ORA and GSEA using GO.<sup>16</sup> Instead of providing species-specific GO annotation, clusterProfiler relies on genome-wide annotation packages (OrgDb) released by the Bioconductor project. There are 20 OrgDb packages available in Bioconductor for different species, such as human, mouse, fly, yeast, and worm. These packages are updated biannually. GO annotation for non-model organisms can be queried online via the AnnotationHub package, which provides web services for accessing genome-wide annotations from various data providers (e.g., UCSC, Ensembl, NCBI, STRING, and GENCODE). With the efforts from the Bioconductor community to maintain up-to-date GO annotation for model and non-model organisms, clusterProfiler supports GO analysis on more species compared with other tools. Moreover, a data frame of GO annotation (e.g., retrieve data from the BiomaRt or UniProt database using taxonomic ID) can be used to construct an OrgDb using the AnnotationForge package or directly through the universal interface for enrichment analysis.

GO terms are organized as a directed acyclic graph, in which a directed edge denotes a parent-child semantic relationship. A parent term might be significantly enriched only because it contains all the genes of a significantly over-represented child term. Consequently, the list of enriched GO terms is often too long and contains redundant terms, which hinders effective interpretation. Therefore, clusterProfiler integrates a _simplify_ function to eliminate such redundant GO terms. This function employs the GOSemSim<sup>17</sup> package to calculate semantic similarities among enriched GO terms using multiple methods based on information content or graph structure. Highly similar GO terms (e.g., >0.7) will be removed by applying the _simplify_ function to retain a representative term (e.g., the most significant term). The following example shows an ORA on Biological Process (BP) to identify significant BP terms associated with the differentially expressed genes (DEGs). The geneList dataset, which contains fold change of gene expression levels between breast tumor and normal samples and is provided by the DOSE package, was used in this example. The DEGs were identified by a criterion of fold change >2. As demonstrated in Figure 1A, the top 30 enriched terms are highly connected, and it seems that the DEGs are associated with a single functional module. Visualizing top enriched terms is a common approach to present and interpret the enrichment result. However, the top results are dominated by a large number of highly similar terms. After removing redundant terms, the result reveals a more global view with several different functional modules (Figure 1B). This feature simplifies the enrichment results, assists in interpretation, and avoids the annotation/interpretation bias.<sup>18</sup>

```r
library(clusterProfiler)
data(geneList, package="DOSE")
## fold change > 2 as DE genes
de <- names(geneList)[abs(geneList) > 2]
ego <- enrichGO(de, OrgDb = "org.Hs.eg.db", ont="BP", readable=TRUE)
## use simplify to remove redundant terms
ego2 <- simplify(ego, cutoff=0.7, by="p.adjust", select_fun=min)
```

Gene ontology enrichment analysis

The original result (A) and a simplified version (B) were visualized as enrichment map networks. Each node represents a gene set (i.e., a GO term) and each edge represents the overlap between two gene sets.

## Kyoto encyclopedia of genes and genomes

KEGG is an encyclopedia of genes and genomes.<sup>19</sup> Molecular functions are represented by networks of interactions and reactions mainly in the form of KEGG pathways and modules. A KEGG module is a collection of manually defined function units. In some situations, KEGG modules have a more straightforward interpretation. Both KEGG pathways and KEGG modules are supported by clusterProfiler. Many software tools that support KEGG analysis have stopped updating since July 2011 when KEGG initiated an academic subscription model for FTP downloading. These tools use relatively old KEGG data, and the result might be inaccurate and misleading. Fortunately, the KEGG web resource is freely available. The clusterProfiler package does not pack any KEGG data. Instead, it queries the latest online KEGG database through web API to perform functional analysis. The advantage of this feature is obvious: it allows clusterProfiler to use up-to-date data and support all the species that have KEGG annotation (more than 6,000 species are listed in http://www.genome.jp/kegg/catalog/org_list.html). Moreover, clusterProfiler supports the KEGG Orthology database and can be used to perform functional characterization of the microbiomes.<sup>20</sup>

In the following example, GSEA was performed with KEGG pathway. Figure 2A shows the plotting of GSEA enrichment results to visualize the top five perturbed pathways, i.e., the top five highest absolute values of the normalized enrichment score (NES).<sup>9</sup> The NES indicates the shift of genes belonging to a certain pathway toward either end of the ranked list and represents pathway activation or suppression. To further explore the pathway crosstalk effects, we visualized gene expression distribution of core enrichment genes using an UpSet plot (Figure 2B). The result shows that the expression values of genes in the intersection of cell-cycle and DNA-replication pathways are higher than those uniquely belonging to either of the two pathways. These overlapping genes are mainly minichromosome maintenance (MCM) genes, which can potentially serve as biomarkers for tumor diagnosis.<sup>21</sup> The intersection of the interleukin-17 (IL-17) signaling pathway and the proteasome pathway is only associated with one gene, interferon-γ (IFN-γ). The IL-17 signaling pathway induces an inflammatory response,<sup>22</sup> while IFN-γ regulates proteasome formation.<sup>23</sup> These effects ultimately reshape the tumor microenvironment.

```r
kk <- gseKEGG(geneList, organism = "hsa")
```

KEGG pathway enrichment analysis

In GSEA enrichment plot (A), the curves represent the running sum of the enrichment scores, the middle part of the graph shows the position of genes that are related to certain pathways, and the bottom part of the graph displays how the metric (e.g., fold change) is distributed along with the list. The UpSet plot (B) visualizes the metric distribution of core enrichment genes. It differentiates genes that uniquely belong to a pathway or are associated with two or more pathways.

## Universal interface for biomedical gene sets

With the advancement of the sequencing technology, the investigation into functions for transcriptomes from non-model organisms is increasingly demanded. However, most tools in this field are designed for GO and KEGG analyses with support limited to one or several model organisms. Besides, there are increasingly more biological knowledge databases available for exploring functional characteristics from different perspectives, such as Disease Ontology,<sup>24</sup> Reactome Pathway,<sup>25</sup> Medical Subject Headings,<sup>26</sup> and WikiPathway.<sup>27</sup> There is an urgent need for integration and support of these databases. To address these issues, clusterProfiler provides two general functions, _enricher_ and _GSEA_ for ORA and GSEA, with user-provided gene annotations. These two functions allow the application of all ontologies or pathways curated in diverse databases as the background in customized analyses.

Therefore, users could easily import external annotations (e.g., electronic annotations using Blast2GO<sup>28</sup> and KAAS<sup>29</sup> for GO and KEGG annotations, respectively) for newly sequenced species. Moreover, it is convenient to perform functional analysis using up-to-date annotations from all popular databases, such as InterPro, Clusters of Orthologous Groups, and Mouse Phenotype Ontology, to name a few, without waiting for the updates of other tools. It would be suitable for the timely analysis of gene sets with emerging interests, such as human cell markers<sup>30</sup> and COVID-19-related gene sets.

The gene set annotation required by _enricher_ and _GSEA_ is a two-column data frame with one column representing gene set names (ID or descriptive name) and the other showing the corresponding genes. The gene matrix transposed (GMT) format is widely used to distribute gene set annotations. There are many gene set libraries available online (e.g., https://maayanlab.cloud/Enrichr/#stats), including MSigDB (Molecular Signatures Database), Disease Signatures, and CCLE (Cancer Cell Line Encyclopedia). To enable the utilization of these gene sets in clusterProfiler as the background annotation to explore the underlying biological mechanisms, clusterProfiler provides a parser function, _read.gmt_, to import GMT files that can be directly passed to the _enricher_ and _GSEA_ functions. In the following example, we used the _GSEA_ function to perform gene set enrichment analysis using WikiPathways (Figure 5B). The annotation data were parsed by using _read.gmt.wp_, which is a customized version of _read.gmt_ for importing GMT files from WikiPathways.

```r
## downloaded from https://wikipathways-data.wmcloud.org/current/gmt/
gmt <- "wikipathways-20210310-gmt-Homo_sapiens.gmt"
wp <- read.gmt.wp(gmt)
ewp <- GSEA(geneList, TERM2GENE=wp[, c("wpid", "gene")], TERM2NAME=wp[, c("wpid", "name")])
```

Visualizing enrichment results using _ggplot2_

A lollipop chart to visualize the rich factors from ORA (A) and a bar chart to visualize normalized enrichment scores from GSEA (B).

## Functional interpretation of genomic ROIs

With the increasing availability of genomic sequences, non-coding genomic regions (e.g., _cis_-regulatory elements, non-coding RNAs, and transposons) have posed a demanding challenge to exploration of their roles in various biological processes.<sup>1</sup> Unlike coding genes, non-coding genomic regions are typically not well functionally annotated. Analyzing biological functions of the proximal genes is a common strategy in research on the biological meaning of a set of non-coding genomic regions. Software tools, such as the Genomic Regions Enrichment of Annotations Tool (GREAT),<sup>31</sup> are implemented to follow this strategy. However, these tools only support a limited number of species. For example, GREAT is designed for human and mouse only. In addition, many tools only take the host or nearest genes into consideration but ignore long-distance regulations. Our in-house developed package, ChIPseeker,<sup>10</sup> is originally designed for chromatin immunoprecipitation (ChIP) peak annotation, comparison, and visualization and has been employed to analyze genome-wide ROIs, such as open chromatin regions obtained by DNase-seq<sup>32</sup> and ATAC-seq.<sup>33</sup> To facilitate biological interpretation of genome-wide regions, we implemented a function, _seq2gene_, in ChIPseeker to associate genomic regions with coding genes through many-to-many mapping. It automatically maps genomic regions to host genes (either located in exon or intron), proximal genes (located in the promoter region), and flanking genes (located upstream and downstream within user-specified distance). The _seq2gene_ function supports a wide variety of species if a genomic annotation, such as the TxDb (UCSC-based) or EnsDb (Ensembl-based) object, is available. After mapping genomic regions to coding genes, clusterProfiler can be employed to perform functional enrichment analysis of the coding genes to assign biological meanings to the set of genomic regions. The combination of ChIPseeker and clusterProfiler allows more biological ontology or pathway databases to be utilized to explore functions of genomic regions for a wide variety of species.

```r
library(ChIPseeker)
## the file can be downloaded using 'downloadGSMbedFiles("GSM1295076")'
file <- "GSM1295076_CBX6_BF_ChipSeq_mergedReps_peaks.bed.gz"
gr <- readPeakFile(file)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
TxDb <- TxDb.Hsapiens.UCSC.hg19.knownGene
genes <- seq2gene(gr, tssRegion=c(-1000, 1000), flankDistance = 3000, TxDb)
library(clusterProfiler)
g <- bitr(genes, 'ENTREZID', 'SYMBOL', 'org.Hs.eg.db')
## downloaded from
## https://maayanlab.cloud/Enrichr/geneSetLibrary?mode=text&libraryName=ENCODE_and_ChEA_Consensus_TFs_from_ChIP-X
encode <- read.gmt("ENCODE_and_ChEA_Consensus_TFs_from_ChIP-X.txt")
enricher(g$SYMBOL, TERM2GENE=encode)
```

A dataset of ChIP-seq with antibody against CBX6 (GEO: GSM1295076) was used in the above example. The genomic binding regions were mapped to coding genes using the _seq2gene_ function with UCSC genomic annotation. The Entrez gene IDs were converted into gene symbols using the _bitr_ function implemented in clusterProfiler. To identify and characterize transcript cofactors, we performed functional enrichment analysis using the ENCODE and ChEA transcript factor gene sets. The result was visualized as a category-gene network (Figure 3), which showed that genes associated with CBX6 (obtained by the _seq2gene_ function) significantly overlap with genes regulated by POU5F1, TRIM28, SUZ12, and EZH2. OCT4 (POU5F1)<sup>34</sup> and KAP1 (TRIM28)<sup>35</sup> have been reported to interact with polycomb repressive complex 1 (PRC1), and CBX6 is a known subunit of PRC1.<sup>36</sup> SUZ12 and EZH2 are core components of PRC2 and negatively regulate CBX6.<sup>37</sup> These pieces of evidence support the effectiveness of these analyses including the mapping of genomic ROIs to coding genes and functional enrichment, which suggest that this method can be used to identify unknown cofactors (Figure 3) and characterize functions of genomic regions.

Functional enrichment analysis of genomic regions of interest

Genomic regions are linked to coding genes, which are then used to identify transcript cofactors by testing significant overlap of target genes.

## Comparison among different conditions

The clusterProfiler library is designed to allow the comparison of functional enrichment results from multiple experimental conditions or multiple time points. With an input of a collection of gene lists, the _compareCluster_ function applies a function (e.g., _enricher_) with user settings to perform functional enrichment analysis for each of the gene lists and aggregates the results into a single object. Thus, enrichment results of multiple groups are easily explored and plotted together for comparison with a user-friendly interface. Comparing functional profiles can reveal functional consensus and differences among different experiments and helps in identifying differential functional modules in omics datasets. In the updated version, _compareCluster_ provides a new interface supporting a formula that is widely used in R for specifying statistical models; this allows more complicated experimental designs to be supported (e.g., time-course experiment with different treatments). With the infrastructure of clusterProfiler to support a wide range of ontology and pathway annotations and multiple organisms, the comparison can be applied to many circumstances.

The dataset, DE_GSE8057, was derived from the GEO: GSE8057 dataset in the GEO database. The GSE8057 dataset contains expression data from ovarian cancer cells at multiple time points (0, 2, 6, and 24 h) and under two treatment conditions (cisplatin and oxaliplatin).<sup>38</sup> The DE_GSE8057 dataset contains DEGs obtained from different treatments and time points versus control samples. Eight groups of DEG lists (specified by the formula _Gene ~ Time_ + _Treatment_) were analyzed simultaneously using _compareCluster_ with WikiPathways. The result (Figure 4) indicates that the two drugs have distinct effects at the beginning but consistent effects in the later stages. Several pathways including DNA damage and cell-cycle progression were perturbed by either cisplatin or oxaliplatin drug exposure. The finding is consistent with the discovery obtained by data-driven modeling.<sup>38</sup>

```r
data(DE_GSE8057)
```

```r
xx <- compareCluster(Gene ~ time+treatment, data=DE_GSE8057, fun = enricher,
                     TERM2GENE=wp[,c("wpid", "gene")], TERM2NAME=wp[,c("wpid", "name")])
```

Comparing functional profiles among different levels of conditions

The _compareCluster_ function performed enrichment analysis simultaneously for eight lists of DEGs. The results were visualized as a dot plot with an x axis representing one level of conditions (time course) and a facet panel indicating another level of conditions (drug treatments).

## Data frame interface for accessing enriched results

The outputs of ORA and GSEA are _enrichResult_ and _gseaResult_ objects, respectively, while the output of _compareCluster_ is a _compareClusterResult_ object. These S4 objects contain input data, analysis settings, and enriched results, which allow more informative data to be available for downstream interpretation and visualization. To enable easy access to the enriched result, clusterProfiler implements _as.data.frame_ methods to convert the S4 objects to data frames that can be easily exported as CSV files. In addition, clusterProfiler provides a data frame interface that mimics data frame operations to access rows, columns, and subsets of rows and columns from the S4 objects of the enriched result. Users can use _head_ and _tail_ to print part of the result. The _nrow_, _ncol_, and _dim_ methods are also supported to access basic information such as how many pathways are enriched.

```r
## head or tail to print first or last n rows
head(ego, 2)
## ID Description GeneRatio BgRatio pvalue
## GO:0140014 GO:0140014 mitotic nuclear division 34/194 286/18866 2.171838e-26
## GO:0000280 GO:0000280 nuclear division 36/194 428/18866 1.099719e-22
## p.adjust qvalue
## GO:0140014 6.700119e-23 5.710790e-23
## GO:0000280 1.696316e-19 1.445841e-19
## geneID
## GO:0140014
CDCA8/CDC20/KIF23/CENPE/MYBL2/CCNB2/NDC80/NCAPH/DLGAP5/UBE2C/NUSAP1/TPX2/TACC3/NEK2/UBE2S/CDK1/MAD2L1/KIF18A/CDT1/BIRC5/KIF11/TTK/NCAPG/AURKB/CHEK1/TRIP13/PRC1/KIFC1/KIF18B/AURKA/CCNB1/KIF4A/PTTG1/BMP4
## GO:0000280
CDCA8/CDC20/KIF23/CENPE/MYBL2/CCNB2/NDC80/TOP2A/NCAPH/ASPM/DLGAP5/UBE2C/NUSAP1/TPX2/TACC3/NEK2/UBE2S/CDK1/MAD2L1/KIF18A/CDT1/BIRC5/KIF11/TTK/NCAPG/AURKB/CHEK1/TRIP13/PRC1/KIFC1/KIF18B/AURKA/CCNB1/KIF4A/PTTG1/BMP4
## Count
## GO:0140014 34
## GO:0000280 36
```

The [ and _$_ operators for subsetting are also supported. We redefined the [[ operator to help users access which genes are annotated by a selected ontology or pathway. For GSEA output, the [[ operator will return core enriched genes (i.e., genes in the leading edge) of the selected gene set.

```r
## subset result using '[' and '$'
ego[1:2, c("ID", "Description", "pvalue", "p.adjust")]
## ID Description pvalue p.adjust
## GO:0140014 GO:0140014 mitotic nuclear division 2.171838e-26 6.700119e-23
## GO:0000280 GO:0000280 nuclear division 1.099719e-22 1.696316e-19
head(ego$Description)
## [1] "mitotic nuclear division"
## [2] "nuclear division"
## [3] "organelle fission"
## [4] "mitotic sister chromatid segregation"
## [5] "sister chromatid segregation"
## [6] "chromosome segregation"
## genes annotated by specific term
ego[["GO:0140014"]]
## [1] "CDCA8" "CDC20" "KIF23" "CENPE" "MYBL2" "CCNB2" "NDC80" "NCAPH"
## [9] "DLGAP5" "UBE2C" "NUSAP1" "TPX2" "TACC3" "NEK2" "UBE2S" "CDK1"
## [17] "MAD2L1" "KIF18A" "CDT1" "BIRC5" "KIF11" "TTK" "NCAPG" "AURKB"
## [25] "CHEK1" "TRIP13" "PRC1" "KIFC1" "KIF18B" "AURKA" "CCNB1" "KIF4A"
## [33] "PTTG1" "BMP4"
```

## Tidy interface for data operation

To facilitate data manipulation and exploration of the enrichment result, clusterProfiler extends the _dplyr_ verbs to support _enrichResult_, _gseaResult_, and _compareClusterResult_ objects. Following the concept of tidiness, these verbs provide robust and standardized operations for data transformation and can be assembled into a workflow using the pipe operator (%>%). This allows users to explore the results effectively and develop reproducible and human-readable pipelines. For example, it allows the filtering of enriched results using different criteria (e.g., adjusted p values less than 0.001, and the number of input genes annotated to the enriched term should be greater than 10).

```r
dim(ego)
## [1] 197 9
ego2 <- filter(ego, p.adjust < 0.001, Count > 10)
dim(ego2)
## [1] 44 9
```

For ORA results, clusterProfiler provides _geneRatio_ (ratio of input genes that are annotated in a term) and _BgRatio_ (ratio of all genes that are annotated in this term). However, other concepts are widely used to help in interpreting enrichment results, such as the rich factor and fold enrichment. A rich factor is defined as the ratio of input genes (e.g., DEGs) that are annotated in a term to all genes that are annotated in this term. The fold enrichment is defined as the ratio of the frequency of input genes annotated in a term to the frequency of all genes annotated to that term, and it is easy to calculate by dividing _geneRatio_ by _BgRatio_. Here, as an example, we used the _mutate_ verb to create a new column of _richFactor_ based on information available in the clusterProfiler output.

```r
ego3 <- mutate(ego, richFactor = Count / as.numeric(sub("/\\d+", "", BgRatio)))
```

The following example uses the GSEA enrichment result generated in the previous session. The result was sorted by absolute values of NESs using the _arrange_ verb. NES is an indicator to interpret the degree of enrichment. A positive NES indicates that members of the gene set tend to appear at the top of the rank (pathway activation), and a negative NES indicates the opposite circumstance (pathway suppression). We used the _group_by_ verb to group the result based on the sign of NES, and the _slice_ verb was used to extract the first five enriched pathways for each group (i.e., five activated pathways that have the largest NES values and five suppressed pathways that have the smallest NES values). These verbs return the same object type as their input and do not affect downstream analysis and visualization.

```r
ewp2 <- arrange(ewp, desc(abs(NES))) %>%
  group_by(sign(NES)) %>%
  slice(1:5)
```

## Visualization using Ggplot2

The _enrichplot_ package is originally derived from DOSE and clusterProfiler packages and serves as a _de facto_ visualization tool for visualizing enrichment results for outputs from clusterProfiler as well as DOSE, ReactomePA, and meshes. These methods allow users without programming skills to generate effective visualization to explore and interpret results. All the visualization methods implemented are based on _ggplot2_, which allows customization using the grammar of graphics. Moreover, we also extend _ggplot2_ to support enrichment results so that users can use the _ggplot2_ syntax directly to visualize enrichment results. The following example demonstrates the application of _ggplot2_ grammar of graphics to visualize the GO enrichment result (ORA) as a lollipop chart using the rich factor that was generated in the previous session using the _dplyr_ verbs (Figure 5A).

```r
library(ggplot2)
library(forcats)
ggplot(ego3, showCategory = 10,
       aes(richFactor, fct_reorder(Description, richFactor))) +
  geom_segment(aes(xend=0, yend = Description)) +
  geom_point(aes(color=p.adjust, size = Count)) +
  scale_color_gradientn(colours=c("#f7ca64", "#46bac2", "#7e62a3"),
                        trans = "log10",
                        guide=guide_colorbar(reverse=TRUE, order=1)) +
  scale_size_continuous(range=c(2, 10)) +
  theme_dose(12) +
  xlab("Rich Factor") +
  lab(NULL) +
  ggtitle("Biological Processes")
```

In Figure 5B, the most significant activated and suppressed pathways (GSEA) selected by a series of _dplyr_ verb operations are visualized as a bar chart using the _ggplot2_ syntax. Although visualization methods used to generate Figure 5 are not provided in clusterProfiler, it is easy to generate such graphs using the tidy interface and _ggplot2_. The combination of the tidy interface for data wrangling and the support of _ggplot2_ for visualization creates many possibilities for users to explore and visualize enrichment results using consistent grammar. It allows novel exploratory approaches to reveal unanticipated mechanisms as well as prototyping new visualization methods.

```r
ggplot(ewp2, showCategory=10,
       aes(NES, fct_reorder(Description, NES), fill=qvalues)) +
  geom_col() +
  scale_fill_gradientn(colours=c("#b3eebe", "#46bac2", "#371ea3"),
                       guide=guide_colorbar(reverse=TRUE)) +
  theme_dose(12) +
  xlab("Normalized Enrichment Score") +
  ylab(NULL) +
  ggtitle("WikiPathways")
```

## Package interoperability

The clusterProfiler package is a versatile tool for enrichment analysis. It is developed within the Bioconductor ecosystem and has become an essential part of this ecosystem. Currently there are more than 30 R packages that rely on clusterProfiler to perform functional analysis for different topics, especially for cancer research. GO analysis relies on GO annotation maintained by the community, and the enrichment analysis for genomic regions relies on genomic annotation maintained by UCSC and Ensembl. There are R packages that contain gene set annotation (e.g., msigdbr) and R client libraries for accessing pathway data (e.g., rWikiPathways). These data can be used directly as background annotation in clusterProfiler through the universal interface to characterize the functional profile of omics data. The ORA algorithm is implemented in the DOSE package<sup>21</sup> developed in-house, and the GSEA algorithm is implemented in DOSE and fgsea<sup>39</sup> packages.

Our team has developed several packages to complement the functionality of clusterProfiler. ChIPseeker<sup>10</sup> bridges the genomic region with functional enrichment by annotating the genomic region to associated genes. GOSemSim<sup>11</sup> provides more than five methods for measuring semantic similarity. It allows removal of redundant terms using semantic similarities among GO terms and allows enrichment results to be visualized in semantic space so that similar terms cluster together. The DOSE<sup>24</sup> package supports functional enrichment from the disease perspective, including disease ontology, the network of cancer genes, and disease gene network. The ReactomePA<sup>25</sup> and meshes<sup>26</sup> packages support functional analysis using Reactome Pathways and Medical Subject Headings, respectively. DOSE, ReactomePA, and meshes are developed within the framework of clusterProfiler, and the enrichment analysis functions provided in these packages can be used in _compareCluster_ for the comparison of functional profiles under various conditions and at different time points. The enrichplot package provides several visualization methods to generate publication-quality figures to help users interpret the results (Figures 1, 2, 3, and 4; supplemental information). This package suite provides a comprehensive set of tools for mining biological knowledge to elucidate and interpret molecular mechanisms (Figure 6).

A package suite for mining biological knowledge

clusterProfiler is an essential core for functional analysis, the functionalities of which are enhanced by several companion packages.

## Discussion and conclusions

Pathway enrichment analysis is an essential step toward identifying biological themes that are most characteristic of high-throughput sequencing data. The clusterProfiler library provides a set of functions to unveil biological functions and pathways. Compared with many other tools that do not update background annotation databases in timely fashion and only support a limited number of organisms, clusterProfiler uses up-to-date biological knowledge of genes and biological processes (GO and KEGG) and supports thousands of organisms. In addition, clusterProfiler provides a universal interface for functional analysis with user-provided annotations. This creates the possibility to apply clusterProfiler on functional characterization of different types of data with different biological knowledge. The tidy interface provided in clusterProfiler harmonizes data structures and workflows and makes it easier for the community to develop modular manipulation, visualization, and analysis methods to supplement the existing ecosystem. clusterProfiler has already been integrated into more than 30 packages to perform functional analysis on data obtained using different techniques, including ATAC-seq, multi-region sequencing (MRS), CRISPR/Cas9 screens, and mass spectrometry (Table S1). The clusterProfiler package can be easily integrated into analysis pipelines. For example, the Gene Ontology Meta Annotator for Plants (GOMAP) is optimized for GO annotation of large, repetitive plant genomes.<sup>40</sup> Users can develop a pipeline to combine GOMAP with clusterProfiler to characterize the functionality of sequencing data from plant species, including wheat, maize, soy, and rice. The clusterProfiler library has been incorporated into different pipelines, such as TCGA Workflow,<sup>12</sup> recount workflow,<sup>41</sup> RNASeqR,<sup>42</sup> and MAGeCKFlute.<sup>43</sup>

clusterProfiler 4.0 contains several new features, including the tidy interface and the compatibility of using _ggplot2_ for visualization. There is no API change for functional enrichment analyses, and this version is fully compatible with downstream packages (Table S1). After long-term maintenance, clusterProfiler is mature and unlikely to introduce significant API changes in future development. In the event of an API change, we will maintain backward compatibility for at least 1 year and provide a warning message about the change. The clusterProfiler library is freely available at https://www.bioconductor.org/packages/clusterProfiler. The development version of clusterProfiler is hosted on GitHub (https://github.com/YuLab-SMU/clusterProfiler), with many active users. A complete reference of the package suite (Figure 6) is available in the online book, https://yulab-smu.top/biomedical-knowledge-mining-book/, with many examples and detailed explanations on biological knowledge mining. Source codes to reproduce Figures 1, 2, 3, 4, and 5, as well as detailed information about the datasets used in the examples, are available in supplemental information. The clusterProfiler library is one of the popular tools used in functional enrichment analysis (more than 2,500 citations in 2020 according to Google Scholar), and we anticipate that clusterProfiler will continue to be a valuable resource to support the discovery of mechanistic insights and improve our understanding of health and disease.

## Acknowledgments

This work was supported by a startup fund from Southern Medical University.

### Author contributions

G.Y. and X.B. planned the study, analyzed and interpreted the data, and drafted the manuscript. T.W. and E.H. analyzed and interpreted the data, and revised the manuscript. S.X., M.C., and P.G. were responsible for data collection and data analysis, and revised the manuscript. Z.D., T.F., and L.Z. contributed to data analysis and interpretation. W.T., L.Z., X.F., and S.L. participated in data analysis and manuscript revision. All authors have given final approval for the manuscript to be published and have agreed to be responsible for all aspects of the manuscript.

### Declaration of interests

The authors declare no competing interests.

Published Online: July 1, 2021

## Footnotes

Supplemental information can be found online at https://doi.org/10.1016/j.xinn.2021.100141.

## Contributor Information

Xiaochen Bo, Email: boxc@bmi.ac.cn.

Guangchuang Yu, Email: gcyu1@smu.edu.cn.

## Lead contact website

https://yulab-smu.top.

## Supplemental information

Document S1. Note S1 and Tables S1 and S2  
mmc1.pdf (1.5MB, pdf)

Document S2. Article plus supplemental information

mmc2.pdf (6.5MB, pdf)

## References

1. Dozmorov M.G. Epigenomic annotation-based interpretation of genomic data: from enrichment analysis to machine learning. Bioinformatics. 2017;33:3323–3330. doi: 10.1093/bioinformatics/btx414. [DOI] [PubMed] [Google Scholar]

2. Priebe S., Kreisel C., Horn F., et al. FungiFun2: a comprehensive online resource for systematic analysis of gene lists from fungal species. Bioinformatics. 2015;31:445–446. doi: 10.1093/bioinformatics/btu627. [DOI] [PMC free article] [PubMed] [Google Scholar]

3. Yi X., Du Z., Su Z. PlantGSEA: a gene set enrichment analysis toolkit for plant community. Nucleic Acids Res. 2013;41:W98–W103. doi: 10.1093/nar/gkt281. [DOI] [PMC free article] [PubMed] [Google Scholar]

4. Nam D., Kim S.-Y. Gene-set approach for expression pattern analysis. Brief. Bioinform. 2008;9:189–197. doi: 10.1093/bib/bbn001. [DOI] [PubMed] [Google Scholar]

5. Wadi L., Meyer M., Weiser J., et al. Impact of outdated gene annotations on pathway enrichment analysis. Nat. Methods. 2016;13:705–706. doi: 10.1038/nmeth.3963. [DOI] [PMC free article] [PubMed] [Google Scholar]

6. Melé M., Ferreira P.G., Reverter F., et al. The human transcriptome across tissues and individuals. Science. 2015;348:660–665. doi: 10.1126/science.aaa0355. [DOI] [PMC free article] [PubMed] [Google Scholar]

7. Yu G., Wang L.-G., Han Y., et al. clusterProfiler: an R Package for comparing biological themes among gene clusters. OMICS J. Integr. Biol. 2012;16:284–287. doi: 10.1089/omi.2011.0118. [DOI] [PMC free article] [PubMed] [Google Scholar]

8. Boyle E.I., Weng S., Gollub J., et al. GO::TermFinder—open source software for accessing Gene Ontology information and finding significantly enriched Gene Ontology terms associated with a list of genes. Bioinformatics. 2004;20:3710–3715. doi: 10.1093/bioinformatics/bth456. [DOI] [PMC free article] [PubMed] [Google Scholar]

9. Subramanian A., Tamayo P., Mootha V.K., et al. Gene set enrichment analysis: a knowledge-based approach for interpreting genome-wide expression profiles. Proc. Natl. Acad. Sci. U S A. 2005;102:15545–15550. doi: 10.1073/pnas.0506580102. [DOI] [PMC free article] [PubMed] [Google Scholar]

10. Yu G., Wang L.-G., He Q.-Y. ChIPseeker: an R/Bioconductor package for ChIP peak annotation, comparison and visualization. Bioinformatics. 2015;31:2382–2383. doi: 10.1093/bioinformatics/btv145. [DOI] [PubMed] [Google Scholar]

11. Yu G. Gene ontology semantic similarity analysis using GOSemSim. Methods Mol. Biol. Clifton NJ. 2020;2117:207–215. doi: 10.1007/978-1-0716-0301-7_11. [DOI] [PubMed] [Google Scholar]

12. Silva T.C., Colaprico A., Olsen C., et al. TCGA Workflow: analyze cancer genomics and epigenomics data using Bioconductor packages. F1000Research. 2016;5:1542. doi: 10.12688/f1000research.8923.2. [DOI] [PMC free article] [PubMed] [Google Scholar]

13. Treveil A., Bohar B., Sudhakar P., et al. ViralLink: an integrated workflow to investigate the effect of SARS-CoV-2 on intracellular signalling and regulatory pathways. PLOS Comput. Biol. 2021;17:e1008685. doi: 10.1371/journal.pcbi.1008685. [DOI] [PMC free article] [PubMed] [Google Scholar]

14. Yousif A., Drou N., Rowe J., et al. NASQAR: a web-based platform for high-throughput sequencing data analysis and visualization. BMC Bioinformatics. 2020;21:267. doi: 10.1186/s12859-020-03577-4. [DOI] [PMC free article] [PubMed] [Google Scholar]

15. Zou Y., Bui T.T., Selvarajoo K. ABioTrans: a biostatistical tool for transcriptomics analysis. Front. Genet. 2019;10:499. doi: 10.3389/fgene.2019.00499. [DOI] [PMC free article] [PubMed] [Google Scholar]

16. The Gene Ontology Consortium The gene ontology resource: 20 years and still GOing strong. Nucleic Acids Res. 2019;47:D330–D338. doi: 10.1093/nar/gky1055. [DOI] [PMC free article] [PubMed] [Google Scholar]

17. Yu G., Li F., Qin Y., et al. GOSemSim: an R package for measuring semantic similarity among GO terms and gene products. Bioinformatics. 2010;26:976–978. doi: 10.1093/bioinformatics/btq064. [DOI] [PubMed] [Google Scholar]

18. Haynes W.A., Tomczak A., Khatri P. Gene annotation bias impedes biomedical research. Sci. Rep. 2018;8:1362. doi: 10.1038/s41598-018-19333-x. [DOI] [PMC free article] [PubMed] [Google Scholar]

19. Kanehisa M., Furumichi M., Tanabe M., et al. KEGG: new perspectives on genomes, pathways, diseases and drugs. Nucleic Acids Res. 2017;45:D353–D361. doi: 10.1093/nar/gkw1092. [DOI] [PMC free article] [PubMed] [Google Scholar]

20. Zolti A., Green S.J., Sela N., et al. The microbiome as a biosensor: functional profiles elucidate hidden stress in hosts. Microbiome. 2020;8:71. doi: 10.1186/s40168-020-00850-9. [DOI] [PMC free article] [PubMed] [Google Scholar]

21. Alison M.R., Hunt T., Forbes S.J. Minichromosome maintenance (MCM) proteins may be pre-cancer markers. Gut. 2002;50:290–291. doi: 10.1136/gut.50.3.290. [DOI] [PMC free article] [PubMed] [Google Scholar]

22. Miossec P. Local and systemic effects of IL-17 in joint inflammation: a historical perspective from discovery to targeting. Cell. Mol. Immunol. 2021;18:860–865. doi: 10.1038/s41423-021-00644-5. [DOI] [PMC free article] [PubMed] [Google Scholar]

23. Heink S., Ludwig D., Kloetzel P.-M., et al. IFN-γ-induced immune adaptation of the proteasome system is an accelerated and transient response. Proc. Natl. Acad. Sci. U S A. 2005;102:9241–9246. doi: 10.1073/pnas.0501711102. [DOI] [PMC free article] [PubMed] [Google Scholar]

24. Yu G., Wang L.-G., Yan G.-R., et al. DOSE: an R/Bioconductor package for disease ontology semantic and enrichment analysis. Bioinformatics. 2015;31:608–609. doi: 10.1093/bioinformatics/btu684. [DOI] [PubMed] [Google Scholar]

25. Yu G., He Q.-Y. ReactomePA: an R/Bioconductor package for reactome pathway analysis and visualization. Mol. Biosyst. 2016;12:477–479. doi: 10.1039/c5mb00663e. [DOI] [PubMed] [Google Scholar]

26. Yu G. Using meshes for MeSH term enrichment and semantic analyses. Bioinformatics. 2018;34:3766–3767. doi: 10.1093/bioinformatics/bty410. [DOI] [PubMed] [Google Scholar]

27. Martens M., Ammar A., Riutta A., et al. WikiPathways: connecting communities. Nucleic Acids Res. 2021;49:D613–D621. doi: 10.1093/nar/gkaa1024. [DOI] [PMC free article] [PubMed] [Google Scholar]

28. Conesa A., Götz S., García-Gómez J.M., et al. Blast2GO: a universal tool for annotation, visualization and analysis in functional genomics research. Bioinformatics. 2005;21:3674–3676. doi: 10.1093/bioinformatics/bti610. [DOI] [PubMed] [Google Scholar]

29. Moriya Y., Itoh M., Okuda S., et al. KAAS: an automatic genome annotation and pathway reconstruction server. Nucleic Acids Res. 2007;35:W182–W185. doi: 10.1093/nar/gkm321. [DOI] [PMC free article] [PubMed] [Google Scholar]

30. Zhang X., Lan Y., Xu J., et al. CellMarker: a manually curated resource of cell markers in human and mouse. Nucleic Acids Res. 2019;47:D721–D728. doi: 10.1093/nar/gky900. [DOI] [PMC free article] [PubMed] [Google Scholar]

31. McLean C.Y., Bristor D., Hiller M., et al. GREAT improves functional interpretation of cis-regulatory regions. Nat. Biotechnol. 2010;28:495–501. doi: 10.1038/nbt.1630. [DOI] [PMC free article] [PubMed] [Google Scholar]

32. Liu Y., Fu L., Kaufmann K., et al. A practical guide for DNase-seq data analysis: from data management to common applications. Brief. Bioinform. 2019;20:1865–1877. doi: 10.1093/bib/bby057. [DOI] [PubMed] [Google Scholar]

33. Yin S., Lu K., Tan T., et al. Transcriptomic and open chromatin atlas of high-resolution anatomical regions in the rhesus macaque brain. Nat. Commun. 2020;11:474. doi: 10.1038/s41467-020-14368-z. [DOI] [PMC free article] [PubMed] [Google Scholar]

34. Oliviero G., Munawar N., Watson A., et al. The variant Polycomb Repressor Complex 1 component PCGF1 interacts with a pluripotency sub-network that includes DPPA4, a regulator of embryogenesis. Sci. Rep. 2015;5:18388. doi: 10.1038/srep18388. [DOI] [PMC free article] [PubMed] [Google Scholar]

35. Cheng B., Ren X., Kerppola T.K. KAP1 represses differentiation-inducible genes in embryonic stem cells through cooperative binding with PRC1 and derepresses pluripotency-associated genes. Mol. Cell. Biol. 2014;34:2075–2091. doi: 10.1128/MCB.01729-13. [DOI] [PMC free article] [PubMed] [Google Scholar]

36. Santanach A., Blanco E., Jiang H., et al. The Polycomb group protein CBX6 is an essential regulator of embryonic stem cell identity. Nat. Commun. 2017;8:1235. doi: 10.1038/s41467-017-01464-w. [DOI] [PMC free article] [PubMed] [Google Scholar]

37. Deng H., Guan X., Gong L., et al. CBX6 is negatively regulated by EZH2 and plays a potential tumor suppressor role in breast cancer. Sci. Rep. 2019;9:197. doi: 10.1038/s41598-018-36560-4. [DOI] [PMC free article] [PubMed] [Google Scholar]

38. Brun Y.F., Varma R., Hector S.M., et al. Simultaneous modeling of concentration-effect and time-course patterns in gene expression data from microarrays. Cancer Genomics Proteomics. 2008;5:43–53. [PubMed] [Google Scholar]

39. Korotkevich G., Sukhov V., Budin N., et al. Fast gene set enrichment analysis. bioRxiv. 2021 doi: 10.1101/060012. [DOI] [Google Scholar]

40. Wimalanathan K., Lawrence-Dill C.J. Gene ontology Meta annotator for plants (GOMAP). bioRxiv. 2021 doi: 10.1101/809988. [DOI] [PMC free article] [PubMed] [Google Scholar]

41. Collado-Torres L., Nellore A., Jaffe A.E. Recount workflow: accessing over 70,000 human RNA-seq samples with Bioconductor. F1000Research. 2017;6:1558. doi: 10.12688/f1000research.12223.1. [DOI] [PMC free article] [PubMed] [Google Scholar]

42. Chao K.-H., Hsiao Y.-W., Lee Y.-F., et al. RNASeqR: an R package for automated two-group RNA-Seq analysis workflow. IEEE/ACM Trans. Comput. Biol. Bioinform. 2019 doi: 10.1109/TCBB.2019.2956708. [DOI] [PubMed] [Google Scholar]

43. Wang B., Wang M., Zhang W., et al. Integrative analysis of pooled CRISPR genetic screens using MAGeCKFlute. Nat. Protoc. 2019;14:756–780. doi: 10.1038/s41596-018-0113-7. [DOI] [PMC free article] [PubMed] [Google Scholar]

## Associated Data

### Supplementary Materials

Document S1. Note S1 and Tables S1 and S2

mmc1.pdf (1.5MB, pdf)

Document S2. Article plus supplemental information

mmc2.pdf (6.5MB, pdf)

## Unconverted material

NP2024-reporting-summary.pdf: retained in the external review directory; contents were not converted.

## Unconverted material

NP2024-supplementary-note1.pdf: retained in the external review directory; contents were not converted.

## Reporting Summary, transcribed from the publisher's native file

# Nature Portfolio Reporting Summary — Xu et al. (2024), doi:10.1038/s41596-024-01020-z

Transcribed from the publisher's native file `41596_2024_1020_MOESM2_ESM.pdf` (2 pages, image-only
PDF, no text layer), rendered at 100 dpi. Checkbox states are read from the rendered form:
`☒` = ticked, `☐` = empty. The two pages of the printed article (PDF pp. 30–31) show the same form,
but a rotated PMC sidebar is composited over it and the tick glyphs collapse in the OCR layer, so
the transcription below is taken from the clean publisher file instead.

Corresponding author(s): Guangchuang Yu
Last updated by author(s): Apr 30, 2024

## Statistics

For all statistical analyses, confirm that the following items are present in the figure legend,
table legend, main text, or Methods section.

| n/a | Confirmed | Item |
| --- | --- | --- |
| ☒ | ☐ | The exact sample size (n) for each experimental group/condition, given as a discrete number and unit of measurement |
| ☒ | ☐ | A statement on whether measurements were taken from distinct samples or whether the same sample was measured repeatedly |
| ☒ | ☐ | The statistical test(s) used AND whether they are one- or two-sided |
| ☐ | ☐ | A description of all covariates tested |
| ☒ | ☐ | A description of any assumptions or corrections, such as tests of normality and adjustment for multiple comparisons |
| ☒ | ☐ | A full description of the statistical parameters including central tendency (e.g. means) or other basic estimates (e.g. regression coefficient) AND variation (e.g. standard deviation) or associated estimates of uncertainty (e.g. confidence intervals) |
| ☒ | ☐ | For null hypothesis testing, the test statistic (e.g. F, t, r) with confidence intervals, effect sizes, degrees of freedom and P value noted |
| ☒ | ☐ | For Bayesian analysis, information on the choice of priors and Markov chain Monte Carlo settings |
| ☒ | ☐ | For hierarchical and complex designs, identification of the appropriate level for tests and full reporting of outcomes |
| ☒ | ☐ | Estimates of effect sizes (e.g. Cohen's d, Pearson's r), indicating how they were calculated |

## Software and code

| Field | Value |
| --- | --- |
| Data collection | clusterProfiler |
| Data analysis | clusterProfiler |

## Data

Data availability statement as printed:

> All datasets in the protocol are available from https://yulab-smu.top/clusterProfiler_protocol/

## Human research participants

| Field | Value |
| --- | --- |
| Reporting on sex and gender | Not relevant |
| Population characteristics | Not relevant |
| Recruitment | Not relevant |
| Ethics oversight | Not relevant |

## Field-specific reporting

- ☒ Life sciences
- ☐ Behavioural & social sciences
- ☐ Ecological, evolutionary & environmental sciences

## Life sciences study design

All studies must disclose on these points even when the disclosure is negative.

| Field | Value |
| --- | --- |
| Sample size | All datasets used in the protocol are from the public domains. |
| Data exclusions | NA |
| Replication | NA |
| Randomization | NA |
| Blinding | NA |

## Reporting for specific materials, systems and methods

| n/a | Materials & experimental systems |
| --- | --- |
| ☒ | Antibodies |
| ☒ | Eukaryotic cell lines |
| ☒ | Palaeontology and archaeology |
| ☒ | Animals and other organisms |
| ☒ | Clinical data |
| ☒ | Dual use research of concern |

| n/a | Methods |
| --- | --- |
| ☒ | ChIP-seq |
| ☒ | Flow cytometry |
| ☒ | MRI-based neuroimaging |

Note on reading the last two tables: the form's left column is headed "n/a" and the right column
"Involved in the study". Every row carries a tick in the left (n/a) column and an empty box in the
right column, i.e. the authors marked all of these material and method categories as not applicable.


## Unconverted material

X2021-clusterProfiler4-supplement.pdf: retained in the external review directory; contents were not converted.

### Figure 1 of Yu et al. (2012): GO enrichment dot plot (badge-free published image)

[Figure 1 of Yu et al. (2012): GO enrichment dot plot (badge-free published image)](../assets/supp_figs/supplementary-figure-omics2012-1.jpg)

### Figure 1 of Wu et al. (2021): GO enrichment map, original (A) and simplified (B)

[Figure 1 of Wu et al. (2021): GO enrichment map, original (A) and simplified (B)](../assets/supp_figs/supplementary-figure-cp4-1.jpg)

### Figure 2 of Wu et al. (2021): KEGG pathway enrichment analysis

[Figure 2 of Wu et al. (2021): KEGG pathway enrichment analysis](../assets/supp_figs/supplementary-figure-cp4-2.jpg)

### Figure 3 of Wu et al. (2021): functional enrichment of genomic regions of interest

[Figure 3 of Wu et al. (2021): functional enrichment of genomic regions of interest](../assets/supp_figs/supplementary-figure-cp4-3.jpg)

### Figure 4 of Wu et al. (2021): comparing functional profiles across conditions

[Figure 4 of Wu et al. (2021): comparing functional profiles across conditions](../assets/supp_figs/supplementary-figure-cp4-4.jpg)

### Figure 5 of Wu et al. (2021): visualising enrichment results with ggplot2

[Figure 5 of Wu et al. (2021): visualising enrichment results with ggplot2](../assets/supp_figs/supplementary-figure-cp4-5.jpg)

### Figure 6 of Wu et al. (2021): the clusterProfiler package suite

[Figure 6 of Wu et al. (2021): the clusterProfiler package suite](../assets/supp_figs/supplementary-figure-cp4-6.jpg)

### Graphical abstract of Wu et al. (2021)

[Graphical abstract of Wu et al. (2021)](../assets/supp_figs/supplementary-figure-cp4-7.jpg)

## Conversion notes

- Page 1 was already final; pages 2-6 were rebuilt from extractor output during review (reading order, cross-page joins, superscript repair, PMC furniture removed).
- Figure 1 on page 3 is retained as supplementary-figure-pac2024-1 [38.0,96.0,558.0,479.0] with its caption split into label, title and body items.
- The full 11-entry reference list is retained across pages 5-6; PMC per-entry link decorations ([DOI ], [PMC free article], [PubMed], [Google Scholar ]) were stripped while doi: text was kept.
- Reference 4 ('Innovation. 2021;2 doi: ...') and reference 9 ('... Preprint at.') are incomplete as printed in the source; transcribed as-is, not corrected.
- Review record: this source was reviewed page by page; the review report is kept with the build evidence and is not part of this reading package.
- This PDF is a print-to-PDF rendering of the PMC HTML page for PMC3339379, so it carries website furniture (NLM banner, PMC disclaimer/copyright links, journal logo, search and navigation, 'Download PDF'/'Cite'/'Share', 'Similar articles', 'Cited by', 'Open in a new tab', and a SAGE courtesy footer). That furniture was omitted during review and is not part of the paper.
- The PMC reference list appends '[DOI] [PMC free article] [PubMed] [Google Scholar]' link decorations to every entry. They were removed during review; all DOIs, volumes, issues and page ranges were kept exactly.
- The document is the 2012 OMICS application note supplied as supplementary material. It contains one figure (Figure 1, the GO enrichment dot plot, stored as supplementary-figure-omics2012-1), no tables, and no code listings.
- Figure 1 is supplied from the article's own published image file, which carries no PMC zoom badge; the badge only appears in a crop of the printed page, and that crop is not used.
- This document is the PMC rendering of doi:10.1016/j.xinn.2021.100141 (PMC8454663), reproduced from the print-to-PDF copy of the article page. The NLM banner, PMC disclaimer and copyright navigation, journal logo, per-figure zoom and 'Open in a new tab' controls, the 'Author information Article notes Copyright and License information' strip, the PMC 'Associated Data' boilerplate sentence and the 'courtesy of Elsevier' footer belong to the website, not the article, and are absent from this document. The article itself - title, authors, abstract, body sections, figure legends, Table 1, references 1-43 and the supplementary listings - is present in print order.
- Figures 1, 2, 3, 6 and the graphical abstract are supplied from the publisher's own image files, because the printed PDF captured only grey lazy-load placeholders (Figures 1, 2, 6) or badge-bearing renders (Figures 3 and the graphical abstract). Figures 4 and 5 print only their labels with no artwork at all, so those two also come from the publisher's files.
- Table 1 is printed across two pages (5 and 6). It appears here once, as supplementary-table-cp4-1 with 35 rows including the header, so the continuation on page 6 is not duplicated.
- Page 30 of the printed copy is blank and contributes nothing to this document.
- The article refers to two online-only supplements that are not part of this print: Document S1 (mmc1.pdf, containing Note S1 and Tables S1 and S2) and Document S2 (mmc2.pdf, the article plus supplemental information). Their contents are not available here; Table S1 and Table S2 are referred to in the body text but cannot be consulted.
