# QC report
- study: World Asthma Phenotype Study
- author: David E. Rebellon Sanchez
- date: 28 August, 2026

## Parameters used for QC


```
## $colour.code
## NULL
## 
## $control.categories
## NULL
## 
## $sex.outlier.sd
## [1] 3
## 
## $meth.unmeth.outlier.sd
## [1] 3
## 
## $control.means.outlier.sd
## [1] 5
## 
## $detectionp.samples.threshold
## [1] 0.2
## 
## $beadnum.samples.threshold
## [1] 0.2
## 
## $detectionp.cpgs.threshold
## [1] 0.2
## 
## $beadnum.cpgs.threshold
## [1] 0.2
## 
## $snp.concordance.threshold
## [1] 0.9
## 
## $sample.genotype.concordance.threshold
## [1] 0.9
## 
## $detection.threshold
## [1] 0.01
## 
## $bead.threshold
## [1] 3
## 
## $sex.cutoff
## [1] -2
```
## Number of samples

There are 191 samples analysed.

## Sex mismatches

To separate females and males, we use the difference of total median intensity for Y chromosome probes and X chromosome probes. This will give two distinct clusters of intensities. Females will be clustered on the left and males on the right. 
There are 2 sex detection outliers, and 5 sex detection mismatches.


|sample.name         |predicted.sex |declared.sex |    xy.diff|status     |
|:-------------------|:-------------|:------------|----------:|:----------|
|205809370173_R06C01 |F             |M            | -4.1137735|mismatched |
|205809380108_R01C01 |M             |F            | -0.0252348|mismatched |
|205809380033_R03C01 |M             |F            |  0.4766421|mismatched |
|205809380033_R06C01 |M             |F            |  0.5245148|mismatched |
|205809370173_R08C01 |M             |F            |  0.5295545|mismatched |
|205809360134_R02C01 |F             |F            | -2.6872131|outlier    |

This is a plot of the difference between median 
chromosome Y and chromosome X probe intensities ("XY diff").
Cutoff for sex detection was
XY diff = -2. Mismatched samples are shown in red. The dashed lines represent 3 SD from  the mean xy difference. Samples that fall in this interval are denoted as outliers.



![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)


## Methylated vs unmethylated
To explore the quality of the samples, it is useful to plot the median methylation intensity against the median unmethylation intensity with the option to color outliers by group.
There are 0 outliers from the meth vs unmeth comparison.
Outliers are samples whose predicted median methylated signal is
more than 3 standard deviations
from the expected (regression line).



This is a plot of the methylation signals vs unmethylated signals



![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)


## Control probe means

There were 10 outliers detected based on deviations from mean values for control probes. The beachip arrays contain control probe which can be used to evaluate the quality of specific sample processing steps (staining, extension,target removal, hybridization, bisulfate conversion etc.). For each step, a plot has been generated which shows the control means for each sample. Outliers are deviations from the mean. Some of the control probe categories have a very small number of probes. See Page 222 in this doc: https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/infinium_assays/infinium_hd_methylation/infinium-hd-methylation-guide-15019519-01.pdf. The most important control probes are the bisulfite1 and bisulfite2 control probes. 


|sample.name         |colour.code |  id|variable           |        value|outliers |
|:-------------------|:-----------|---:|:------------------|------------:|:--------|
|205809380108_R02C01 |1           | 169|targetrem.39773404 |  660.0000000|TRUE     |
|205809380108_R02C01 |1           | 169|targetrem.42790394 | 1053.0000000|TRUE     |
|205809360147_R05C01 |1           |  45|spec1.G.61624401   | 5443.0000000|TRUE     |
|205809380108_R01C01 |1           | 168|spec1.ratio1       |    1.4928685|TRUE     |
|205809380108_R01C01 |1           | 168|spec1.ratio        |    1.0237191|TRUE     |
|205809380108_R02C01 |1           | 169|spec1.ratio        |    0.5804748|TRUE     |
|205809380108_R01C01 |1           | 168|spec2.ratio        |    0.5036166|TRUE     |
|205809380108_R02C01 |1           | 169|spec2.ratio        |    0.5390796|TRUE     |
|205809380108_R01C01 |1           | 168|spec1.ratio2       |    0.5545697|TRUE     |
|205809380108_R02C01 |1           | 169|spec1.ratio2       |    0.5230875|TRUE     |

The distribution of sample control means are plotted here:



![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png)


## Sample detection p-values

To further explore the quality of each sample the proportion of probes that didn't pass the detection pvalue has been calculated.
There were 2 samples
with a high proportion of undetected probes
(proportion of probes with
detection p-value > 0.01
is > 0.2).


|sample.name         | prop.badprobes| colour.code|  id|outliers |
|:-------------------|--------------:|-----------:|---:|:--------|
|205809380108_R01C01 |      0.9181793|           1| 168|TRUE     |
|205809380108_R02C01 |      0.4420918|           1| 169|TRUE     |

Distribution:



![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png)


## Sample bead numbers


To further assess the quality of each sample the proportion of probes that didn't pass the number of beads threshold has been calculated.
There were 0 samples
with a high proportion of probes with low bead number
(proportion of probes with
bead number < 3
is > 0.2).



Distribution:



![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png)


## CpG detection p-values

To explore the quality of the probes, the proportion of samples that didn't pass the detection pvalue threshold has been calculated.
There were 1351
probes with only background signal in a high proportion of samples
(proportion of samples with detection p-value > 0.01
is > 0.2).
Manhattan plot shows the proportion of samples.



![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png)

## Low number of beads per CpG

To further explore the quality of the probes, the proportion of samples that didn't pass the number of beads threshold has been calculated.
There were 435 CpGs
with low bead numbers in a high proportion of samples
(proportion of samples with bead number < 3
is > 0.2).
Manhattan plot of proportion of samples.



![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png)

## Cellular composition estimates




Cell counts were estimated using the saliva gse48472 cell type methylation profile references.

Plot compares methylation levels of CpG sites used to estimate cellular composition
for each sample and reference methylation profile.
Methylation levels of samples should generally overlap with reference methylation levels
otherwise estimation will have simply selected the cell type reference
with the nearest mean methylation level.



![plot of chunk unnamed-chunk-35](figure/unnamed-chunk-35-1.png)

Boxplot shows the distributions of estimated cellular composition for each reference cell type across all samples.



![plot of chunk unnamed-chunk-36](figure/unnamed-chunk-36-1.png)

## SNP probe beta values

The array includes snp probes which can be used to identify sample swaps by comparing these genotypes to genotype calls from a genotype array. First you could check the quality of these snp probes before using them for sample quality.
Distributions of SNP probe beta values are used to determine the quality of the snp probe and should show 3 peaks, one for each genotype probability.


![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png)

## Genotype concordance




This section omitted.

## R session information


```
## R version 4.3.3 (2024-02-29)
## Platform: x86_64-conda-linux-gnu (64-bit)
## Running under: Linux (unknown distro)
## 
## Matrix products: default
## BLAS/LAPACK: /home/lsh2301541/miniconda3/envs/R_env/lib/libopenblasp-r0.3.21.so;  LAPACK version 3.9.0
## 
## locale:
##  [1] LC_CTYPE=en_GB.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_GB.UTF-8        LC_COLLATE=en_GB.UTF-8    
##  [5] LC_MONETARY=en_GB.UTF-8    LC_MESSAGES=en_GB.UTF-8   
##  [7] LC_PAPER=en_GB.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_GB.UTF-8 LC_IDENTIFICATION=C       
## 
## time zone: Europe/London
## tzcode source: system (glibc)
## 
## attached base packages:
## [1] parallel  stats4    stats     graphics  grDevices utils     datasets 
## [8] methods   base     
## 
## other attached packages:
##  [1] meffil_1.5.0          preprocessCore_1.64.0 SmartSVA_0.1.3       
##  [4] RSpectra_0.16-2       isva_1.9              JADE_2.0-4           
##  [7] qvalue_2.34.0         gdsfmt_1.38.0         statmod_1.5.0        
## [10] quadprog_1.5-8        DNAcopy_1.76.0        fastICA_1.2-4        
## [13] lme4_1.1-35.5         Matrix_1.6-5          multcomp_1.4-26      
## [16] TH.data_1.1-2         survival_3.7-0        mvtnorm_1.2-3        
## [19] matrixStats_1.3.0     markdown_1.13         gridExtra_2.3        
## [22] Cairo_1.6-2           knitr_1.48            reshape2_1.4.4       
## [25] plyr_1.8.9            sva_3.50.0            BiocParallel_1.36.0  
## [28] genefilter_1.84.0     mgcv_1.9-1            nlme_3.1-165         
## [31] limma_3.58.1          sandwich_3.1-0        lmtest_0.9-40        
## [34] zoo_1.8-14            MASS_7.3-60.0.1       illuminaio_0.44.0    
## [37] openxlsx_4.2.6.1      GenomicRanges_1.54.1  GenomeInfoDb_1.38.8  
## [40] IRanges_2.36.0        S4Vectors_0.40.2      BiocGenerics_0.48.1  
## [43] lubridate_1.9.4       forcats_1.0.0         stringr_1.5.1        
## [46] dplyr_1.1.4           purrr_1.0.2           readr_2.1.5          
## [49] tidyr_1.3.1           tibble_3.2.1          ggplot2_4.0.1        
## [52] tidyverse_2.0.0      
## 
## loaded via a namespace (and not attached):
##  [1] DBI_1.2.3               bitops_1.0-7            rlang_1.1.4            
##  [4] magrittr_2.0.3          clue_0.3-65             compiler_4.3.3         
##  [7] RSQLite_2.3.7           png_0.1-8               vctrs_0.6.5            
## [10] pkgconfig_2.0.3         crayon_1.5.3            fastmap_1.2.0          
## [13] XVector_0.42.0          labeling_0.4.3          utf8_1.2.4             
## [16] tzdb_0.4.0              nloptr_2.0.3            bit_4.0.5              
## [19] xfun_0.45               zlibbioc_1.48.2         cachem_1.1.0           
## [22] blob_1.2.4              highr_0.11              cluster_2.1.6          
## [25] R6_2.5.1                stringi_1.8.4           RColorBrewer_1.1-3     
## [28] boot_1.3-30             Rcpp_1.0.13             splines_4.3.3          
## [31] timechange_0.3.0        tidyselect_1.2.1        dichromat_2.0-0.1      
## [34] codetools_0.2-20        lattice_0.22-6          Biobase_2.62.0         
## [37] withr_3.0.0             KEGGREST_1.42.0         S7_0.2.0               
## [40] askpass_1.2.0           evaluate_0.24.0         zip_2.3.1              
## [43] Biostrings_2.70.3       pillar_1.9.0            MatrixGenerics_1.14.0  
## [46] generics_0.1.3          RCurl_1.98-1.16         hms_1.1.3              
## [49] scales_1.4.0            minqa_1.2.7             xtable_1.8-4           
## [52] glue_1.7.0              tools_4.3.3             annotate_1.80.0        
## [55] locfit_1.5-9.10         XML_3.99-0.17           grid_4.3.3             
## [58] AnnotationDbi_1.64.1    edgeR_4.0.16            base64_2.0.1           
## [61] GenomeInfoDbData_1.2.11 cli_3.6.3               fansi_1.0.6            
## [64] gtable_0.3.6            farver_2.1.2            memoise_2.0.1          
## [67] lifecycle_1.0.4         httr_1.4.7              openssl_2.2.0          
## [70] bit64_4.0.5
```
