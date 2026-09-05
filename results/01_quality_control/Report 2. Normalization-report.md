# Normalization performance report
- study: World Asthma Phenotype Study
- author: David E. Rebellon Sanchez
- date: 28 August, 2026

## Parameters used to test normalization


```
## $variables
##  [1] "Study_id"                                   
##  [2] "Sample_Plate"                               
##  [3] "Sample_Group"                               
##  [4] "Pool_ID"                                    
##  [5] "Project"                                    
##  [6] "Sample_Well"                                
##  [7] "uniquekey"                                  
##  [8] "studysubjectid"                             
##  [9] "centre"                                     
## [10] "group"                                      
## [11] "age"                                        
## [12] "severity_isaac"                             
## [13] "severity_12atac"                            
## [14] "sptpos"                                     
## [15] "sputum_phenotype1_first"                    
## [16] "acqscore"                                   
## [17] "acqscorecat"                                
## [18] "phadresult"                                 
## [19] "phadpos"                                    
## [20] "dateofsample1"                              
## [21] "dateofdcc1"                                 
## [22] "observer1"                                  
## [23] "neutrophilscount1"                          
## [24] "lymphocytescount1"                          
## [25] "monocytesmacrophagescount1"                 
## [26] "eosinophilscount1"                          
## [27] "bronchialepithelialcellscount1"             
## [28] "totalnonsquamouscellscount1"                
## [29] "squamouscellscount1"                        
## [30] "totalcellcount1"                            
## [31] "neutrophils1"                               
## [32] "lymphocytes1"                               
## [33] "monocytesmacrophages1"                      
## [34] "eosinophils1"                               
## [35] "bronchialepithelialcells1"                  
## [36] "squamouscells1"                             
## [37] "sputum_phenotype1_1"                        
## [38] "sputum_phenotype_eos1"                      
## [39] "sputum_phenotype_neutro1"                   
## [40] "goodquality_sputum1"                        
## [41] "dateofsample2"                              
## [42] "dateofdcc2"                                 
## [43] "observer2"                                  
## [44] "neutrophilscount2"                          
## [45] "lymphocytescount2"                          
## [46] "monocytesmacrophagescount2"                 
## [47] "eosinophilscount2"                          
## [48] "bronchialepithelialcellscount2"             
## [49] "totalnonsquamouscellscount2"                
## [50] "squamouscellscount2"                        
## [51] "totalcellcount2"                            
## [52] "neutrophils2"                               
## [53] "lymphocytes2"                               
## [54] "monocytesmacrophages2"                      
## [55] "eosinophils2"                               
## [56] "bronchialepithelialcells2"                  
## [57] "squamouscells2"                             
## [58] "sputum_phenotype1_2"                        
## [59] "sputum_phenotype_eos2"                      
## [60] "sputum_phenotype_neutro2"                   
## [61] "goodquality_sputum2"                        
## [62] "duplicated_epigen_analysis_has_2_samples"   
## [63] "visit_epigenetic_sample"                    
## [64] "proccessed_but_pre_excluded_epigen_analysis"
## [65] "reason_for_pre_exclude_epigen_analysis"     
## [66] "neutrophilscount_epigen"                    
## [67] "lymphocytescount_epigen"                    
## [68] "monocytesmacrophagescount_epigen"           
## [69] "eosinophilscount_epigen"                    
## [70] "bronchialepithelialcellscount_epigen"       
## [71] "totalnonsquamouscellscount_epigen"          
## [72] "squamouscellscount_epigen"                  
## [73] "totalcellcount_epigen"                      
## [74] "neutrophils_epigen"                         
## [75] "lymphocytes_epigen"                         
## [76] "monocytesmacrophages_epigen"                
## [77] "eosinophils_epigen"                         
## [78] "bronchialepithelialcells_epigen"            
## [79] "squamouscells_epigen"                       
## [80] "sputum_phenotype_epigen"                    
## [81] "sputum_phenotype_eos_epigen"                
## [82] "sputum_phenotype_neutro_epigen"             
## [83] "goodquality_epigen"                         
## [84] "Array"                                      
## [85] "Slide"                                      
## [86] "sentrix_row"                                
## [87] "sentrix_col"                                
## 
## $control.pcs
##  [1]  1  2  3  4  5  6  7  8  9 10
## 
## $batch.pcs
##  [1]  1  2  3  4  5  6  7  8  9 10
## 
## $batch.threshold
## [1] 0.01
## 
## $colours
## NULL
```

## Control probe scree plots

The variance captured by each principal component.






![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21-1.png)




![plot of chunk unnamed-chunk-22](figure/unnamed-chunk-22-1.png)




![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23-1.png)

## Principal components of the control probes

The following plots show the first 3 principal components of the
control matrix colored by batch variables.
Batch variables with more than 10 levels are omitted.






![plot of chunk unnamed-chunk-27](figure/unnamed-chunk-27-1.png)






![plot of chunk unnamed-chunk-30](figure/unnamed-chunk-30-1.png)






![plot of chunk unnamed-chunk-33](figure/unnamed-chunk-33-1.png)






![plot of chunk unnamed-chunk-36](figure/unnamed-chunk-36-1.png)






![plot of chunk unnamed-chunk-39](figure/unnamed-chunk-39-1.png)






![plot of chunk unnamed-chunk-42](figure/unnamed-chunk-42-1.png)






![plot of chunk unnamed-chunk-45](figure/unnamed-chunk-45-1.png)






![plot of chunk unnamed-chunk-48](figure/unnamed-chunk-48-1.png)






![plot of chunk unnamed-chunk-51](figure/unnamed-chunk-51-1.png)






![plot of chunk unnamed-chunk-54](figure/unnamed-chunk-54-1.png)






![plot of chunk unnamed-chunk-57](figure/unnamed-chunk-57-1.png)






![plot of chunk unnamed-chunk-60](figure/unnamed-chunk-60-1.png)






![plot of chunk unnamed-chunk-63](figure/unnamed-chunk-63-1.png)






![plot of chunk unnamed-chunk-66](figure/unnamed-chunk-66-1.png)






![plot of chunk unnamed-chunk-69](figure/unnamed-chunk-69-1.png)






![plot of chunk unnamed-chunk-72](figure/unnamed-chunk-72-1.png)






![plot of chunk unnamed-chunk-75](figure/unnamed-chunk-75-1.png)






![plot of chunk unnamed-chunk-78](figure/unnamed-chunk-78-1.png)






![plot of chunk unnamed-chunk-81](figure/unnamed-chunk-81-1.png)






![plot of chunk unnamed-chunk-84](figure/unnamed-chunk-84-1.png)






![plot of chunk unnamed-chunk-87](figure/unnamed-chunk-87-1.png)






![plot of chunk unnamed-chunk-90](figure/unnamed-chunk-90-1.png)






![plot of chunk unnamed-chunk-93](figure/unnamed-chunk-93-1.png)






![plot of chunk unnamed-chunk-96](figure/unnamed-chunk-96-1.png)






![plot of chunk unnamed-chunk-99](figure/unnamed-chunk-99-1.png)






![plot of chunk unnamed-chunk-102](figure/unnamed-chunk-102-1.png)






![plot of chunk unnamed-chunk-105](figure/unnamed-chunk-105-1.png)






![plot of chunk unnamed-chunk-108](figure/unnamed-chunk-108-1.png)






![plot of chunk unnamed-chunk-111](figure/unnamed-chunk-111-1.png)






![plot of chunk unnamed-chunk-114](figure/unnamed-chunk-114-1.png)






![plot of chunk unnamed-chunk-117](figure/unnamed-chunk-117-1.png)






![plot of chunk unnamed-chunk-120](figure/unnamed-chunk-120-1.png)






![plot of chunk unnamed-chunk-123](figure/unnamed-chunk-123-1.png)






![plot of chunk unnamed-chunk-126](figure/unnamed-chunk-126-1.png)






![plot of chunk unnamed-chunk-129](figure/unnamed-chunk-129-1.png)






![plot of chunk unnamed-chunk-132](figure/unnamed-chunk-132-1.png)






![plot of chunk unnamed-chunk-135](figure/unnamed-chunk-135-1.png)






![plot of chunk unnamed-chunk-138](figure/unnamed-chunk-138-1.png)






![plot of chunk unnamed-chunk-141](figure/unnamed-chunk-141-1.png)






![plot of chunk unnamed-chunk-144](figure/unnamed-chunk-144-1.png)






![plot of chunk unnamed-chunk-147](figure/unnamed-chunk-147-1.png)






![plot of chunk unnamed-chunk-150](figure/unnamed-chunk-150-1.png)

## Control probe associations with measured batch variables

Principal components of the control probes were regressed against batch variables.
Shown are the $-log_{10}$ p-values for these regressions.
The horizontal dotted line denotes $p = 0.05$ in log-scale.






![plot of chunk unnamed-chunk-155](figure/unnamed-chunk-155-1.png)






![plot of chunk unnamed-chunk-158](figure/unnamed-chunk-158-1.png)






![plot of chunk unnamed-chunk-161](figure/unnamed-chunk-161-1.png)






![plot of chunk unnamed-chunk-164](figure/unnamed-chunk-164-1.png)






![plot of chunk unnamed-chunk-167](figure/unnamed-chunk-167-1.png)






![plot of chunk unnamed-chunk-170](figure/unnamed-chunk-170-1.png)






![plot of chunk unnamed-chunk-173](figure/unnamed-chunk-173-1.png)






![plot of chunk unnamed-chunk-176](figure/unnamed-chunk-176-1.png)






![plot of chunk unnamed-chunk-179](figure/unnamed-chunk-179-1.png)






![plot of chunk unnamed-chunk-182](figure/unnamed-chunk-182-1.png)






![plot of chunk unnamed-chunk-185](figure/unnamed-chunk-185-1.png)






![plot of chunk unnamed-chunk-188](figure/unnamed-chunk-188-1.png)






![plot of chunk unnamed-chunk-191](figure/unnamed-chunk-191-1.png)






![plot of chunk unnamed-chunk-194](figure/unnamed-chunk-194-1.png)






![plot of chunk unnamed-chunk-197](figure/unnamed-chunk-197-1.png)






![plot of chunk unnamed-chunk-200](figure/unnamed-chunk-200-1.png)






![plot of chunk unnamed-chunk-203](figure/unnamed-chunk-203-1.png)






![plot of chunk unnamed-chunk-206](figure/unnamed-chunk-206-1.png)






![plot of chunk unnamed-chunk-209](figure/unnamed-chunk-209-1.png)






![plot of chunk unnamed-chunk-212](figure/unnamed-chunk-212-1.png)






![plot of chunk unnamed-chunk-215](figure/unnamed-chunk-215-1.png)






![plot of chunk unnamed-chunk-218](figure/unnamed-chunk-218-1.png)






![plot of chunk unnamed-chunk-221](figure/unnamed-chunk-221-1.png)






![plot of chunk unnamed-chunk-224](figure/unnamed-chunk-224-1.png)






![plot of chunk unnamed-chunk-227](figure/unnamed-chunk-227-1.png)






![plot of chunk unnamed-chunk-230](figure/unnamed-chunk-230-1.png)






![plot of chunk unnamed-chunk-233](figure/unnamed-chunk-233-1.png)






![plot of chunk unnamed-chunk-236](figure/unnamed-chunk-236-1.png)






![plot of chunk unnamed-chunk-239](figure/unnamed-chunk-239-1.png)






![plot of chunk unnamed-chunk-242](figure/unnamed-chunk-242-1.png)






![plot of chunk unnamed-chunk-245](figure/unnamed-chunk-245-1.png)






![plot of chunk unnamed-chunk-248](figure/unnamed-chunk-248-1.png)






![plot of chunk unnamed-chunk-251](figure/unnamed-chunk-251-1.png)






![plot of chunk unnamed-chunk-254](figure/unnamed-chunk-254-1.png)






![plot of chunk unnamed-chunk-257](figure/unnamed-chunk-257-1.png)






![plot of chunk unnamed-chunk-260](figure/unnamed-chunk-260-1.png)






![plot of chunk unnamed-chunk-263](figure/unnamed-chunk-263-1.png)






![plot of chunk unnamed-chunk-266](figure/unnamed-chunk-266-1.png)






![plot of chunk unnamed-chunk-269](figure/unnamed-chunk-269-1.png)






![plot of chunk unnamed-chunk-272](figure/unnamed-chunk-272-1.png)






![plot of chunk unnamed-chunk-275](figure/unnamed-chunk-275-1.png)






![plot of chunk unnamed-chunk-278](figure/unnamed-chunk-278-1.png)






![plot of chunk unnamed-chunk-281](figure/unnamed-chunk-281-1.png)






![plot of chunk unnamed-chunk-284](figure/unnamed-chunk-284-1.png)






![plot of chunk unnamed-chunk-287](figure/unnamed-chunk-287-1.png)






![plot of chunk unnamed-chunk-290](figure/unnamed-chunk-290-1.png)






![plot of chunk unnamed-chunk-293](figure/unnamed-chunk-293-1.png)






![plot of chunk unnamed-chunk-296](figure/unnamed-chunk-296-1.png)






![plot of chunk unnamed-chunk-299](figure/unnamed-chunk-299-1.png)






![plot of chunk unnamed-chunk-302](figure/unnamed-chunk-302-1.png)






![plot of chunk unnamed-chunk-305](figure/unnamed-chunk-305-1.png)






![plot of chunk unnamed-chunk-308](figure/unnamed-chunk-308-1.png)






![plot of chunk unnamed-chunk-311](figure/unnamed-chunk-311-1.png)






![plot of chunk unnamed-chunk-314](figure/unnamed-chunk-314-1.png)






![plot of chunk unnamed-chunk-317](figure/unnamed-chunk-317-1.png)






![plot of chunk unnamed-chunk-320](figure/unnamed-chunk-320-1.png)






![plot of chunk unnamed-chunk-323](figure/unnamed-chunk-323-1.png)






![plot of chunk unnamed-chunk-326](figure/unnamed-chunk-326-1.png)






![plot of chunk unnamed-chunk-329](figure/unnamed-chunk-329-1.png)






![plot of chunk unnamed-chunk-332](figure/unnamed-chunk-332-1.png)






![plot of chunk unnamed-chunk-335](figure/unnamed-chunk-335-1.png)






![plot of chunk unnamed-chunk-338](figure/unnamed-chunk-338-1.png)






![plot of chunk unnamed-chunk-341](figure/unnamed-chunk-341-1.png)






![plot of chunk unnamed-chunk-344](figure/unnamed-chunk-344-1.png)






![plot of chunk unnamed-chunk-347](figure/unnamed-chunk-347-1.png)






![plot of chunk unnamed-chunk-350](figure/unnamed-chunk-350-1.png)






![plot of chunk unnamed-chunk-353](figure/unnamed-chunk-353-1.png)






![plot of chunk unnamed-chunk-356](figure/unnamed-chunk-356-1.png)






![plot of chunk unnamed-chunk-359](figure/unnamed-chunk-359-1.png)






![plot of chunk unnamed-chunk-362](figure/unnamed-chunk-362-1.png)






![plot of chunk unnamed-chunk-365](figure/unnamed-chunk-365-1.png)






![plot of chunk unnamed-chunk-368](figure/unnamed-chunk-368-1.png)






![plot of chunk unnamed-chunk-371](figure/unnamed-chunk-371-1.png)






![plot of chunk unnamed-chunk-374](figure/unnamed-chunk-374-1.png)






![plot of chunk unnamed-chunk-377](figure/unnamed-chunk-377-1.png)






![plot of chunk unnamed-chunk-380](figure/unnamed-chunk-380-1.png)






![plot of chunk unnamed-chunk-383](figure/unnamed-chunk-383-1.png)






![plot of chunk unnamed-chunk-386](figure/unnamed-chunk-386-1.png)






![plot of chunk unnamed-chunk-389](figure/unnamed-chunk-389-1.png)






![plot of chunk unnamed-chunk-392](figure/unnamed-chunk-392-1.png)






![plot of chunk unnamed-chunk-395](figure/unnamed-chunk-395-1.png)






![plot of chunk unnamed-chunk-398](figure/unnamed-chunk-398-1.png)






![plot of chunk unnamed-chunk-401](figure/unnamed-chunk-401-1.png)






![plot of chunk unnamed-chunk-404](figure/unnamed-chunk-404-1.png)






![plot of chunk unnamed-chunk-407](figure/unnamed-chunk-407-1.png)






![plot of chunk unnamed-chunk-410](figure/unnamed-chunk-410-1.png)






![plot of chunk unnamed-chunk-413](figure/unnamed-chunk-413-1.png)


The following plots show regression coefficients when
each principal component is regressed against each batch variable level
along with 95% confidence intervals.
Cases significantly different from zero are coloured red
(p < 0.01, t-test).






![plot of chunk unnamed-chunk-417](figure/unnamed-chunk-417-1.png)




![plot of chunk unnamed-chunk-418](figure/unnamed-chunk-418-1.png)




![plot of chunk unnamed-chunk-419](figure/unnamed-chunk-419-1.png)




![plot of chunk unnamed-chunk-420](figure/unnamed-chunk-420-1.png)




![plot of chunk unnamed-chunk-421](figure/unnamed-chunk-421-1.png)




![plot of chunk unnamed-chunk-422](figure/unnamed-chunk-422-1.png)




![plot of chunk unnamed-chunk-423](figure/unnamed-chunk-423-1.png)




![plot of chunk unnamed-chunk-424](figure/unnamed-chunk-424-1.png)




![plot of chunk unnamed-chunk-425](figure/unnamed-chunk-425-1.png)




![plot of chunk unnamed-chunk-426](figure/unnamed-chunk-426-1.png)


|batch.variable                   |batch.value        |principal.component |test   |p.value  |estimate |lower    |upper   |r2     |
|:--------------------------------|:------------------|:-------------------|:------|:--------|:--------|:--------|:-------|:------|
|Study_id                         |111                |PC1                 |t-test |5.99e-04 |13.825   |4.9068   |22.7422 |0.0649 |
|Study_id                         |UGA_200            |PC1                 |t-test |1.17e-03 |13.052   |4.1339   |21.9693 |0.0583 |
|Study_id                         |UGA_212            |PC1                 |t-test |4.49e-03 |11.386   |2.4681   |20.3035 |0.0450 |
|Study_id                         |UGA_228            |PC1                 |t-test |5.38e-03 |10.934   |2.1868   |19.6816 |0.0434 |
|Study_id                         |UGA_39             |PC1                 |t-test |7.84e-03 |-10.455  |-19.2192 |-1.6905 |0.0397 |
|Study_id                         |WASP112            |PC1                 |t-test |2.39e-03 |-12.189  |-21.1072 |-3.2718 |0.0512 |
|Study_id                         |WASP2              |PC1                 |t-test |6.69e-03 |-10.855  |-19.7731 |-1.9377 |0.0410 |
|Study_id                         |WASP41             |PC1                 |t-test |7.75e-03 |-10.470  |-19.2338 |-1.7060 |0.0398 |
|Study_id                         |WASP81             |PC1                 |t-test |7.74e-04 |-13.534  |-22.4516 |-4.6162 |0.0624 |
|Sample_Well                      |                   |PC1                 |F-test |2.08e-03 |1.864    |         |        |0.7085 |
|Sample_Well                      |A01                |PC1                 |t-test |1.05e-03 |-9.253   |-15.5146 |-2.9910 |0.0593 |
|Sample_Well                      |A09                |PC1                 |t-test |2.11e-05 |-12.024  |-18.2252 |-5.8226 |0.0979 |
|Sample_Well                      |F13                |PC1                 |t-test |1.17e-03 |13.052   |4.1339   |21.9693 |0.0583 |
|Sample_Well                      |G13                |PC1                 |t-test |4.49e-03 |11.386   |2.4681   |20.3035 |0.0450 |
|Sample_Well                      |H13                |PC1                 |t-test |5.38e-03 |10.934   |2.1868   |19.6816 |0.0434 |
|studysubjectid                   |A0596              |PC1                 |t-test |5.38e-03 |10.934   |2.1868   |19.6816 |0.0434 |
|studysubjectid                   |A0631              |PC1                 |t-test |7.84e-03 |-10.455  |-19.2192 |-1.6905 |0.0397 |
|studysubjectid                   |A0737              |PC1                 |t-test |1.17e-03 |13.052   |4.1339   |21.9693 |0.0583 |
|studysubjectid                   |A0748              |PC1                 |t-test |4.49e-03 |11.386   |2.4681   |20.3035 |0.0450 |
|studysubjectid                   |AQ9509             |PC1                 |t-test |5.99e-04 |13.825   |4.9068   |22.7422 |0.0649 |
|studysubjectid                   |BR3871             |PC1                 |t-test |7.75e-03 |-10.470  |-19.2338 |-1.7060 |0.0398 |
|studysubjectid                   |BR7029             |PC1                 |t-test |6.69e-03 |-10.855  |-19.7731 |-1.9377 |0.0410 |
|studysubjectid                   |MB1436             |PC1                 |t-test |7.74e-04 |-13.534  |-22.4516 |-4.6162 |0.0624 |
|studysubjectid                   |NG561              |PC1                 |t-test |2.39e-03 |-12.189  |-21.1072 |-3.2718 |0.0512 |
|centre                           |                   |PC1                 |F-test |4.67e-04 |6.247    |         |        |0.0948 |
|centre                           |Brazil             |PC1                 |t-test |2.72e-04 |-2.467   |-3.9476  |-0.9872 |0.0727 |
|centre                           |Ecuador            |PC1                 |t-test |4.39e-04 |2.416    |0.9131   |3.9187  |0.0680 |
|age                              |                   |PC1                 |F-test |2.37e-03 |9.502    |         |        |0.0499 |
|sputum_phenotype1_first          |Mixed granulocytic |PC1                 |t-test |4.18e-03 |3.491    |0.7852   |6.1973  |0.0459 |
|dateofsample1                    |07/06/2018         |PC1                 |t-test |5.21e-03 |-10.497  |-18.8464 |-2.1477 |0.0612 |
|dateofsample1                    |12/05/2018         |PC1                 |t-test |3.93e-04 |13.822   |5.2397   |22.4033 |0.0960 |
|dateofsample1                    |14/07/2018         |PC1                 |t-test |3.17e-03 |7.857    |1.9527   |13.7611 |0.0681 |
|dateofsample1                    |14/11/2018         |PC1                 |t-test |5.84e-03 |-6.201   |-11.1982 |-1.2032 |0.0592 |
|dateofsample1                    |16/07/2019         |PC1                 |t-test |5.10e-04 |-13.537  |-22.1187 |-4.9550 |0.0924 |
|dateofsample1                    |22/08/2016         |PC1                 |t-test |1.67e-03 |-12.192  |-20.7743 |-3.6107 |0.0763 |
|dateofdcc1                       |                   |PC1                 |F-test |3.53e-03 |1.783    |         |        |0.6057 |
|dateofdcc1                       |08/02/2017         |PC1                 |t-test |2.19e-03 |-12.213  |-21.0677 |-3.3575 |0.0542 |
|dateofdcc1                       |08/10/2019         |PC1                 |t-test |3.16e-03 |-5.797   |-10.1599 |-1.4341 |0.0507 |
|dateofdcc1                       |11/12/2019         |PC1                 |t-test |7.86e-05 |6.489    |2.8774   |10.1009 |0.0884 |
|dateofdcc1                       |16/12/2019         |PC1                 |t-test |5.11e-03 |10.913   |2.2369   |19.5900 |0.0457 |
|dateofdcc1                       |18/12/2019         |PC1                 |t-test |4.21e-03 |8.077    |1.7991   |14.3547 |0.0474 |
|dateofdcc1                       |19/02/2019         |PC1                 |t-test |5.13e-03 |7.737    |1.5848   |13.8892 |0.0457 |
|dateofdcc1                       |31/01/2019         |PC1                 |t-test |5.64e-04 |13.801   |4.9463   |22.6565 |0.0681 |
|observer1                        |                   |PC1                 |F-test |4.69e-03 |3.897    |         |        |0.0831 |
|observer1                        |Givaneide          |PC1                 |t-test |3.20e-04 |-2.461   |-3.9536  |-0.9681 |0.0736 |
|observer1                        |Jeroen Burmanje    |PC1                 |t-test |1.75e-03 |2.005    |0.6229   |3.3868  |0.0555 |
|sputum_phenotype1_1              |Mixed granulocytic |PC1                 |t-test |4.30e-03 |3.491    |0.7763   |6.2050  |0.0459 |
|sputum_phenotype_neutro1         |Mixed granulocytic |PC1                 |t-test |4.47e-03 |3.217    |0.7056   |5.7285  |0.0455 |
|dateofsample2                    |12/06/2018         |PC1                 |t-test |4.74e-04 |13.010   |5.0668   |20.9540 |0.2549 |
|dateofsample2                    |15/06/2017         |PC1                 |t-test |4.77e-04 |-13.004  |-20.9472 |-5.0600 |0.2547 |
|dateofsample2                    |26/02/2019         |PC1                 |t-test |1.49e-03 |-11.670  |-19.6131 |-3.7259 |0.2158 |
|dateofsample2                    |29/08/2018         |PC1                 |t-test |3.91e-04 |-11.492  |-18.3841 |-4.6001 |0.2668 |
|dateofdcc2                       |17/12/2019         |PC1                 |t-test |7.77e-03 |-6.765   |-12.3716 |-1.1589 |0.1385 |
|dateofdcc2                       |18/12/2019         |PC1                 |t-test |8.62e-03 |4.791    |0.7734   |8.8095  |0.1326 |
|dateofdcc2                       |20/06/2018         |PC1                 |t-test |7.83e-04 |-13.014  |-21.3823 |-4.6455 |0.2075 |
|dateofdcc2                       |27/05/2020         |PC1                 |t-test |8.68e-03 |-4.823   |-8.8736  |-0.7720 |0.1349 |
|observer2                        |Givaneide          |PC1                 |t-test |2.15e-03 |-3.411   |-5.7940  |-1.0272 |0.1764 |
|sputum_phenotype_epigen          |Mixed granulocytic |PC1                 |t-test |4.35e-03 |3.485    |0.7715   |6.1993  |0.0458 |
|sputum_phenotype_neutro_epigen   |Mixed granulocytic |PC1                 |t-test |4.53e-03 |3.212    |0.7007   |5.7227  |0.0454 |
|Array                            |                   |PC1                 |F-test |1.43e-11 |11.083   |         |        |0.3072 |
|Array                            |R01C01             |PC1                 |t-test |1.65e-10 |-5.605   |-7.4578  |-3.7529 |0.2055 |
|Array                            |R02C01             |PC1                 |t-test |3.76e-03 |-2.584   |-4.5574  |-0.6098 |0.0470 |
|Array                            |R05C01             |PC1                 |t-test |7.34e-03 |2.350    |0.4068   |4.2926  |0.0404 |
|Array                            |R07C01             |PC1                 |t-test |5.30e-04 |3.109    |1.1339   |5.0845  |0.0658 |
|Slide                            |                   |PC1                 |F-test |1.00e-13 |6.402    |         |        |0.4930 |
|Slide                            |205809360103       |PC1                 |t-test |3.19e-05 |-5.817   |-8.8826  |-2.7506 |0.0944 |
|Slide                            |205809360172       |PC1                 |t-test |5.72e-03 |3.918    |0.7656   |7.0698  |0.0428 |
|Slide                            |205809360174       |PC1                 |t-test |2.39e-03 |-12.189  |-21.1072 |-3.2718 |0.0512 |
|Slide                            |205809370061       |PC1                 |t-test |7.03e-08 |7.763    |4.6582   |10.8684 |0.1518 |
|Slide                            |205809370069       |PC1                 |t-test |6.38e-03 |-3.938   |-7.1495  |-0.7268 |0.0415 |
|Slide                            |205809380033       |PC1                 |t-test |3.41e-03 |4.908    |1.1847   |8.6305  |0.0477 |
|Slide                            |205809380116       |PC1                 |t-test |7.44e-04 |4.756    |1.6376   |7.8747  |0.0631 |
|Slide                            |205809380161       |PC1                 |t-test |3.28e-03 |-4.162   |-7.3046  |-1.0185 |0.0483 |
|sentrix_row                      |                   |PC1                 |F-test |1.43e-11 |11.083   |         |        |0.3072 |
|sentrix_row                      |01                 |PC1                 |t-test |1.65e-10 |-5.605   |-7.4578  |-3.7529 |0.2055 |
|sentrix_row                      |02                 |PC1                 |t-test |3.76e-03 |-2.584   |-4.5574  |-0.6098 |0.0470 |
|sentrix_row                      |05                 |PC1                 |t-test |7.34e-03 |2.350    |0.4068   |4.2926  |0.0404 |
|sentrix_row                      |07                 |PC1                 |t-test |5.30e-04 |3.109    |1.1339   |5.0845  |0.0658 |
|centre                           |                   |PC2                 |F-test |6.16e-16 |30.410   |         |        |0.3376 |
|centre                           |Brazil             |PC2                 |t-test |3.02e-04 |1.647    |0.6506   |2.6437  |0.0698 |
|centre                           |Ecuador            |PC2                 |t-test |2.56e-12 |-3.040   |-3.9422  |-2.1380 |0.2377 |
|centre                           |New Zealand        |PC2                 |t-test |8.22e-07 |2.344    |1.3191   |3.3696  |0.1260 |
|age                              |                   |PC2                 |F-test |2.28e-04 |14.147   |         |        |0.0725 |
|sptpos                           |                   |PC2                 |F-test |1.36e-03 |10.590   |         |        |0.0556 |
|sptpos                           |Atopic             |PC2                 |t-test |1.36e-03 |1.290    |0.4253   |2.1550  |0.0556 |
|sptpos                           |Non-atopic         |PC2                 |t-test |1.36e-03 |-1.290   |-2.1651  |-0.4152 |0.0556 |
|phadresult                       |                   |PC2                 |F-test |2.09e-03 |9.762    |         |        |0.0531 |
|dateofdcc1                       |                   |PC2                 |F-test |1.93e-07 |3.011    |         |        |0.7218 |
|dateofdcc1                       |29/08/2019         |PC2                 |t-test |5.55e-03 |-5.322   |-9.5944  |-1.0492 |0.0434 |
|observer1                        |                   |PC2                 |F-test |2.56e-11 |16.265   |         |        |0.2744 |
|observer1                        |Givaneide          |PC2                 |t-test |6.29e-04 |1.568    |0.5642   |2.5724  |0.0648 |
|observer1                        |Jeroen             |PC2                 |t-test |2.07e-05 |2.361    |1.1518   |3.5693  |0.0986 |
|observer1                        |Jeroen Burmanje    |PC2                 |t-test |1.35e-12 |-2.705   |-3.4811  |-1.9286 |0.2502 |
|bronchialepithelialcells1        |                   |PC2                 |F-test |8.78e-03 |7.020    |         |        |0.0375 |
|squamouscells1                   |                   |PC2                 |F-test |5.33e-03 |7.958    |         |        |0.0423 |
|goodquality_sputum1              |                   |PC2                 |F-test |9.59e-03 |6.856    |         |        |0.0367 |
|goodquality_sputum1              |Good quality       |PC2                 |t-test |9.59e-03 |-2.083   |-3.7285  |-0.4380 |0.0367 |
|goodquality_sputum1              |Not good quality   |PC2                 |t-test |9.59e-03 |2.083    |0.2941   |3.8724  |0.0367 |
|dateofdcc2                       |                   |PC2                 |F-test |1.40e-03 |3.422    |         |        |0.7871 |
|dateofdcc2                       |14/01/2020         |PC2                 |t-test |3.54e-03 |-3.327   |-5.8223  |-0.8308 |0.1550 |
|observer2                        |                   |PC2                 |F-test |1.17e-04 |7.262    |         |        |0.3770 |
|observer2                        |Jeroen Burmanje    |PC2                 |t-test |1.51e-05 |-2.563   |-3.7721  |-1.3531 |0.3097 |
|bronchialepithelialcells_epigen  |                   |PC2                 |F-test |6.39e-03 |7.615    |         |        |0.0406 |
|goodquality_epigen               |                   |PC2                 |F-test |3.37e-03 |8.829    |         |        |0.0465 |
|goodquality_epigen               |Good quality       |PC2                 |t-test |3.37e-03 |-2.271   |-3.8535  |-0.6880 |0.0465 |
|goodquality_epigen               |Not good quality   |PC2                 |t-test |3.37e-03 |2.271    |0.5527   |3.9889  |0.0465 |
|Array                            |R01C01             |PC2                 |t-test |4.00e-03 |-1.697   |-3.0023  |-0.3918 |0.0449 |
|Slide                            |                   |PC2                 |F-test |7.43e-35 |18.826   |         |        |0.7409 |
|Slide                            |205809360147       |PC2                 |t-test |2.12e-03 |3.184    |0.8854   |5.4830  |0.0510 |
|Slide                            |205809360162       |PC2                 |t-test |4.91e-07 |5.100    |2.8999   |7.2999  |0.1308 |
|Slide                            |205809360173       |PC2                 |t-test |1.54e-03 |-3.076   |-5.2290  |-0.9240 |0.0541 |
|Slide                            |205809360176       |PC2                 |t-test |2.81e-03 |2.906    |0.7468   |5.0650  |0.0483 |
|Slide                            |205809370121       |PC2                 |t-test |3.99e-08 |-5.189   |-7.2245  |-3.1529 |0.1538 |
|Slide                            |205809370170       |PC2                 |t-test |2.13e-03 |-2.985   |-5.1414  |-0.8293 |0.0509 |
|Slide                            |205809370173       |PC2                 |t-test |6.74e-04 |-3.783   |-6.2451  |-1.3210 |0.0620 |
|sentrix_row                      |01                 |PC2                 |t-test |4.00e-03 |-1.697   |-3.0023  |-0.3918 |0.0449 |
|Study_id                         |190                |PC3                 |t-test |2.08e-03 |6.850    |1.9073   |11.7921 |0.0528 |
|Study_id                         |WASP103            |PC3                 |t-test |8.95e-03 |-5.698   |-10.5587 |-0.8382 |0.0386 |
|Study_id                         |WASP106            |PC3                 |t-test |3.03e-03 |-6.590   |-11.5323 |-1.6475 |0.0491 |
|Study_id                         |WASP107            |PC3                 |t-test |4.94e-03 |-6.240   |-11.1826 |-1.2978 |0.0443 |
|Study_id                         |WASP108            |PC3                 |t-test |7.38e-03 |-5.838   |-10.6932 |-0.9823 |0.0405 |
|Study_id                         |WASP109            |PC3                 |t-test |3.36e-03 |-6.519   |-11.4610 |-1.5762 |0.0481 |
|Study_id                         |WASP110            |PC3                 |t-test |4.90e-03 |-6.246   |-11.1887 |-1.3039 |0.0443 |
|Study_id                         |WASP111            |PC3                 |t-test |4.02e-03 |-6.390   |-11.3321 |-1.4473 |0.0463 |
|uniquekey                        |                   |PC3                 |F-test |4.75e-05 |17.377   |         |        |0.0876 |
|studysubjectid                   |AQ9557             |PC3                 |t-test |2.08e-03 |6.850    |1.9073   |11.7921 |0.0528 |
|studysubjectid                   |MB1372             |PC3                 |t-test |4.02e-03 |-6.390   |-11.3321 |-1.4473 |0.0463 |
|studysubjectid                   |MB1590             |PC3                 |t-test |4.90e-03 |-6.246   |-11.1887 |-1.3039 |0.0443 |
|studysubjectid                   |MB2025             |PC3                 |t-test |8.95e-03 |-5.698   |-10.5587 |-0.8382 |0.0386 |
|studysubjectid                   |NG1010             |PC3                 |t-test |7.38e-03 |-5.838   |-10.6932 |-0.9823 |0.0405 |
|studysubjectid                   |NG1052             |PC3                 |t-test |3.03e-03 |-6.590   |-11.5323 |-1.6475 |0.0491 |
|studysubjectid                   |NG1075             |PC3                 |t-test |4.94e-03 |-6.240   |-11.1826 |-1.2978 |0.0443 |
|studysubjectid                   |NG464              |PC3                 |t-test |3.36e-03 |-6.519   |-11.4610 |-1.5762 |0.0481 |
|centre                           |                   |PC3                 |F-test |2.21e-21 |44.081   |         |        |0.4249 |
|centre                           |Brazil             |PC3                 |t-test |1.77e-08 |-2.028   |-2.7930  |-1.2630 |0.1671 |
|centre                           |Ecuador            |PC3                 |t-test |3.98e-05 |1.546    |0.7287   |2.3637  |0.0922 |
|centre                           |New Zealand        |PC3                 |t-test |5.92e-10 |-2.557   |-3.4296  |-1.6852 |0.1933 |
|centre                           |Uganda             |PC3                 |t-test |9.21e-10 |2.138    |1.4033   |2.8724  |0.1933 |
|sptpos                           |                   |PC3                 |F-test |4.77e-03 |8.167    |         |        |0.0434 |
|sptpos                           |Atopic             |PC3                 |t-test |1.21e-03 |-1.144   |-1.9031  |-0.3859 |0.0576 |
|sptpos                           |Non-atopic         |PC3                 |t-test |7.85e-03 |0.933    |0.1676   |1.6977  |0.0395 |
|sputum_phenotype1_first          |                   |PC3                 |F-test |1.93e-04 |6.931    |         |        |0.1041 |
|sputum_phenotype1_first          |Eosinophilic       |PC3                 |t-test |1.60e-03 |-1.129   |-1.9081  |-0.3492 |0.0545 |
|sputum_phenotype1_first          |Neutrophilic       |PC3                 |t-test |2.13e-04 |1.618    |0.6608   |2.5759  |0.0752 |
|dateofsample1                    |                   |PC3                 |F-test |3.42e-03 |2.825    |         |        |0.9322 |
|dateofsample1                    |16/09/2018         |PC3                 |t-test |8.26e-04 |7.452    |2.5346   |12.3702 |0.0872 |
|dateofsample1                    |18/12/2017         |PC3                 |t-test |6.77e-03 |-5.987   |-10.9050 |-1.0694 |0.0581 |
|dateofsample1                    |24/07/2019         |PC3                 |t-test |8.79e-03 |-5.787   |-10.7048 |-0.8693 |0.0545 |
|dateofsample1                    |27/04/2016         |PC3                 |t-test |7.44e-03 |-5.916   |-10.8337 |-0.9981 |0.0568 |
|dateofdcc1                       |                   |PC3                 |F-test |1.58e-11 |4.310    |         |        |0.7879 |
|dateofdcc1                       |05/07/2020         |PC3                 |t-test |3.72e-03 |-2.299   |-4.0582  |-0.5395 |0.0493 |
|dateofdcc1                       |05/12/2018         |PC3                 |t-test |5.69e-03 |-6.196   |-11.1854 |-1.2074 |0.0446 |
|dateofdcc1                       |08/10/2019         |PC3                 |t-test |1.73e-04 |4.192    |1.7330   |6.6514  |0.0808 |
|dateofdcc1                       |11/05/2020         |PC3                 |t-test |7.64e-04 |-5.214   |-8.6441  |-1.7847 |0.0658 |
|dateofdcc1                       |12/05/2020         |PC3                 |t-test |1.57e-03 |-4.907   |-8.3503  |-1.4634 |0.0582 |
|dateofdcc1                       |14/03/2017         |PC3                 |t-test |8.40e-03 |-5.795   |-10.6961 |-0.8941 |0.0409 |
|dateofdcc1                       |17/08/2016         |PC3                 |t-test |3.89e-03 |-6.475   |-11.4638 |-1.4858 |0.0485 |
|dateofdcc1                       |18/06/2018         |PC3                 |t-test |3.53e-03 |-6.546   |-11.5351 |-1.5571 |0.0496 |
|dateofdcc1                       |28/11/2019         |PC3                 |t-test |2.99e-04 |3.975    |1.5495   |6.4013  |0.0755 |
|dateofdcc1                       |29/01/2020         |PC3                 |t-test |5.57e-03 |-4.405   |-7.9422  |-0.8677 |0.0448 |
|observer1                        |                   |PC3                 |F-test |2.03e-20 |33.009   |         |        |0.4343 |
|observer1                        |Givaneide          |PC3                 |t-test |3.74e-08 |-2.017   |-2.7962  |-1.2380 |0.1654 |
|observer1                        |Hajar              |PC3                 |t-test |8.95e-06 |-3.044   |-4.5390  |-1.5486 |0.1092 |
|observer1                        |Jeroen             |PC3                 |t-test |1.25e-05 |-2.056   |-3.0796  |-1.0321 |0.1064 |
|observer1                        |Jeroen Burmanje    |PC3                 |t-test |1.61e-20 |2.901    |2.3022   |3.4996  |0.3987 |
|neutrophilscount1                |                   |PC3                 |F-test |5.02e-04 |12.561   |         |        |0.0652 |
|eosinophilscount1                |                   |PC3                 |F-test |8.18e-04 |11.589   |         |        |0.0605 |
|squamouscellscount1              |                   |PC3                 |F-test |7.16e-04 |11.852   |         |        |0.0618 |
|neutrophils1                     |                   |PC3                 |F-test |9.70e-05 |15.900   |         |        |0.0812 |
|eosinophils1                     |                   |PC3                 |F-test |9.93e-04 |11.205   |         |        |0.0586 |
|squamouscells1                   |                   |PC3                 |F-test |2.77e-04 |13.755   |         |        |0.0710 |
|sputum_phenotype1_1              |                   |PC3                 |F-test |1.86e-04 |6.963    |         |        |0.1050 |
|sputum_phenotype1_1              |Eosinophilic       |PC3                 |t-test |1.49e-03 |-1.144   |-1.9294  |-0.3596 |0.0556 |
|sputum_phenotype1_1              |Neutrophilic       |PC3                 |t-test |2.17e-04 |1.621    |0.6607   |2.5822  |0.0754 |
|sputum_phenotype_eos1            |                   |PC3                 |F-test |6.39e-05 |7.799    |         |        |0.1162 |
|sputum_phenotype_eos1            |Eosinophilic       |PC3                 |t-test |8.11e-05 |-1.377   |-2.1296  |-0.6247 |0.0842 |
|sputum_phenotype_eos1            |Neutrophilic       |PC3                 |t-test |1.49e-03 |1.603    |0.4889   |2.7161  |0.0562 |
|sputum_phenotype_neutro1         |                   |PC3                 |F-test |2.79e-03 |4.871    |         |        |0.0759 |
|sputum_phenotype_neutro1         |Eosinophilic       |PC3                 |t-test |1.54e-03 |-1.148   |-1.9378  |-0.3572 |0.0552 |
|sputum_phenotype_neutro1         |Neutrophilic       |PC3                 |t-test |7.46e-03 |1.100    |0.1924   |2.0067  |0.0402 |
|dateofsample2                    |04/07/2017         |PC3                 |t-test |7.22e-03 |-5.151   |-9.3700  |-0.9329 |0.1669 |
|dateofsample2                    |16/08/2019         |PC3                 |t-test |8.19e-03 |-5.471   |-10.0304 |-0.9107 |0.1585 |
|dateofsample2                    |19/10/2018         |PC3                 |t-test |8.26e-03 |-5.464   |-10.0243 |-0.9046 |0.1582 |
|dateofsample2                    |20/06/2018         |PC3                 |t-test |5.18e-03 |-5.814   |-10.3740 |-1.2543 |0.1754 |
|dateofsample2                    |27/10/2017         |PC3                 |t-test |5.70e-03 |-5.743   |-10.3027 |-1.1830 |0.1719 |
|dateofdcc2                       |                   |PC3                 |F-test |1.08e-03 |3.543    |         |        |0.7928 |
|dateofdcc2                       |03/11/2017         |PC3                 |t-test |8.09e-03 |-5.424   |-9.9469  |-0.9020 |0.1400 |
|dateofdcc2                       |14/05/2020         |PC3                 |t-test |8.36e-03 |-5.755   |-10.5769 |-0.9340 |0.1362 |
|dateofdcc2                       |22/06/2018         |PC3                 |t-test |5.39e-03 |-6.099   |-10.9205 |-1.2776 |0.1504 |
|dateofdcc2                       |25/05/2018         |PC3                 |t-test |5.91e-03 |-6.028   |-10.8492 |-1.2063 |0.1474 |
|observer2                        |                   |PC3                 |F-test |6.41e-06 |9.893    |         |        |0.4519 |
|observer2                        |Givaneide          |PC3                 |t-test |1.75e-03 |-1.853   |-3.1169  |-0.5882 |0.1898 |
|observer2                        |Hajar              |PC3                 |t-test |9.55e-05 |-3.461   |-5.3272  |-1.5946 |0.2647 |
|observer2                        |Jeroen Burmanje    |PC3                 |t-test |9.29e-06 |2.448    |1.3358   |3.5606  |0.3446 |
|neutrophilscount2                |                   |PC3                 |F-test |4.51e-03 |8.817    |         |        |0.1450 |
|monocytesmacrophagescount2       |                   |PC3                 |F-test |9.05e-04 |12.395   |         |        |0.1925 |
|neutrophils2                     |                   |PC3                 |F-test |2.52e-03 |10.102   |         |        |0.1653 |
|monocytesmacrophages2            |                   |PC3                 |F-test |4.23e-03 |8.969    |         |        |0.1496 |
|sputum_phenotype1_2              |                   |PC3                 |F-test |6.14e-03 |4.649    |         |        |0.2216 |
|sputum_phenotype1_2              |Mixed granulocytic |PC3                 |t-test |5.03e-04 |5.020    |1.9256   |8.1143  |0.2291 |
|sputum_phenotype_eos2            |Mixed granulocytic |PC3                 |t-test |1.44e-03 |3.833    |1.2276   |6.4387  |0.1961 |
|sputum_phenotype_neutro2         |                   |PC3                 |F-test |5.16e-03 |4.810    |         |        |0.2275 |
|sputum_phenotype_neutro2         |Mixed granulocytic |PC3                 |t-test |5.03e-04 |5.020    |1.9256   |8.1143  |0.2291 |
|neutrophilscount_epigen          |                   |PC3                 |F-test |1.48e-03 |10.425   |         |        |0.0545 |
|monocytesmacrophagescount_epigen |                   |PC3                 |F-test |9.43e-03 |6.885    |         |        |0.0366 |
|eosinophilscount_epigen          |                   |PC3                 |F-test |2.40e-03 |9.482    |         |        |0.0498 |
|neutrophils_epigen               |                   |PC3                 |F-test |2.60e-04 |13.881   |         |        |0.0716 |
|eosinophils_epigen               |                   |PC3                 |F-test |3.19e-03 |8.935    |         |        |0.0473 |
|squamouscells_epigen             |                   |PC3                 |F-test |9.36e-03 |6.900    |         |        |0.0367 |
|sputum_phenotype_epigen          |                   |PC3                 |F-test |5.41e-05 |7.930    |         |        |0.1179 |
|sputum_phenotype_epigen          |Eosinophilic       |PC3                 |t-test |4.18e-04 |-1.286   |-2.0774  |-0.4944 |0.0677 |
|sputum_phenotype_epigen          |Neutrophilic       |PC3                 |t-test |1.99e-04 |1.629    |0.6698   |2.5886  |0.0762 |
|sputum_phenotype_eos_epigen      |                   |PC3                 |F-test |1.78e-05 |8.809    |         |        |0.1293 |
|sputum_phenotype_eos_epigen      |Eosinophilic       |PC3                 |t-test |3.49e-05 |-1.462   |-2.2210  |-0.7033 |0.0920 |
|sputum_phenotype_eos_epigen      |Neutrophilic       |PC3                 |t-test |1.40e-03 |1.610    |0.4976   |2.7220  |0.0568 |
|sputum_phenotype_neutro_epigen   |                   |PC3                 |F-test |7.48e-04 |5.885    |         |        |0.0902 |
|sputum_phenotype_neutro_epigen   |Eosinophilic       |PC3                 |t-test |4.21e-04 |-1.293   |-2.0898  |-0.4960 |0.0677 |
|sputum_phenotype_neutro_epigen   |Neutrophilic       |PC3                 |t-test |7.20e-03 |1.093    |0.1955   |1.9910  |0.0405 |
|Slide                            |                   |PC3                 |F-test |1.17e-50 |34.383   |         |        |0.8393 |
|Slide                            |205809360127       |PC3                 |t-test |2.22e-04 |2.877    |1.1597   |4.5938  |0.0756 |
|Slide                            |205809360133       |PC3                 |t-test |3.88e-05 |-3.190   |-4.8910  |-1.4893 |0.0930 |
|Slide                            |205809360134       |PC3                 |t-test |9.95e-04 |-2.744   |-4.5898  |-0.8991 |0.0606 |
|Slide                            |205809360152       |PC3                 |t-test |1.19e-07 |-4.042   |-5.6896  |-2.3952 |0.1492 |
|Slide                            |205809360168       |PC3                 |t-test |7.45e-14 |-6.035   |-7.7087  |-4.3615 |0.2690 |
|Slide                            |205809360176       |PC3                 |t-test |1.96e-06 |3.719    |2.0183   |5.4191  |0.1217 |
|Slide                            |205809370069       |PC3                 |t-test |8.33e-03 |2.075    |0.3248   |3.8256  |0.0393 |
|Slide                            |205809370102       |PC3                 |t-test |8.61e-03 |-2.203   |-4.0690  |-0.3361 |0.0390 |
|Slide                            |205809380108       |PC3                 |t-test |3.56e-03 |2.690    |0.6393   |4.7403  |0.0475 |
|Study_id                         |173                |PC4                 |t-test |5.60e-03 |-4.712   |-8.4989  |-0.9243 |0.0426 |
|Study_id                         |WASP104            |PC4                 |t-test |4.78e-04 |5.979    |2.1916   |9.7662  |0.0668 |
|Study_id                         |WASP127            |PC4                 |t-test |6.76e-03 |-4.604   |-8.3912  |-0.8166 |0.0407 |
|Study_id                         |WASP75             |PC4                 |t-test |7.66e-03 |4.532    |0.7445   |8.3191  |0.0395 |
|Study_id                         |WASP82             |PC4                 |t-test |7.07e-03 |-4.578   |-8.3657  |-0.7911 |0.0403 |
|Sample_Well                      |B09                |PC4                 |t-test |5.15e-04 |-4.158   |-6.8064  |-1.5090 |0.0661 |
|studysubjectid                   |AQ9522             |PC4                 |t-test |5.60e-03 |-4.712   |-8.4989  |-0.9243 |0.0426 |
|studysubjectid                   |BR5962             |PC4                 |t-test |6.76e-03 |-4.604   |-8.3912  |-0.8166 |0.0407 |
|studysubjectid                   |MB1291             |PC4                 |t-test |7.07e-03 |-4.578   |-8.3657  |-0.7911 |0.0403 |
|studysubjectid                   |MB1580             |PC4                 |t-test |7.66e-03 |4.532    |0.7445   |8.3191  |0.0395 |
|studysubjectid                   |NG559              |PC4                 |t-test |4.78e-04 |5.979    |2.1916   |9.7662  |0.0668 |
|centre                           |                   |PC4                 |F-test |7.31e-03 |4.133    |         |        |0.0648 |
|centre                           |Brazil             |PC4                 |t-test |3.99e-04 |-1.019   |-1.6486  |-0.3898 |0.0686 |
|dateofsample1                    |02/09/2019         |PC4                 |t-test |8.08e-03 |-4.513   |-8.3053  |-0.7207 |0.0552 |
|dateofsample1                    |11/05/2016         |PC4                 |t-test |4.49e-04 |6.044    |2.2520   |9.8367  |0.0949 |
|dateofsample1                    |26/08/2019         |PC4                 |t-test |7.00e-03 |4.597    |0.8048   |8.3895  |0.0572 |
|dateofsample1                    |28/09/2018         |PC4                 |t-test |7.74e-03 |-4.538   |-8.3308  |-0.7462 |0.0558 |
|dateofdcc1                       |06/11/2019         |PC4                 |t-test |4.63e-03 |2.359    |0.5065   |4.2107  |0.0465 |
|dateofdcc1                       |07/04/2017         |PC4                 |t-test |9.92e-04 |3.973    |1.2997   |6.6456  |0.0620 |
|dateofdcc1                       |08/10/2019         |PC4                 |t-test |1.12e-03 |-2.703   |-4.5410  |-0.8652 |0.0611 |
|observer1                        |                   |PC4                 |F-test |3.01e-03 |4.170    |         |        |0.0884 |
|observer1                        |Givaneide          |PC4                 |t-test |4.91e-04 |-1.000   |-1.6266  |-0.3727 |0.0688 |
|observer1                        |Hajar              |PC4                 |t-test |6.71e-03 |1.382    |0.2494   |2.5150  |0.0422 |
|goodquality_sputum1              |                   |PC4                 |F-test |7.74e-03 |7.254    |         |        |0.0387 |
|goodquality_sputum1              |Not good quality   |PC4                 |t-test |6.30e-03 |1.407    |0.2624   |2.5508  |0.0416 |
|goodquality_epigen               |                   |PC4                 |F-test |7.76e-03 |7.248    |         |        |0.0385 |
|goodquality_epigen               |Not good quality   |PC4                 |t-test |6.40e-03 |1.349    |0.2498   |2.4489  |0.0412 |
|Array                            |R08C01             |PC4                 |t-test |3.25e-03 |1.114    |0.2765   |1.9514  |0.0482 |
|Slide                            |                   |PC4                 |F-test |1.31e-07 |3.872    |         |        |0.3703 |
|Slide                            |205809360134       |PC4                 |t-test |2.57e-04 |-2.369   |-3.7983  |-0.9389 |0.0729 |
|Slide                            |205809360168       |PC4                 |t-test |6.87e-04 |2.098    |0.7313   |3.4646  |0.0632 |
|Slide                            |205809360173       |PC4                 |t-test |1.98e-03 |1.857    |0.5255   |3.1882  |0.0530 |
|Slide                            |205809360176       |PC4                 |t-test |2.68e-03 |-1.804   |-3.1372  |-0.4703 |0.0500 |
|sentrix_row                      |08                 |PC4                 |t-test |3.25e-03 |1.114    |0.2765   |1.9514  |0.0482 |
|Study_id                         |190                |PC5                 |t-test |6.31e-03 |-1.760   |-3.1962  |-0.3248 |0.0436 |
|Study_id                         |70                 |PC5                 |t-test |5.17e-04 |2.253    |0.8177   |3.6891  |0.0694 |
|Study_id                         |UGA_16             |PC5                 |t-test |1.07e-03 |-2.119   |-3.5546  |-0.6832 |0.0619 |
|Study_id                         |UGA_39             |PC5                 |t-test |2.09e-03 |1.989    |0.5535   |3.4249  |0.0549 |
|Study_id                         |UGA_41             |PC5                 |t-test |5.89e-04 |2.230    |0.7944   |3.6657  |0.0681 |
|Study_id                         |UGA_44             |PC5                 |t-test |1.18e-05 |2.875    |1.4391   |4.3104  |0.1083 |
|Study_id                         |UGA_51             |PC5                 |t-test |1.52e-03 |2.052    |0.6167   |3.4881  |0.0583 |
|Study_id                         |UGA_67             |PC5                 |t-test |5.41e-04 |2.245    |0.8098   |3.6811  |0.0690 |
|Study_id                         |UGA_79             |PC5                 |t-test |1.69e-05 |2.820    |1.3843   |4.2557  |0.1046 |
|Study_id                         |WASP72             |PC5                 |t-test |1.20e-03 |-2.098   |-3.5334  |-0.6620 |0.0607 |
|Study_id                         |WASP80             |PC5                 |t-test |4.61e-03 |-1.828   |-3.2634  |-0.3920 |0.0468 |
|Study_id                         |WASP81             |PC5                 |t-test |1.20e-03 |2.097    |0.6615   |3.5329  |0.0607 |
|Study_id                         |WASP82             |PC5                 |t-test |9.15e-03 |1.650    |0.2387   |3.0607  |0.0400 |
|Study_id                         |WASP84             |PC5                 |t-test |2.59e-05 |2.754    |1.3185   |4.1899  |0.1003 |
|Study_id                         |WASP85             |PC5                 |t-test |1.76e-05 |2.814    |1.3784   |4.2497  |0.1042 |
|Sample_Well                      |                   |PC5                 |F-test |6.46e-04 |2.017    |         |        |0.7245 |
|Sample_Well                      |A09                |PC5                 |t-test |1.07e-05 |2.043    |1.0283   |3.0581  |0.1087 |
|Sample_Well                      |B08                |PC5                 |t-test |3.82e-04 |-1.627   |-2.6396  |-0.6153 |0.0726 |
|Sample_Well                      |B09                |PC5                 |t-test |3.01e-04 |1.607    |0.6255   |2.5892  |0.0755 |
|Sample_Well                      |C09                |PC5                 |t-test |1.19e-07 |2.492    |1.4762   |3.5080  |0.1533 |
|Sample_Well                      |D09                |PC5                 |t-test |2.24e-09 |2.844    |1.8295   |3.8593  |0.1912 |
|Sample_Well                      |F09                |PC5                 |t-test |3.69e-04 |1.628    |0.6182   |2.6383  |0.0729 |
|Sample_Well                      |G09                |PC5                 |t-test |1.26e-03 |1.488    |0.4648   |2.5103  |0.0602 |
|Sample_Well                      |H09                |PC5                 |t-test |6.56e-04 |1.600    |0.5610   |2.6393  |0.0670 |
|studysubjectid                   |A0570              |PC5                 |t-test |1.07e-03 |-2.119   |-3.5546  |-0.6832 |0.0619 |
|studysubjectid                   |A0616              |PC5                 |t-test |1.69e-05 |2.820    |1.3843   |4.2557  |0.1046 |
|studysubjectid                   |A0629              |PC5                 |t-test |5.89e-04 |2.230    |0.7944   |3.6657  |0.0681 |
|studysubjectid                   |A0631              |PC5                 |t-test |2.09e-03 |1.989    |0.5535   |3.4249  |0.0549 |
|studysubjectid                   |A0641              |PC5                 |t-test |1.18e-05 |2.875    |1.4391   |4.3104  |0.1083 |
|studysubjectid                   |A0646              |PC5                 |t-test |1.52e-03 |2.052    |0.6167   |3.4881  |0.0583 |
|studysubjectid                   |A0660              |PC5                 |t-test |5.41e-04 |2.245    |0.8098   |3.6811  |0.0690 |
|studysubjectid                   |AQ9557             |PC5                 |t-test |6.31e-03 |-1.760   |-3.1962  |-0.3248 |0.0436 |
|studysubjectid                   |AQ9580             |PC5                 |t-test |5.17e-04 |2.253    |0.8177   |3.6891  |0.0694 |
|studysubjectid                   |MB1291             |PC5                 |t-test |9.15e-03 |1.650    |0.2387   |3.0607  |0.0400 |
|studysubjectid                   |MB1303             |PC5                 |t-test |4.61e-03 |-1.828   |-3.2634  |-0.3920 |0.0468 |
|studysubjectid                   |MB1436             |PC5                 |t-test |1.20e-03 |2.097    |0.6615   |3.5329  |0.0607 |
|studysubjectid                   |MB1977             |PC5                 |t-test |2.59e-05 |2.754    |1.3185   |4.1899  |0.1003 |
|studysubjectid                   |MB2045             |PC5                 |t-test |1.20e-03 |-2.098   |-3.5334  |-0.6620 |0.0607 |
|studysubjectid                   |MB2113             |PC5                 |t-test |1.76e-05 |2.814    |1.3784   |4.2497  |0.1042 |
|dateofsample1                    |01/07/2019         |PC5                 |t-test |5.19e-06 |2.828    |1.4862   |4.1705  |0.1571 |
|dateofsample1                    |02/09/2019         |PC5                 |t-test |4.49e-03 |1.668    |0.3644   |2.9712  |0.0648 |
|dateofsample1                    |16/07/2019         |PC5                 |t-test |5.30e-04 |2.112    |0.7694   |3.4536  |0.0941 |
|dateofsample1                    |16/09/2018         |PC5                 |t-test |3.88e-03 |-1.746   |-3.0883  |-0.4041 |0.0663 |
|dateofsample1                    |18/07/2019         |PC5                 |t-test |2.74e-03 |-1.813   |-3.1555  |-0.4713 |0.0712 |
|dateofsample1                    |24/05/2019         |PC5                 |t-test |6.23e-04 |-2.083   |-3.4255  |-0.7413 |0.0918 |
|dateofsample1                    |24/09/2018         |PC5                 |t-test |2.74e-03 |1.022    |0.2663   |1.7772  |0.0718 |
|dateofsample1                    |28/05/2019         |PC5                 |t-test |7.89e-06 |2.768    |1.4264   |4.1106  |0.1515 |
|dateofsample1                    |28/09/2018         |PC5                 |t-test |9.17e-03 |1.534    |0.2231   |2.8439  |0.0548 |
|dateofdcc1                       |                   |PC5                 |F-test |5.25e-03 |1.731    |         |        |0.5987 |
|dateofdcc1                       |05/11/2019         |PC5                 |t-test |2.25e-08 |2.549    |1.5717   |3.5270  |0.1760 |
|dateofdcc1                       |08/10/2019         |PC5                 |t-test |2.05e-11 |2.184    |1.5005   |2.8674  |0.2415 |
|dateofdcc1                       |11/10/2019         |PC5                 |t-test |9.09e-04 |2.069    |0.6878   |3.4501  |0.0663 |
|dateofdcc1                       |12/05/2020         |PC5                 |t-test |7.71e-04 |1.529    |0.5231   |2.5358  |0.0680 |
|dateofdcc1                       |12/09/2019         |PC5                 |t-test |5.75e-03 |-1.230   |-2.2204  |-0.2387 |0.0464 |
|dateofdcc1                       |19/02/2020         |PC5                 |t-test |6.92e-03 |1.203    |0.2112   |2.1957  |0.0444 |
|observer1                        |Jeroen Burmanje    |PC5                 |t-test |5.26e-03 |0.337    |0.0757   |0.5975  |0.0449 |
|dateofsample2                    |10/10/2019         |PC5                 |t-test |1.90e-03 |-1.777   |-3.0198  |-0.5341 |0.1988 |
|dateofdcc2                       |17/12/2019         |PC5                 |t-test |6.71e-04 |-1.407   |-2.2989  |-0.5150 |0.2083 |
|dateofdcc2                       |18/05/2020         |PC5                 |t-test |1.97e-03 |-1.755   |-2.9922  |-0.5183 |0.1758 |
|observer2                        |Jeroen             |PC5                 |t-test |8.64e-03 |-0.649   |-1.1928  |-0.1049 |0.1300 |
|sputum_phenotype1_2              |Eosinophilic       |PC5                 |t-test |8.46e-03 |-0.413   |-0.7521  |-0.0747 |0.1307 |
|sputum_phenotype_neutro2         |Eosinophilic       |PC5                 |t-test |8.46e-03 |-0.413   |-0.7521  |-0.0747 |0.1307 |
|Slide                            |                   |PC5                 |F-test |3.72e-24 |11.645   |         |        |0.6388 |
|Slide                            |205809360127       |PC5                 |t-test |4.40e-03 |-0.650   |-1.1565  |-0.1430 |0.0475 |
|Slide                            |205809360134       |PC5                 |t-test |8.33e-03 |0.643    |0.1005   |1.1846  |0.0409 |
|Slide                            |205809360142       |PC5                 |t-test |4.27e-03 |-0.670   |-1.1917  |-0.1493 |0.0476 |
|Slide                            |205809360147       |PC5                 |t-test |4.55e-03 |-0.705   |-1.2563  |-0.1528 |0.0469 |
|Slide                            |205809360152       |PC5                 |t-test |1.09e-09 |1.500    |0.9770   |2.0237  |0.1969 |
|Slide                            |205809360176       |PC5                 |t-test |7.47e-17 |2.094    |1.5854   |2.6029  |0.3318 |
|Slide                            |205809370061       |PC5                 |t-test |1.90e-04 |0.844    |0.3461   |1.3421  |0.0802 |
|Slide                            |205809380033       |PC5                 |t-test |6.82e-05 |1.065    |0.4777   |1.6529  |0.0903 |
|Slide                            |205809380108       |PC5                 |t-test |5.46e-03 |-0.742   |-1.3358  |-0.1481 |0.0450 |
|Study_id                         |190                |PC6                 |t-test |1.72e-05 |2.727    |1.3362   |4.1177  |0.1005 |
|Study_id                         |UGA_111            |PC6                 |t-test |1.50e-03 |1.990    |0.5991   |3.3806  |0.0561 |
|Study_id                         |UGA_15             |PC6                 |t-test |1.00e-04 |2.456    |1.0653   |3.8467  |0.0831 |
|Study_id                         |UGA_16             |PC6                 |t-test |2.80e-04 |2.287    |0.8964   |3.6778  |0.0728 |
|Study_id                         |UGA_187            |PC6                 |t-test |4.58e-03 |1.736    |0.3734   |3.0991  |0.0453 |
|Study_id                         |UGA_191            |PC6                 |t-test |1.21e-03 |2.030    |0.6393   |3.4208  |0.0583 |
|Study_id                         |UGA_196            |PC6                 |t-test |5.68e-04 |2.165    |0.7747   |3.5561  |0.0658 |
|Study_id                         |UGA_228            |PC6                 |t-test |4.70e-04 |2.199    |0.8080   |3.5895  |0.0677 |
|Study_id                         |WASP86             |PC6                 |t-test |9.37e-03 |1.594    |0.2261   |2.9620  |0.0382 |
|Sample_Well                      |B13                |PC6                 |t-test |4.58e-03 |1.736    |0.3734   |3.0991  |0.0453 |
|Sample_Well                      |C13                |PC6                 |t-test |1.21e-03 |2.030    |0.6393   |3.4208  |0.0583 |
|Sample_Well                      |D13                |PC6                 |t-test |5.68e-04 |2.165    |0.7747   |3.5561  |0.0658 |
|Sample_Well                      |E09                |PC6                 |t-test |1.03e-03 |1.419    |0.4606   |2.3780  |0.0602 |
|Sample_Well                      |H09                |PC6                 |t-test |3.62e-03 |1.263    |0.2975   |2.2276  |0.0476 |
|Sample_Well                      |H13                |PC6                 |t-test |4.70e-04 |2.199    |0.8080   |3.5895  |0.0677 |
|uniquekey                        |                   |PC6                 |F-test |7.89e-06 |21.169   |         |        |0.1047 |
|studysubjectid                   |A0570              |PC6                 |t-test |2.80e-04 |2.287    |0.8964   |3.6778  |0.0728 |
|studysubjectid                   |A0571              |PC6                 |t-test |1.00e-04 |2.456    |1.0653   |3.8467  |0.0831 |
|studysubjectid                   |A0596              |PC6                 |t-test |4.70e-04 |2.199    |0.8080   |3.5895  |0.0677 |
|studysubjectid                   |A0689              |PC6                 |t-test |1.50e-03 |1.990    |0.5991   |3.3806  |0.0561 |
|studysubjectid                   |A0727              |PC6                 |t-test |4.58e-03 |1.736    |0.3734   |3.0991  |0.0453 |
|studysubjectid                   |A0730              |PC6                 |t-test |1.21e-03 |2.030    |0.6393   |3.4208  |0.0583 |
|studysubjectid                   |A0733              |PC6                 |t-test |5.68e-04 |2.165    |0.7747   |3.5561  |0.0658 |
|studysubjectid                   |AQ9557             |PC6                 |t-test |1.72e-05 |2.727    |1.3362   |4.1177  |0.1005 |
|studysubjectid                   |MB2117             |PC6                 |t-test |9.37e-03 |1.594    |0.2261   |2.9620  |0.0382 |
|centre                           |                   |PC6                 |F-test |1.42e-06 |10.830   |         |        |0.1536 |
|centre                           |Ecuador            |PC6                 |t-test |4.41e-03 |-0.313   |-0.5553  |-0.0712 |0.0454 |
|centre                           |Uganda             |PC6                 |t-test |1.88e-08 |0.640    |0.3979   |0.8815  |0.1615 |
|sputum_phenotype1_first          |                   |PC6                 |F-test |8.71e-04 |5.766    |         |        |0.0881 |
|sputum_phenotype1_first          |Mixed granulocytic |PC6                 |t-test |3.14e-05 |0.825    |0.3909   |1.2596  |0.0940 |
|acqscore                         |                   |PC6                 |F-test |2.58e-03 |9.403    |         |        |0.0609 |
|acqscorecat                      |                   |PC6                 |F-test |1.11e-03 |11.065   |         |        |0.0709 |
|acqscorecat                      |Uncontrolled       |PC6                 |t-test |4.51e-06 |0.624    |0.3313   |0.9171  |0.1400 |
|phadpos                          |                   |PC6                 |F-test |5.30e-03 |7.974    |         |        |0.0438 |
|phadpos                          |Negative           |PC6                 |t-test |2.45e-04 |0.413    |0.1682   |0.6587  |0.0763 |
|dateofsample1                    |04/04/2019         |PC6                 |t-test |5.50e-03 |-1.101   |-1.9828  |-0.2196 |0.0591 |
|dateofsample1                    |16/09/2018         |PC6                 |t-test |1.70e-06 |2.831    |1.5556   |4.1066  |0.1645 |
|dateofsample1                    |27/06/2019         |PC6                 |t-test |2.24e-03 |1.702    |0.4681   |2.9366  |0.0712 |
|dateofdcc1                       |                   |PC6                 |F-test |8.49e-06 |2.533    |         |        |0.6858 |
|dateofdcc1                       |11/12/2019         |PC6                 |t-test |1.81e-10 |1.631    |1.0895   |2.1718  |0.2133 |
|dateofdcc1                       |12/09/2019         |PC6                 |t-test |5.15e-03 |1.256    |0.2568   |2.2560  |0.0454 |
|dateofdcc1                       |16/12/2019         |PC6                 |t-test |5.11e-04 |2.181    |0.7926   |3.5689  |0.0691 |
|dateofdcc1                       |28/11/2019         |PC6                 |t-test |4.84e-03 |0.892    |0.1878   |1.5958  |0.0460 |
|neutrophilscount1                |                   |PC6                 |F-test |8.10e-03 |7.169    |         |        |0.0383 |
|monocytesmacrophagescount1       |                   |PC6                 |F-test |1.17e-03 |10.883   |         |        |0.0570 |
|neutrophils1                     |                   |PC6                 |F-test |3.84e-03 |8.577    |         |        |0.0455 |
|monocytesmacrophages1            |                   |PC6                 |F-test |1.92e-03 |9.918    |         |        |0.0522 |
|sputum_phenotype1_1              |                   |PC6                 |F-test |1.10e-03 |5.588    |         |        |0.0861 |
|sputum_phenotype1_1              |Mixed granulocytic |PC6                 |t-test |3.34e-05 |0.820    |0.3868   |1.2527  |0.0939 |
|sputum_phenotype_eos1            |                   |PC6                 |F-test |2.87e-03 |4.850    |         |        |0.0756 |
|sputum_phenotype_eos1            |Mixed granulocytic |PC6                 |t-test |1.85e-04 |0.566    |0.2334   |0.8984  |0.0770 |
|sputum_phenotype_neutro1         |                   |PC6                 |F-test |2.22e-03 |5.047    |         |        |0.0784 |
|sputum_phenotype_neutro1         |Mixed granulocytic |PC6                 |t-test |3.93e-05 |0.752    |0.3513   |1.1530  |0.0923 |
|dateofdcc2                       |18/12/2019         |PC6                 |t-test |1.51e-03 |0.972    |0.3078   |1.6360  |0.1839 |
|neutrophilscount_epigen          |                   |PC6                 |F-test |3.05e-03 |9.017    |         |        |0.0475 |
|monocytesmacrophagescount_epigen |                   |PC6                 |F-test |1.36e-03 |10.584   |         |        |0.0552 |
|neutrophils_epigen               |                   |PC6                 |F-test |1.74e-03 |10.103   |         |        |0.0531 |
|monocytesmacrophages_epigen      |                   |PC6                 |F-test |7.84e-04 |11.672   |         |        |0.0609 |
|sputum_phenotype_epigen          |                   |PC6                 |F-test |1.42e-03 |5.392    |         |        |0.0833 |
|sputum_phenotype_epigen          |Mixed granulocytic |PC6                 |t-test |3.42e-05 |0.821    |0.3870   |1.2558  |0.0937 |
|sputum_phenotype_eos_epigen      |                   |PC6                 |F-test |3.51e-03 |4.696    |         |        |0.0733 |
|sputum_phenotype_eos_epigen      |Mixed granulocytic |PC6                 |t-test |1.85e-04 |0.568    |0.2341   |0.9013  |0.0770 |
|sputum_phenotype_neutro_epigen   |                   |PC6                 |F-test |2.87e-03 |4.851    |         |        |0.0756 |
|sputum_phenotype_neutro_epigen   |Mixed granulocytic |PC6                 |t-test |4.00e-05 |0.754    |0.3517   |1.1560  |0.0922 |
|Slide                            |                   |PC6                 |F-test |2.54e-15 |7.117    |         |        |0.5195 |
|Slide                            |205809360152       |PC6                 |t-test |4.16e-04 |0.775    |0.2903   |1.2599  |0.0693 |
|Slide                            |205809360173       |PC6                 |t-test |5.09e-03 |0.619    |0.1279   |1.1105  |0.0442 |
|Slide                            |205809370061       |PC6                 |t-test |7.40e-14 |1.682    |1.2163   |2.1484  |0.2717 |
|Slide                            |205809370069       |PC6                 |t-test |8.59e-04 |-0.733   |-1.2200  |-0.2466 |0.0620 |
|Slide                            |205809370121       |PC6                 |t-test |2.18e-03 |-0.676   |-1.1650  |-0.1868 |0.0527 |
|Slide                            |205809380033       |PC6                 |t-test |9.60e-04 |-0.834   |-1.3934  |-0.2749 |0.0609 |
|Study_id                         |148                |PC7                 |t-test |6.76e-03 |1.774    |0.3146   |3.2340  |0.0403 |
|Study_id                         |167                |PC7                 |t-test |8.55e-03 |1.722    |0.2619   |3.1813  |0.0380 |
|Study_id                         |UGA_15             |PC7                 |t-test |7.83e-03 |1.712    |0.2771   |3.1472  |0.0391 |
|Study_id                         |UGA_16             |PC7                 |t-test |4.02e-05 |2.727    |1.2669   |4.1863  |0.0901 |
|Sample_Well                      |B08                |PC7                 |t-test |2.58e-03 |1.434    |0.3767   |2.4920  |0.0496 |
|uniquekey                        |                   |PC7                 |F-test |6.35e-04 |12.089   |         |        |0.0626 |
|studysubjectid                   |A0570              |PC7                 |t-test |4.02e-05 |2.727    |1.2669   |4.1863  |0.0901 |
|studysubjectid                   |A0571              |PC7                 |t-test |7.83e-03 |1.712    |0.2771   |3.1472  |0.0391 |
|studysubjectid                   |AQ8039             |PC7                 |t-test |6.76e-03 |1.774    |0.3146   |3.2340  |0.0403 |
|studysubjectid                   |AQ9513             |PC7                 |t-test |8.55e-03 |1.722    |0.2619   |3.1813  |0.0380 |
|centre                           |                   |PC7                 |F-test |1.27e-03 |5.474    |         |        |0.0840 |
|centre                           |Brazil             |PC7                 |t-test |1.93e-04 |-0.405   |-0.6424  |-0.1680 |0.0753 |
|centre                           |Uganda             |PC7                 |t-test |9.73e-03 |0.285    |0.0424   |0.5281  |0.0368 |
|age                              |                   |PC7                 |F-test |4.47e-03 |8.290    |         |        |0.0438 |
|dateofsample1                    |13/06/2018         |PC7                 |t-test |2.52e-03 |1.786    |0.4755   |3.0962  |0.0696 |
|dateofsample1                    |14/07/2018         |PC7                 |t-test |1.88e-03 |1.306    |0.3762   |2.2360  |0.0736 |
|dateofsample1                    |20/10/2018         |PC7                 |t-test |5.68e-03 |1.127    |0.2214   |2.0329  |0.0591 |
|dateofdcc1                       |                   |PC7                 |F-test |3.05e-07 |2.952    |         |        |0.7178 |
|dateofdcc1                       |06/11/2019         |PC7                 |t-test |1.22e-03 |-1.025   |-1.7282  |-0.3227 |0.0595 |
|dateofdcc1                       |07/10/2019         |PC7                 |t-test |8.59e-03 |1.178    |0.1789   |2.1766  |0.0397 |
|dateofdcc1                       |12/09/2019         |PC7                 |t-test |2.22e-03 |1.434    |0.3930   |2.4744  |0.0531 |
|dateofdcc1                       |17/12/2019         |PC7                 |t-test |2.41e-04 |1.040    |0.4152   |1.6647  |0.0760 |
|dateofdcc1                       |19/02/2019         |PC7                 |t-test |1.34e-04 |1.755    |0.7423   |2.7686  |0.0810 |
|observer1                        |                   |PC7                 |F-test |5.04e-04 |5.265    |         |        |0.1091 |
|observer1                        |Givaneide          |PC7                 |t-test |1.52e-04 |-0.413   |-0.6510  |-0.1755 |0.0803 |
|observer1                        |Jeroen Burmanje    |PC7                 |t-test |9.74e-04 |0.341    |0.1182   |0.5646  |0.0604 |
|dateofsample2                    |10/10/2018         |PC7                 |t-test |3.37e-03 |1.827    |0.4653   |3.1896  |0.1793 |
|dateofdcc2                       |14/01/2020         |PC7                 |t-test |4.09e-03 |0.886    |0.2101   |1.5622  |0.1533 |
|dateofdcc2                       |17/12/2019         |PC7                 |t-test |3.41e-04 |1.656    |0.6657   |2.6467  |0.2282 |
|observer2                        |                   |PC7                 |F-test |4.29e-05 |8.140    |         |        |0.4042 |
|observer2                        |Givaneide          |PC7                 |t-test |1.13e-07 |-0.773   |-1.0552  |-0.4910 |0.4399 |
|observer2                        |Jeroen Burmanje    |PC7                 |t-test |3.04e-04 |0.690    |0.2879   |1.0912  |0.2276 |
|neutrophilscount2                |                   |PC7                 |F-test |1.27e-03 |11.622   |         |        |0.1827 |
|neutrophils2                     |                   |PC7                 |F-test |7.95e-04 |12.728   |         |        |0.1997 |
|monocytesmacrophages2            |                   |PC7                 |F-test |6.39e-03 |8.091    |         |        |0.1369 |
|sputum_phenotype_eos2            |Mixed granulocytic |PC7                 |t-test |5.38e-03 |1.124    |0.2366   |2.0123  |0.1448 |
|sputum_phenotype_neutro2         |Neutrophilic       |PC7                 |t-test |5.04e-03 |0.755    |0.1650   |1.3451  |0.1497 |
|Slide                            |                   |PC7                 |F-test |7.47e-14 |6.458    |         |        |0.4952 |
|Slide                            |205809360173       |PC7                 |t-test |6.21e-05 |-0.918   |-1.4223  |-0.4145 |0.0864 |
|Slide                            |205809370069       |PC7                 |t-test |3.73e-03 |-0.672   |-1.1870  |-0.1573 |0.0463 |
|Slide                            |205809370102       |PC7                 |t-test |4.26e-03 |-0.706   |-1.2556  |-0.1570 |0.0450 |
|Slide                            |205809380108       |PC7                 |t-test |1.87e-03 |0.826    |0.2370   |1.4154  |0.0530 |
|Slide                            |205809380161       |PC7                 |t-test |4.18e-10 |1.451    |0.9574   |1.9454  |0.1964 |
|Study_id                         |111                |PC8                 |t-test |4.43e-05 |-2.101   |-3.2317  |-0.9703 |0.0912 |
|Study_id                         |173                |PC8                 |t-test |3.84e-03 |-1.439   |-2.5458  |-0.3317 |0.0470 |
|Study_id                         |85                 |PC8                 |t-test |8.18e-04 |-1.708   |-2.8387  |-0.5773 |0.0622 |
|Study_id                         |UGA_15             |PC8                 |t-test |6.41e-04 |-1.743   |-2.8740  |-0.6125 |0.0646 |
|Study_id                         |UGA_16             |PC8                 |t-test |1.42e-03 |-1.626   |-2.7566  |-0.4951 |0.0567 |
|Study_id                         |UGA_41             |PC8                 |t-test |1.88e-03 |1.583    |0.4522   |2.7136  |0.0539 |
|Study_id                         |WASP128            |PC8                 |t-test |2.89e-03 |-1.515   |-2.6460  |-0.3846 |0.0496 |
|Study_id                         |WASP88             |PC8                 |t-test |7.56e-03 |1.332    |0.2207   |2.4427  |0.0403 |
|Study_id                         |WASP96             |PC8                 |t-test |9.62e-04 |1.684    |0.5535   |2.8150  |0.0606 |
|Sample_Well                      |B10                |PC8                 |t-test |1.21e-03 |1.171    |0.3688   |1.9740  |0.0582 |
|Sample_Well                      |D05                |PC8                 |t-test |4.39e-04 |-1.270   |-2.0692  |-0.4712 |0.0684 |
|Sample_Well                      |G05                |PC8                 |t-test |3.01e-05 |-1.521   |-2.3205  |-0.7206 |0.0949 |
|Sample_Well                      |G06                |PC8                 |t-test |9.97e-03 |-0.912   |-1.7004  |-0.1228 |0.0375 |
|Sample_Well                      |G09                |PC8                 |t-test |4.86e-03 |0.994    |0.2086   |1.7803  |0.0447 |
|uniquekey                        |                   |PC8                 |F-test |8.92e-04 |11.416   |         |        |0.0593 |
|studysubjectid                   |A0570              |PC8                 |t-test |1.42e-03 |-1.626   |-2.7566  |-0.4951 |0.0567 |
|studysubjectid                   |A0571              |PC8                 |t-test |6.41e-04 |-1.743   |-2.8740  |-0.6125 |0.0646 |
|studysubjectid                   |A0629              |PC8                 |t-test |1.88e-03 |1.583    |0.4522   |2.7136  |0.0539 |
|studysubjectid                   |AQ7188             |PC8                 |t-test |8.18e-04 |-1.708   |-2.8387  |-0.5773 |0.0622 |
|studysubjectid                   |AQ9509             |PC8                 |t-test |4.43e-05 |-2.101   |-3.2317  |-0.9703 |0.0912 |
|studysubjectid                   |AQ9522             |PC8                 |t-test |3.84e-03 |-1.439   |-2.5458  |-0.3317 |0.0470 |
|studysubjectid                   |BR6726             |PC8                 |t-test |2.89e-03 |-1.515   |-2.6460  |-0.3846 |0.0496 |
|studysubjectid                   |MB1282             |PC8                 |t-test |9.62e-04 |1.684    |0.5535   |2.8150  |0.0606 |
|studysubjectid                   |NG836              |PC8                 |t-test |7.56e-03 |1.332    |0.2207   |2.4427  |0.0403 |
|centre                           |                   |PC8                 |F-test |2.81e-03 |4.866    |         |        |0.0754 |
|centre                           |Brazil             |PC8                 |t-test |1.20e-03 |-0.281   |-0.4710  |-0.0907 |0.0583 |
|dateofsample1                    |12/03/2018         |PC8                 |t-test |6.95e-03 |1.390    |0.2444   |2.5348  |0.0573 |
|dateofsample1                    |12/05/2018         |PC8                 |t-test |1.34e-04 |-2.047   |-3.2212  |-0.8720 |0.1105 |
|dateofsample1                    |16/11/2018         |PC8                 |t-test |1.83e-03 |-1.654   |-2.8282  |-0.4790 |0.0750 |
|dateofsample1                    |17/12/2018         |PC8                 |t-test |1.07e-03 |1.739    |0.5641   |2.9133  |0.0823 |
|dateofsample1                    |21/11/2018         |PC8                 |t-test |6.73e-03 |-0.990   |-1.8029  |-0.1777 |0.0577 |
|dateofsample1                    |31/10/2018         |PC8                 |t-test |5.69e-03 |-1.461   |-2.6355  |-0.2863 |0.0596 |
|dateofdcc1                       |                   |PC8                 |F-test |1.94e-04 |2.146    |         |        |0.6491 |
|dateofdcc1                       |05/07/2020         |PC8                 |t-test |4.74e-03 |-0.500   |-0.8943  |-0.1067 |0.0462 |
|dateofdcc1                       |06/07/2020         |PC8                 |t-test |1.57e-03 |-0.595   |-1.0128  |-0.1782 |0.0576 |
|dateofdcc1                       |10/02/2020         |PC8                 |t-test |8.34e-04 |1.682    |0.5669   |2.7972  |0.0637 |
|dateofdcc1                       |12/09/2019         |PC8                 |t-test |4.69e-03 |-1.012   |-1.8086  |-0.2156 |0.0461 |
|dateofdcc1                       |13/06/2020         |PC8                 |t-test |5.57e-03 |-0.631   |-1.1374  |-0.1247 |0.0443 |
|dateofdcc1                       |22/06/2018         |PC8                 |t-test |6.80e-03 |1.330    |0.2352   |2.4242  |0.0425 |
|dateofdcc1                       |31/01/2019         |PC8                 |t-test |3.47e-05 |-2.103   |-3.2184  |-0.9881 |0.0962 |
|observer1                        |Givaneide          |PC8                 |t-test |8.66e-04 |-0.286   |-0.4745  |-0.0981 |0.0634 |
|observer1                        |Hajar              |PC8                 |t-test |3.04e-03 |0.434    |0.1092   |0.7581  |0.0508 |
|goodquality_sputum1              |                   |PC8                 |F-test |5.50e-04 |12.378   |         |        |0.0643 |
|goodquality_sputum1              |Good quality       |PC8                 |t-test |5.28e-03 |-0.503   |-0.8700  |-0.1352 |0.0427 |
|goodquality_sputum1              |Not good quality   |PC8                 |t-test |1.90e-04 |0.566    |0.2321   |0.8995  |0.0771 |
|dateofsample2                    |12/06/2018         |PC8                 |t-test |6.80e-04 |-2.078   |-3.3919  |-0.7647 |0.2330 |
|dateofdcc2                       |30/05/2020         |PC8                 |t-test |6.08e-04 |-0.833   |-1.3555  |-0.3109 |0.2113 |
|goodquality_epigen               |                   |PC8                 |F-test |2.25e-03 |9.606    |         |        |0.0504 |
|goodquality_epigen               |Not good quality   |PC8                 |t-test |1.15e-03 |0.477    |0.1526   |0.8012  |0.0588 |
|Slide                            |                   |PC8                 |F-test |6.49e-05 |2.813    |         |        |0.2993 |
|Slide                            |205809360134       |PC8                 |t-test |1.28e-03 |-0.629   |-1.0610  |-0.1962 |0.0577 |
|Slide                            |205809360168       |PC8                 |t-test |2.29e-03 |0.547    |0.1491   |0.9447  |0.0522 |
|Slide                            |205809380033       |PC8                 |t-test |1.03e-03 |-0.724   |-1.2122  |-0.2355 |0.0595 |
|Study_id                         |155                |PC9                 |t-test |1.84e-03 |-1.357   |-2.3235  |-0.3899 |0.0547 |
|Study_id                         |163                |PC9                 |t-test |1.89e-03 |-1.353   |-2.3199  |-0.3863 |0.0544 |
|Study_id                         |167                |PC9                 |t-test |2.33e-03 |-1.325   |-2.2917  |-0.3581 |0.0523 |
|Study_id                         |173                |PC9                 |t-test |1.03e-04 |-1.704   |-2.6712  |-0.7375 |0.0837 |
|Study_id                         |UGA_147            |PC9                 |t-test |4.68e-03 |1.229    |0.2618   |2.1954  |0.0453 |
|Study_id                         |UGA_180            |PC9                 |t-test |1.31e-03 |1.401    |0.4343   |2.3679  |0.0581 |
|Study_id                         |UGA_197            |PC9                 |t-test |7.61e-03 |-1.138   |-2.0873  |-0.1878 |0.0407 |
|Study_id                         |UGA_49             |PC9                 |t-test |4.76e-03 |1.226    |0.2594   |2.1930  |0.0451 |
|Study_id                         |UGA_79             |PC9                 |t-test |2.50e-03 |1.316    |0.3488   |2.2824  |0.0516 |
|Study_id                         |WASP72             |PC9                 |t-test |9.78e-03 |1.102    |0.1509   |2.0528  |0.0382 |
|Study_id                         |WASP86             |PC9                 |t-test |3.29e-03 |1.278    |0.3111   |2.2447  |0.0488 |
|Sample_Well                      |B06                |PC9                 |t-test |1.84e-03 |-1.357   |-2.3235  |-0.3899 |0.0547 |
|Sample_Well                      |E09                |PC9                 |t-test |5.63e-05 |1.252    |0.5686   |1.9355  |0.0893 |
|Sample_Well                      |E13                |PC9                 |t-test |7.61e-03 |-1.138   |-2.0873  |-0.1878 |0.0407 |
|Sample_Well                      |H07                |PC9                 |t-test |8.64e-03 |0.794    |0.1202   |1.4678  |0.0394 |
|Sample_Well                      |H09                |PC9                 |t-test |3.46e-03 |0.903    |0.2163   |1.5896  |0.0483 |
|Sample_Well                      |H12                |PC9                 |t-test |1.31e-03 |1.401    |0.4343   |2.3679  |0.0581 |
|uniquekey                        |                   |PC9                 |F-test |4.78e-03 |8.162    |         |        |0.0431 |
|studysubjectid                   |A0616              |PC9                 |t-test |2.50e-03 |1.316    |0.3488   |2.2824  |0.0516 |
|studysubjectid                   |A0644              |PC9                 |t-test |4.76e-03 |1.226    |0.2594   |2.1930  |0.0451 |
|studysubjectid                   |A0708              |PC9                 |t-test |4.68e-03 |1.229    |0.2618   |2.1954  |0.0453 |
|studysubjectid                   |A0725              |PC9                 |t-test |1.31e-03 |1.401    |0.4343   |2.3679  |0.0581 |
|studysubjectid                   |A0731              |PC9                 |t-test |7.61e-03 |-1.138   |-2.0873  |-0.1878 |0.0407 |
|studysubjectid                   |AQ9500             |PC9                 |t-test |1.84e-03 |-1.357   |-2.3235  |-0.3899 |0.0547 |
|studysubjectid                   |AQ9508             |PC9                 |t-test |1.89e-03 |-1.353   |-2.3199  |-0.3863 |0.0544 |
|studysubjectid                   |AQ9513             |PC9                 |t-test |2.33e-03 |-1.325   |-2.2917  |-0.3581 |0.0523 |
|studysubjectid                   |AQ9522             |PC9                 |t-test |1.03e-04 |-1.704   |-2.6712  |-0.7375 |0.0837 |
|studysubjectid                   |MB2045             |PC9                 |t-test |9.78e-03 |1.102    |0.1509   |2.0528  |0.0382 |
|studysubjectid                   |MB2117             |PC9                 |t-test |3.29e-03 |1.278    |0.3111   |2.2447  |0.0488 |
|centre                           |                   |PC9                 |F-test |2.88e-03 |4.848    |         |        |0.0751 |
|centre                           |New Zealand        |PC9                 |t-test |6.99e-04 |0.266    |0.0939   |0.4379  |0.0644 |
|dateofsample1                    |12/06/2018         |PC9                 |t-test |1.06e-05 |-1.363   |-2.0351  |-0.6918 |0.1443 |
|dateofsample1                    |13/06/2018         |PC9                 |t-test |1.89e-03 |-1.333   |-2.2838  |-0.3832 |0.0752 |
|dateofsample1                    |19/07/2018         |PC9                 |t-test |1.43e-03 |-0.994   |-1.6833  |-0.3047 |0.0790 |
|dateofsample1                    |24/05/2019         |PC9                 |t-test |8.55e-03 |1.096    |0.1680   |2.0235  |0.0549 |
|dateofsample1                    |27/06/2019         |PC9                 |t-test |3.05e-03 |1.269    |0.3191   |2.2197  |0.0686 |
|dateofdcc1                       |                   |PC9                 |F-test |1.02e-03 |1.940    |         |        |0.6257 |
|dateofdcc1                       |04/12/2019         |PC9                 |t-test |4.43e-03 |1.215    |0.2649   |2.1643  |0.0477 |
|dateofdcc1                       |05/11/2019         |PC9                 |t-test |2.24e-03 |0.927    |0.2536   |1.6001  |0.0549 |
|dateofdcc1                       |09/01/2020         |PC9                 |t-test |1.41e-03 |-1.367   |-2.3168  |-0.4174 |0.0597 |
|dateofdcc1                       |10/10/2019         |PC9                 |t-test |3.02e-03 |0.897    |0.2248   |1.5686  |0.0517 |
|dateofdcc1                       |11/07/2019         |PC9                 |t-test |1.37e-03 |-1.371   |-2.3204  |-0.4211 |0.0600 |
|dateofdcc1                       |11/12/2019         |PC9                 |t-test |3.79e-06 |-0.785   |-1.1544  |-0.4151 |0.1218 |
|dateofdcc1                       |12/05/2020         |PC9                 |t-test |5.57e-03 |0.841    |0.1657   |1.5168  |0.0454 |
|observer1                        |Givaneide          |PC9                 |t-test |3.89e-03 |-0.207   |-0.3652  |-0.0496 |0.0491 |
|observer1                        |Jeroen             |PC9                 |t-test |4.48e-03 |0.254    |0.0564   |0.4511  |0.0473 |
|dateofsample2                    |18/10/2018         |PC9                 |t-test |5.75e-04 |-1.438   |-2.3318  |-0.5437 |0.2434 |
|dateofdcc2                       |02/09/2019         |PC9                 |t-test |1.01e-03 |-1.410   |-2.3392  |-0.4811 |0.1996 |
|observer2                        |                   |PC9                 |F-test |3.14e-03 |4.608    |         |        |0.2775 |
|observer2                        |Givaneide          |PC9                 |t-test |9.38e-03 |-0.300   |-0.5506  |-0.0490 |0.1324 |
|observer2                        |Jeroen             |PC9                 |t-test |4.83e-03 |0.477    |0.1068   |0.8480  |0.1539 |
|observer2                        |Jeroen  Burmanje   |PC9                 |t-test |1.01e-03 |-1.410   |-2.3392  |-0.4811 |0.1996 |
|Array                            |                   |PC9                 |F-test |8.27e-04 |3.748    |         |        |0.1304 |
|Array                            |R08C01             |PC9                 |t-test |9.77e-06 |0.450    |0.2282   |0.6710  |0.1060 |
|Slide                            |                   |PC9                 |F-test |1.91e-12 |5.847    |         |        |0.4704 |
|Slide                            |205809360103       |PC9                 |t-test |1.91e-03 |-0.476   |-0.8155  |-0.1360 |0.0546 |
|Slide                            |205809360147       |PC9                 |t-test |8.58e-03 |0.431    |0.0660   |0.7962  |0.0395 |
|Slide                            |205809360176       |PC9                 |t-test |4.57e-05 |0.645    |0.2979   |0.9927  |0.0913 |
|Slide                            |205809370061       |PC9                 |t-test |1.24e-05 |-0.661   |-0.9913  |-0.3303 |0.1054 |
|Slide                            |205809380116       |PC9                 |t-test |1.06e-09 |-0.997   |-1.3454  |-0.6491 |0.1911 |
|sentrix_row                      |                   |PC9                 |F-test |8.27e-04 |3.748    |         |        |0.1304 |
|sentrix_row                      |08                 |PC9                 |t-test |9.77e-06 |0.450    |0.2282   |0.6710  |0.1060 |
|Study_id                         |85                 |PC10                |t-test |6.65e-03 |1.341    |0.2400   |2.4415  |0.0400 |
|Study_id                         |UGA_16             |PC10                |t-test |7.00e-03 |1.333    |0.2315   |2.4336  |0.0395 |
|Study_id                         |UGA_67             |PC10                |t-test |7.82e-03 |1.315    |0.2130   |2.4162  |0.0384 |
|Study_id                         |WASP125            |PC10                |t-test |7.46e-03 |-1.322   |-2.4234  |-0.2207 |0.0389 |
|Sample_Well                      |G09                |PC10                |t-test |6.64e-03 |0.951    |0.1706   |1.7312  |0.0400 |
|uniquekey                        |                   |PC10                |F-test |1.06e-04 |15.719   |         |        |0.0799 |
|studysubjectid                   |A0570              |PC10                |t-test |7.00e-03 |1.333    |0.2315   |2.4336  |0.0395 |
|studysubjectid                   |A0660              |PC10                |t-test |7.82e-03 |1.315    |0.2130   |2.4162  |0.0384 |
|studysubjectid                   |AQ7188             |PC10                |t-test |6.65e-03 |1.341    |0.2400   |2.4415  |0.0400 |
|studysubjectid                   |BR7054             |PC10                |t-test |7.46e-03 |-1.322   |-2.4234  |-0.2207 |0.0389 |
|centre                           |                   |PC10                |F-test |8.74e-04 |5.763    |         |        |0.0881 |
|centre                           |Uganda             |PC10                |t-test |1.36e-04 |-0.305   |-0.4791  |-0.1309 |0.0775 |
|sputum_phenotype1_first          |Eosinophilic       |PC10                |t-test |8.75e-03 |0.197    |0.0325   |0.3618  |0.0374 |
|dateofsample1                    |16/11/2018         |PC10                |t-test |7.35e-03 |1.256    |0.2133   |2.2980  |0.0548 |
|dateofdcc1                       |05/11/2019         |PC10                |t-test |3.35e-03 |1.008    |0.2442   |1.7724  |0.0484 |
|dateofdcc1                       |07/07/2020         |PC10                |t-test |6.32e-04 |0.746    |0.2632   |1.2288  |0.0651 |
|sputum_phenotype1_1              |Eosinophilic       |PC10                |t-test |8.58e-03 |0.199    |0.0332   |0.3650  |0.0378 |
|sputum_phenotype_neutro1         |Eosinophilic       |PC10                |t-test |8.70e-03 |0.200    |0.0329   |0.3670  |0.0376 |
|neutrophilscount_epigen          |                   |PC10                |F-test |8.76e-03 |7.022    |         |        |0.0373 |
|Slide                            |                   |PC10                |F-test |1.15e-04 |2.714    |         |        |0.2919 |
|Slide                            |205809360147       |PC10                |t-test |7.75e-03 |-0.506   |-0.9287  |-0.0830 |0.0385 |
|Slide                            |205809380033       |PC10                |t-test |4.92e-05 |0.820    |0.3761   |1.2637  |0.0872 |

## Principal components of the normalized betas

The following plots show the first 3 principal components of the
 most variable
probes colored by batch variables.
Batch variables with more than 10 levels are omitted.






![plot of chunk unnamed-chunk-431](figure/unnamed-chunk-431-1.png)






![plot of chunk unnamed-chunk-434](figure/unnamed-chunk-434-1.png)






![plot of chunk unnamed-chunk-437](figure/unnamed-chunk-437-1.png)






![plot of chunk unnamed-chunk-440](figure/unnamed-chunk-440-1.png)






![plot of chunk unnamed-chunk-443](figure/unnamed-chunk-443-1.png)






![plot of chunk unnamed-chunk-446](figure/unnamed-chunk-446-1.png)






![plot of chunk unnamed-chunk-449](figure/unnamed-chunk-449-1.png)






![plot of chunk unnamed-chunk-452](figure/unnamed-chunk-452-1.png)






![plot of chunk unnamed-chunk-455](figure/unnamed-chunk-455-1.png)






![plot of chunk unnamed-chunk-458](figure/unnamed-chunk-458-1.png)






![plot of chunk unnamed-chunk-461](figure/unnamed-chunk-461-1.png)






![plot of chunk unnamed-chunk-464](figure/unnamed-chunk-464-1.png)






![plot of chunk unnamed-chunk-467](figure/unnamed-chunk-467-1.png)






![plot of chunk unnamed-chunk-470](figure/unnamed-chunk-470-1.png)






![plot of chunk unnamed-chunk-473](figure/unnamed-chunk-473-1.png)






![plot of chunk unnamed-chunk-476](figure/unnamed-chunk-476-1.png)






![plot of chunk unnamed-chunk-479](figure/unnamed-chunk-479-1.png)






![plot of chunk unnamed-chunk-482](figure/unnamed-chunk-482-1.png)






![plot of chunk unnamed-chunk-485](figure/unnamed-chunk-485-1.png)






![plot of chunk unnamed-chunk-488](figure/unnamed-chunk-488-1.png)






![plot of chunk unnamed-chunk-491](figure/unnamed-chunk-491-1.png)






![plot of chunk unnamed-chunk-494](figure/unnamed-chunk-494-1.png)






![plot of chunk unnamed-chunk-497](figure/unnamed-chunk-497-1.png)






![plot of chunk unnamed-chunk-500](figure/unnamed-chunk-500-1.png)






![plot of chunk unnamed-chunk-503](figure/unnamed-chunk-503-1.png)






![plot of chunk unnamed-chunk-506](figure/unnamed-chunk-506-1.png)






![plot of chunk unnamed-chunk-509](figure/unnamed-chunk-509-1.png)






![plot of chunk unnamed-chunk-512](figure/unnamed-chunk-512-1.png)






![plot of chunk unnamed-chunk-515](figure/unnamed-chunk-515-1.png)






![plot of chunk unnamed-chunk-518](figure/unnamed-chunk-518-1.png)






![plot of chunk unnamed-chunk-521](figure/unnamed-chunk-521-1.png)






![plot of chunk unnamed-chunk-524](figure/unnamed-chunk-524-1.png)






![plot of chunk unnamed-chunk-527](figure/unnamed-chunk-527-1.png)






![plot of chunk unnamed-chunk-530](figure/unnamed-chunk-530-1.png)






![plot of chunk unnamed-chunk-533](figure/unnamed-chunk-533-1.png)






![plot of chunk unnamed-chunk-536](figure/unnamed-chunk-536-1.png)






![plot of chunk unnamed-chunk-539](figure/unnamed-chunk-539-1.png)






![plot of chunk unnamed-chunk-542](figure/unnamed-chunk-542-1.png)






![plot of chunk unnamed-chunk-545](figure/unnamed-chunk-545-1.png)






![plot of chunk unnamed-chunk-548](figure/unnamed-chunk-548-1.png)






![plot of chunk unnamed-chunk-551](figure/unnamed-chunk-551-1.png)






![plot of chunk unnamed-chunk-554](figure/unnamed-chunk-554-1.png)

## Normalized probe associations with measured batch variables

The most variable normalized probes were extracted, decomposed into
principal components and each component regressed against each batch
variable. If the normalization has performed well then there will be
no associations between normalized probe PCs and batch
variables. Horizontal dotted line denotes $p = 0.05$ in log-scale.






![plot of chunk unnamed-chunk-559](figure/unnamed-chunk-559-1.png)






![plot of chunk unnamed-chunk-562](figure/unnamed-chunk-562-1.png)






![plot of chunk unnamed-chunk-565](figure/unnamed-chunk-565-1.png)






![plot of chunk unnamed-chunk-568](figure/unnamed-chunk-568-1.png)






![plot of chunk unnamed-chunk-571](figure/unnamed-chunk-571-1.png)






![plot of chunk unnamed-chunk-574](figure/unnamed-chunk-574-1.png)






![plot of chunk unnamed-chunk-577](figure/unnamed-chunk-577-1.png)






![plot of chunk unnamed-chunk-580](figure/unnamed-chunk-580-1.png)






![plot of chunk unnamed-chunk-583](figure/unnamed-chunk-583-1.png)






![plot of chunk unnamed-chunk-586](figure/unnamed-chunk-586-1.png)






![plot of chunk unnamed-chunk-589](figure/unnamed-chunk-589-1.png)






![plot of chunk unnamed-chunk-592](figure/unnamed-chunk-592-1.png)






![plot of chunk unnamed-chunk-595](figure/unnamed-chunk-595-1.png)






![plot of chunk unnamed-chunk-598](figure/unnamed-chunk-598-1.png)






![plot of chunk unnamed-chunk-601](figure/unnamed-chunk-601-1.png)






![plot of chunk unnamed-chunk-604](figure/unnamed-chunk-604-1.png)






![plot of chunk unnamed-chunk-607](figure/unnamed-chunk-607-1.png)






![plot of chunk unnamed-chunk-610](figure/unnamed-chunk-610-1.png)






![plot of chunk unnamed-chunk-613](figure/unnamed-chunk-613-1.png)






![plot of chunk unnamed-chunk-616](figure/unnamed-chunk-616-1.png)






![plot of chunk unnamed-chunk-619](figure/unnamed-chunk-619-1.png)






![plot of chunk unnamed-chunk-622](figure/unnamed-chunk-622-1.png)






![plot of chunk unnamed-chunk-625](figure/unnamed-chunk-625-1.png)






![plot of chunk unnamed-chunk-628](figure/unnamed-chunk-628-1.png)






![plot of chunk unnamed-chunk-631](figure/unnamed-chunk-631-1.png)






![plot of chunk unnamed-chunk-634](figure/unnamed-chunk-634-1.png)






![plot of chunk unnamed-chunk-637](figure/unnamed-chunk-637-1.png)






![plot of chunk unnamed-chunk-640](figure/unnamed-chunk-640-1.png)






![plot of chunk unnamed-chunk-643](figure/unnamed-chunk-643-1.png)






![plot of chunk unnamed-chunk-646](figure/unnamed-chunk-646-1.png)






![plot of chunk unnamed-chunk-649](figure/unnamed-chunk-649-1.png)






![plot of chunk unnamed-chunk-652](figure/unnamed-chunk-652-1.png)






![plot of chunk unnamed-chunk-655](figure/unnamed-chunk-655-1.png)






![plot of chunk unnamed-chunk-658](figure/unnamed-chunk-658-1.png)






![plot of chunk unnamed-chunk-661](figure/unnamed-chunk-661-1.png)






![plot of chunk unnamed-chunk-664](figure/unnamed-chunk-664-1.png)






![plot of chunk unnamed-chunk-667](figure/unnamed-chunk-667-1.png)






![plot of chunk unnamed-chunk-670](figure/unnamed-chunk-670-1.png)






![plot of chunk unnamed-chunk-673](figure/unnamed-chunk-673-1.png)






![plot of chunk unnamed-chunk-676](figure/unnamed-chunk-676-1.png)






![plot of chunk unnamed-chunk-679](figure/unnamed-chunk-679-1.png)






![plot of chunk unnamed-chunk-682](figure/unnamed-chunk-682-1.png)






![plot of chunk unnamed-chunk-685](figure/unnamed-chunk-685-1.png)






![plot of chunk unnamed-chunk-688](figure/unnamed-chunk-688-1.png)






![plot of chunk unnamed-chunk-691](figure/unnamed-chunk-691-1.png)






![plot of chunk unnamed-chunk-694](figure/unnamed-chunk-694-1.png)






![plot of chunk unnamed-chunk-697](figure/unnamed-chunk-697-1.png)






![plot of chunk unnamed-chunk-700](figure/unnamed-chunk-700-1.png)






![plot of chunk unnamed-chunk-703](figure/unnamed-chunk-703-1.png)






![plot of chunk unnamed-chunk-706](figure/unnamed-chunk-706-1.png)






![plot of chunk unnamed-chunk-709](figure/unnamed-chunk-709-1.png)






![plot of chunk unnamed-chunk-712](figure/unnamed-chunk-712-1.png)






![plot of chunk unnamed-chunk-715](figure/unnamed-chunk-715-1.png)






![plot of chunk unnamed-chunk-718](figure/unnamed-chunk-718-1.png)






![plot of chunk unnamed-chunk-721](figure/unnamed-chunk-721-1.png)






![plot of chunk unnamed-chunk-724](figure/unnamed-chunk-724-1.png)






![plot of chunk unnamed-chunk-727](figure/unnamed-chunk-727-1.png)






![plot of chunk unnamed-chunk-730](figure/unnamed-chunk-730-1.png)






![plot of chunk unnamed-chunk-733](figure/unnamed-chunk-733-1.png)






![plot of chunk unnamed-chunk-736](figure/unnamed-chunk-736-1.png)






![plot of chunk unnamed-chunk-739](figure/unnamed-chunk-739-1.png)






![plot of chunk unnamed-chunk-742](figure/unnamed-chunk-742-1.png)






![plot of chunk unnamed-chunk-745](figure/unnamed-chunk-745-1.png)






![plot of chunk unnamed-chunk-748](figure/unnamed-chunk-748-1.png)






![plot of chunk unnamed-chunk-751](figure/unnamed-chunk-751-1.png)






![plot of chunk unnamed-chunk-754](figure/unnamed-chunk-754-1.png)






![plot of chunk unnamed-chunk-757](figure/unnamed-chunk-757-1.png)






![plot of chunk unnamed-chunk-760](figure/unnamed-chunk-760-1.png)






![plot of chunk unnamed-chunk-763](figure/unnamed-chunk-763-1.png)






![plot of chunk unnamed-chunk-766](figure/unnamed-chunk-766-1.png)






![plot of chunk unnamed-chunk-769](figure/unnamed-chunk-769-1.png)






![plot of chunk unnamed-chunk-772](figure/unnamed-chunk-772-1.png)






![plot of chunk unnamed-chunk-775](figure/unnamed-chunk-775-1.png)






![plot of chunk unnamed-chunk-778](figure/unnamed-chunk-778-1.png)






![plot of chunk unnamed-chunk-781](figure/unnamed-chunk-781-1.png)






![plot of chunk unnamed-chunk-784](figure/unnamed-chunk-784-1.png)






![plot of chunk unnamed-chunk-787](figure/unnamed-chunk-787-1.png)






![plot of chunk unnamed-chunk-790](figure/unnamed-chunk-790-1.png)






![plot of chunk unnamed-chunk-793](figure/unnamed-chunk-793-1.png)






![plot of chunk unnamed-chunk-796](figure/unnamed-chunk-796-1.png)






![plot of chunk unnamed-chunk-799](figure/unnamed-chunk-799-1.png)






![plot of chunk unnamed-chunk-802](figure/unnamed-chunk-802-1.png)






![plot of chunk unnamed-chunk-805](figure/unnamed-chunk-805-1.png)






![plot of chunk unnamed-chunk-808](figure/unnamed-chunk-808-1.png)






![plot of chunk unnamed-chunk-811](figure/unnamed-chunk-811-1.png)






![plot of chunk unnamed-chunk-814](figure/unnamed-chunk-814-1.png)






![plot of chunk unnamed-chunk-817](figure/unnamed-chunk-817-1.png)

The following plots show regression coefficients when
each principal component is regressed against each batch variable level
along with 95% confidence intervals.
Cases significantly different from zero are coloured red
(p < 0.01, t-test).






![plot of chunk unnamed-chunk-821](figure/unnamed-chunk-821-1.png)




![plot of chunk unnamed-chunk-822](figure/unnamed-chunk-822-1.png)




![plot of chunk unnamed-chunk-823](figure/unnamed-chunk-823-1.png)




![plot of chunk unnamed-chunk-824](figure/unnamed-chunk-824-1.png)




![plot of chunk unnamed-chunk-825](figure/unnamed-chunk-825-1.png)




![plot of chunk unnamed-chunk-826](figure/unnamed-chunk-826-1.png)




![plot of chunk unnamed-chunk-827](figure/unnamed-chunk-827-1.png)




![plot of chunk unnamed-chunk-828](figure/unnamed-chunk-828-1.png)




![plot of chunk unnamed-chunk-829](figure/unnamed-chunk-829-1.png)




![plot of chunk unnamed-chunk-830](figure/unnamed-chunk-830-1.png)


|batch.variable                   |batch.value        |principal.component |test   |p.value  |estimate |lower   |upper   |r2     |
|:--------------------------------|:------------------|:-------------------|:------|:--------|:--------|:-------|:-------|:------|
|centre                           |                   |PC1                 |F-test |1.13e-05 |9.167    |        |        |0.1332 |
|centre                           |New Zealand        |PC1                 |t-test |7.47e-05 |11.169   |5.015   |17.323  |0.0832 |
|centre                           |Uganda             |PC1                 |t-test |3.75e-05 |-10.536  |-16.083 |-4.989  |0.0898 |
|sputum_phenotype1_first          |                   |PC1                 |F-test |4.84e-10 |17.570   |        |        |0.2275 |
|sputum_phenotype1_first          |Eosinophilic       |PC1                 |t-test |7.30e-05 |9.450    |4.298   |14.602  |0.0835 |
|sputum_phenotype1_first          |Mixed granulocytic |PC1                 |t-test |3.71e-05 |-20.004  |-30.641 |-9.367  |0.0900 |
|sputum_phenotype1_first          |Neutrophilic       |PC1                 |t-test |1.09e-05 |-13.305  |-19.885 |-6.725  |0.1016 |
|dateofdcc1                       |                   |PC1                 |F-test |2.93e-03 |1.806    |        |        |0.6089 |
|observer1                        |                   |PC1                 |F-test |2.20e-05 |7.201    |        |        |0.1434 |
|observer1                        |Hajar              |PC1                 |t-test |3.17e-03 |13.580   |3.371   |23.790  |0.0487 |
|observer1                        |Jeroen             |PC1                 |t-test |6.50e-03 |8.775    |1.637   |15.914  |0.0416 |
|observer1                        |Jeroen Burmanje    |PC1                 |t-test |2.87e-04 |-8.345   |-13.289 |-3.401  |0.0726 |
|neutrophilscount1                |                   |PC1                 |F-test |9.55e-15 |71.417   |        |        |0.2841 |
|monocytesmacrophagescount1       |                   |PC1                 |F-test |3.00e-13 |62.106   |        |        |0.2565 |
|totalcellcount1                  |                   |PC1                 |F-test |3.44e-03 |8.790    |        |        |0.0466 |
|neutrophils1                     |                   |PC1                 |F-test |6.55e-15 |72.461   |        |        |0.2870 |
|monocytesmacrophages1            |                   |PC1                 |F-test |2.74e-13 |62.347   |        |        |0.2573 |
|sputum_phenotype1_1              |                   |PC1                 |F-test |4.11e-10 |17.726   |        |        |0.2300 |
|sputum_phenotype1_1              |Eosinophilic       |PC1                 |t-test |5.94e-05 |9.627    |4.444   |14.809  |0.0859 |
|sputum_phenotype1_1              |Mixed granulocytic |PC1                 |t-test |3.73e-05 |-20.047  |-30.709 |-9.385  |0.0904 |
|sputum_phenotype1_1              |Neutrophilic       |PC1                 |t-test |1.06e-05 |-13.361  |-19.957 |-6.765  |0.1025 |
|sputum_phenotype_eos1            |                   |PC1                 |F-test |1.29e-09 |16.725   |        |        |0.2199 |
|sputum_phenotype_eos1            |Eosinophilic       |PC1                 |t-test |1.47e-05 |10.105   |5.103   |15.106  |0.0993 |
|sputum_phenotype_eos1            |Mixed granulocytic |PC1                 |t-test |1.79e-05 |-15.860  |-23.935 |-7.785  |0.0974 |
|sputum_phenotype_eos1            |Neutrophilic       |PC1                 |t-test |7.82e-05 |-13.797  |-21.452 |-6.142  |0.0832 |
|sputum_phenotype_neutro1         |                   |PC1                 |F-test |1.97e-11 |20.446   |        |        |0.2563 |
|sputum_phenotype_neutro1         |Eosinophilic       |PC1                 |t-test |2.11e-05 |10.233   |5.044   |15.423  |0.0959 |
|sputum_phenotype_neutro1         |Mixed granulocytic |PC1                 |t-test |2.72e-05 |-18.858  |-28.702 |-9.014  |0.0934 |
|sputum_phenotype_neutro1         |Neutrophilic       |PC1                 |t-test |1.77e-06 |-13.382  |-19.432 |-7.332  |0.1194 |
|neutrophilscount_epigen          |                   |PC1                 |F-test |1.88e-14 |69.494   |        |        |0.2774 |
|monocytesmacrophagescount_epigen |                   |PC1                 |F-test |4.02e-14 |67.423   |        |        |0.2714 |
|totalcellcount_epigen            |                   |PC1                 |F-test |4.02e-03 |8.492    |        |        |0.0448 |
|neutrophils_epigen               |                   |PC1                 |F-test |5.32e-15 |73.038   |        |        |0.2886 |
|monocytesmacrophages_epigen      |                   |PC1                 |F-test |1.03e-13 |64.963   |        |        |0.2652 |
|sputum_phenotype_epigen          |                   |PC1                 |F-test |5.72e-10 |17.434   |        |        |0.2271 |
|sputum_phenotype_epigen          |Eosinophilic       |PC1                 |t-test |1.95e-04 |8.950    |3.741   |14.158  |0.0744 |
|sputum_phenotype_epigen          |Mixed granulocytic |PC1                 |t-test |3.53e-05 |-20.082  |-30.728 |-9.436  |0.0909 |
|sputum_phenotype_epigen          |Neutrophilic       |PC1                 |t-test |9.68e-06 |-13.401  |-19.986 |-6.815  |0.1033 |
|sputum_phenotype_eos_epigen      |                   |PC1                 |F-test |1.41e-09 |16.648   |        |        |0.2191 |
|sputum_phenotype_eos_epigen      |Eosinophilic       |PC1                 |t-test |2.31e-05 |9.855    |4.856   |14.853  |0.0950 |
|sputum_phenotype_eos_epigen      |Mixed granulocytic |PC1                 |t-test |1.66e-05 |-15.896  |-23.959 |-7.834  |0.0981 |
|sputum_phenotype_eos_epigen      |Neutrophilic       |PC1                 |t-test |7.32e-05 |-13.834  |-21.477 |-6.191  |0.0839 |
|sputum_phenotype_neutro_epigen   |                   |PC1                 |F-test |2.77e-11 |20.138   |        |        |0.2534 |
|sputum_phenotype_neutro_epigen   |Eosinophilic       |PC1                 |t-test |7.48e-05 |9.550    |4.331   |14.768  |0.0837 |
|sputum_phenotype_neutro_epigen   |Mixed granulocytic |PC1                 |t-test |2.56e-05 |-18.893  |-28.723 |-9.063  |0.0940 |
|sputum_phenotype_neutro_epigen   |Neutrophilic       |PC1                 |t-test |1.82e-06 |-13.230  |-19.217 |-7.243  |0.1192 |
|Slide                            |                   |PC1                 |F-test |7.58e-03 |1.964    |        |        |0.2298 |
|Slide                            |205809360127       |PC1                 |t-test |4.89e-03 |-16.066  |-28.755 |-3.376  |0.0429 |
|Study_id                         |242                |PC2                 |t-test |4.49e-03 |21.080   |4.570   |37.590  |0.0457 |
|Study_id                         |UGA_176            |PC2                 |t-test |2.78e-03 |-22.221  |-38.731 |-5.711  |0.0506 |
|Study_id                         |UGA_36             |PC2                 |t-test |1.75e-10 |-49.690  |-66.200 |-33.180 |0.2103 |
|Study_id                         |UGA_90             |PC2                 |t-test |8.48e-04 |-24.864  |-41.374 |-8.354  |0.0625 |
|Study_id                         |WASP100            |PC2                 |t-test |5.13e-03 |-20.758  |-37.268 |-4.248  |0.0444 |
|Study_id                         |WASP104            |PC2                 |t-test |3.83e-03 |-21.463  |-37.973 |-4.953  |0.0473 |
|Study_id                         |WASP109            |PC2                 |t-test |3.06e-03 |-21.993  |-38.503 |-5.483  |0.0496 |
|Study_id                         |WASP115            |PC2                 |t-test |3.60e-04 |-26.648  |-43.158 |-10.138 |0.0711 |
|Study_id                         |WASP87             |PC2                 |t-test |9.23e-03 |-18.956  |-35.191 |-2.721  |0.0387 |
|Study_id                         |WASP99             |PC2                 |t-test |9.31e-04 |-24.664  |-41.174 |-8.154  |0.0616 |
|Sample_Well                      |B04                |PC2                 |t-test |1.59e-03 |16.227   |4.823   |27.631  |0.0565 |
|Sample_Well                      |E10                |PC2                 |t-test |7.28e-03 |-14.256  |-26.090 |-2.423  |0.0409 |
|Sample_Well                      |F12                |PC2                 |t-test |2.78e-03 |-22.221  |-38.731 |-5.711  |0.0506 |
|Sample_Well                      |H08                |PC2                 |t-test |6.53e-05 |-22.831  |-35.409 |-10.254 |0.0883 |
|uniquekey                        |                   |PC2                 |F-test |2.19e-04 |14.233   |        |        |0.0729 |
|studysubjectid                   |A0639              |PC2                 |t-test |1.75e-10 |-49.690  |-66.200 |-33.180 |0.2103 |
|studysubjectid                   |A0671              |PC2                 |t-test |8.48e-04 |-24.864  |-41.374 |-8.354  |0.0625 |
|studysubjectid                   |A0722              |PC2                 |t-test |2.78e-03 |-22.221  |-38.731 |-5.711  |0.0506 |
|studysubjectid                   |AQ7990             |PC2                 |t-test |4.49e-03 |21.080   |4.570   |37.590  |0.0457 |
|studysubjectid                   |BR5582             |PC2                 |t-test |3.60e-04 |-26.648  |-43.158 |-10.138 |0.0711 |
|studysubjectid                   |MB1030             |PC2                 |t-test |5.13e-03 |-20.758  |-37.268 |-4.248  |0.0444 |
|studysubjectid                   |MB1263             |PC2                 |t-test |9.23e-03 |-18.956  |-35.191 |-2.721  |0.0387 |
|studysubjectid                   |NG464              |PC2                 |t-test |3.06e-03 |-21.993  |-38.503 |-5.483  |0.0496 |
|studysubjectid                   |NG550              |PC2                 |t-test |9.31e-04 |-24.664  |-41.174 |-8.154  |0.0616 |
|studysubjectid                   |NG559              |PC2                 |t-test |3.83e-03 |-21.463  |-37.973 |-4.953  |0.0473 |
|centre                           |                   |PC2                 |F-test |3.32e-10 |17.901   |        |        |0.2308 |
|centre                           |Ecuador            |PC2                 |t-test |5.24e-12 |8.289    |5.797   |10.781  |0.2411 |
|centre                           |New Zealand        |PC2                 |t-test |1.06e-03 |-4.660   |-7.786  |-1.534  |0.0593 |
|centre                           |Uganda             |PC2                 |t-test |3.59e-06 |-6.340   |-9.286  |-3.393  |0.1158 |
|age                              |                   |PC2                 |F-test |3.61e-03 |8.697    |        |        |0.0458 |
|severity_isaac                   |Severe asthma      |PC2                 |t-test |9.16e-03 |-3.399   |-6.226  |-0.572  |0.0456 |
|severity_12atac                  |Severe asthma      |PC2                 |t-test |3.49e-03 |-6.121   |-10.760 |-1.482  |0.0581 |
|sptpos                           |                   |PC2                 |F-test |9.44e-04 |11.305   |        |        |0.0591 |
|sptpos                           |Atopic             |PC2                 |t-test |2.34e-04 |-4.942   |-7.810  |-2.073  |0.0738 |
|sptpos                           |Non-atopic         |PC2                 |t-test |9.49e-03 |3.052    |0.486   |5.618   |0.0380 |
|sputum_phenotype1_first          |Neutrophilic       |PC2                 |t-test |7.38e-03 |-3.805   |-6.944  |-0.665  |0.0410 |
|acqscore                         |                   |PC2                 |F-test |4.71e-03 |8.239    |        |        |0.0538 |
|dateofsample1                    |                   |PC2                 |F-test |2.88e-04 |3.908    |        |        |0.9500 |
|dateofsample1                    |07/03/2016         |PC2                 |t-test |5.25e-04 |-26.123  |-42.717 |-9.529  |0.0935 |
|dateofsample1                    |11/05/2016         |PC2                 |t-test |2.22e-03 |-22.922  |-39.516 |-6.327  |0.0736 |
|dateofsample1                    |12/09/2018         |PC2                 |t-test |2.01e-04 |-28.107  |-44.701 |-11.512 |0.1067 |
|dateofsample1                    |20/04/2018         |PC2                 |t-test |2.99e-03 |-22.217  |-38.811 |-5.623  |0.0694 |
|dateofsample1                    |21/04/2018         |PC2                 |t-test |8.48e-03 |19.621   |3.027   |36.215  |0.0550 |
|dateofsample1                    |25/06/2019         |PC2                 |t-test |4.81e-03 |-20.471  |-36.599 |-4.343  |0.0633 |
|dateofsample1                    |27/04/2016         |PC2                 |t-test |1.76e-03 |-23.452  |-40.046 |-6.858  |0.0767 |
|dateofdcc1                       |                   |PC2                 |F-test |8.86e-03 |1.662    |        |        |0.5889 |
|dateofdcc1                       |06/11/2019         |PC2                 |t-test |6.30e-03 |-10.348  |-18.779 |-1.918  |0.0441 |
|dateofdcc1                       |07/04/2017         |PC2                 |t-test |1.76e-05 |-22.938  |-34.636 |-11.240 |0.1048 |
|dateofdcc1                       |07/10/2019         |PC2                 |t-test |5.43e-06 |-25.936  |-38.381 |-13.492 |0.1175 |
|dateofdcc1                       |17/08/2016         |PC2                 |t-test |3.30e-03 |-21.867  |-38.412 |-5.323  |0.0508 |
|dateofdcc1                       |24/01/2019         |PC2                 |t-test |5.50e-03 |-20.633  |-37.177 |-4.088  |0.0455 |
|observer1                        |Hajar              |PC2                 |t-test |6.13e-03 |-6.393   |-11.573 |-1.212  |0.0436 |
|squamouscellscount1              |                   |PC2                 |F-test |4.85e-07 |27.269   |        |        |0.1316 |
|squamouscells1                   |                   |PC2                 |F-test |2.53e-10 |44.939   |        |        |0.1998 |
|sputum_phenotype1_1              |Neutrophilic       |PC2                 |t-test |5.12e-03 |-3.926   |-7.024  |-0.828  |0.0449 |
|sputum_phenotype_neutro1         |Neutrophilic       |PC2                 |t-test |3.93e-03 |-3.843   |-6.780  |-0.907  |0.0473 |
|goodquality_sputum1              |                   |PC2                 |F-test |1.30e-03 |10.671   |        |        |0.0560 |
|goodquality_sputum1              |Not good quality   |PC2                 |t-test |4.60e-05 |-9.406   |-14.468 |-4.345  |0.0908 |
|dateofsample2                    |18/12/2018         |PC2                 |t-test |4.26e-04 |-28.288  |-45.421 |-11.155 |0.2532 |
|dateofsample2                    |27/10/2017         |PC2                 |t-test |2.66e-03 |-23.634  |-40.767 |-6.501  |0.1914 |
|dateofdcc2                       |25/05/2018         |PC2                 |t-test |3.69e-03 |-22.928  |-40.252 |-5.603  |0.1565 |
|squamouscellscount_epigen        |                   |PC2                 |F-test |1.44e-05 |19.885   |        |        |0.0990 |
|squamouscells_epigen             |                   |PC2                 |F-test |6.33e-08 |31.850   |        |        |0.1496 |
|sputum_phenotype_epigen          |Neutrophilic       |PC2                 |t-test |7.68e-03 |-3.799   |-6.950  |-0.648  |0.0408 |
|goodquality_epigen               |                   |PC2                 |F-test |2.10e-04 |14.315   |        |        |0.0733 |
|goodquality_epigen               |Not good quality   |PC2                 |t-test |3.15e-06 |-10.383  |-15.232 |-5.535  |0.1164 |
|Slide                            |                   |PC2                 |F-test |2.77e-05 |2.958    |        |        |0.3100 |
|Slide                            |205809360162       |PC2                 |t-test |2.77e-03 |-8.758   |-15.254 |-2.262  |0.0503 |
|Slide                            |205809360168       |PC2                 |t-test |3.25e-03 |-8.046   |-14.116 |-1.976  |0.0487 |
|Slide                            |205809370170       |PC2                 |t-test |3.12e-03 |7.745    |1.928   |13.562  |0.0496 |
|Slide                            |205809370173       |PC2                 |t-test |3.67e-04 |10.656   |4.053   |17.259  |0.0713 |
|Slide                            |205809380116       |PC2                 |t-test |9.78e-03 |6.791    |0.939   |12.643  |0.0382 |
|Slide                            |205809380161       |PC2                 |t-test |7.07e-04 |-9.920   |-16.395 |-3.445  |0.0643 |
|Study_id                         |WASP121            |PC3                 |t-test |9.04e-04 |19.737   |6.555   |32.919  |0.0598 |
|Study_id                         |WASP71             |PC3                 |t-test |3.03e-03 |17.572   |4.391   |30.754  |0.0480 |
|Study_id                         |WASP80             |PC3                 |t-test |1.04e-03 |19.488   |6.307   |32.670  |0.0584 |
|uniquekey                        |                   |PC3                 |F-test |1.20e-08 |35.698   |        |        |0.1647 |
|studysubjectid                   |BR9113             |PC3                 |t-test |9.04e-04 |19.737   |6.555   |32.919  |0.0598 |
|studysubjectid                   |MB1190             |PC3                 |t-test |3.03e-03 |17.572   |4.391   |30.754  |0.0480 |
|studysubjectid                   |MB1303             |PC3                 |t-test |1.04e-03 |19.488   |6.307   |32.670  |0.0584 |
|centre                           |                   |PC3                 |F-test |9.21e-25 |53.576   |        |        |0.4731 |
|centre                           |Brazil             |PC3                 |t-test |6.33e-06 |4.512    |2.351   |6.674   |0.1079 |
|centre                           |New Zealand        |PC3                 |t-test |2.02e-11 |6.994    |4.811   |9.177   |0.2215 |
|centre                           |Uganda             |PC3                 |t-test |1.09e-18 |-7.646   |-9.364  |-5.928  |0.3552 |
|sptpos                           |                   |PC3                 |F-test |1.71e-06 |24.482   |        |        |0.1197 |
|sptpos                           |Atopic             |PC3                 |t-test |1.71e-06 |4.350    |2.432   |6.267   |0.1197 |
|sptpos                           |Non-atopic         |PC3                 |t-test |6.09e-06 |-3.858   |-5.683  |-2.033  |0.1095 |
|sputum_phenotype1_first          |                   |PC3                 |F-test |6.21e-10 |17.351   |        |        |0.2253 |
|sputum_phenotype1_first          |Eosinophilic       |PC3                 |t-test |2.16e-09 |5.471    |3.550   |7.392   |0.1800 |
|sputum_phenotype1_first          |Neutrophilic       |PC3                 |t-test |9.61e-07 |-5.409   |-7.793  |-3.025  |0.1265 |
|phadresult                       |                   |PC3                 |F-test |6.39e-06 |21.672   |        |        |0.1108 |
|phadpos                          |                   |PC3                 |F-test |8.39e-06 |21.086   |        |        |0.1081 |
|phadpos                          |Negative           |PC3                 |t-test |1.24e-05 |-4.086   |-6.104  |-2.068  |0.1054 |
|phadpos                          |Positive           |PC3                 |t-test |8.39e-06 |4.389    |2.327   |6.451   |0.1081 |
|dateofsample1                    |                   |PC3                 |F-test |2.89e-04 |3.906    |        |        |0.9500 |
|dateofsample1                    |17/01/2019         |PC3                 |t-test |6.55e-04 |17.543   |6.190   |28.896  |0.0884 |
|dateofsample1                    |18/07/2019         |PC3                 |t-test |7.75e-04 |17.294   |5.941   |28.648  |0.0861 |
|dateofsample1                    |27/04/2018         |PC3                 |t-test |2.67e-03 |15.378   |4.025   |26.732  |0.0693 |
|dateofdcc1                       |                   |PC3                 |F-test |8.73e-06 |2.530    |        |        |0.6855 |
|dateofdcc1                       |06/11/2019         |PC3                 |t-test |1.27e-03 |-9.254   |-15.620 |-2.889  |0.0591 |
|dateofdcc1                       |11/12/2019         |PC3                 |t-test |4.93e-04 |-8.200   |-13.399 |-3.001  |0.0687 |
|dateofdcc1                       |13/05/2020         |PC3                 |t-test |1.98e-04 |12.607   |5.136   |20.077  |0.0776 |
|dateofdcc1                       |17/06/2020         |PC3                 |t-test |7.22e-03 |6.559    |1.125   |11.993  |0.0412 |
|observer1                        |                   |PC3                 |F-test |5.81e-21 |34.140   |        |        |0.4426 |
|observer1                        |Givaneide          |PC3                 |t-test |6.91e-06 |4.461    |2.317   |6.605   |0.1106 |
|observer1                        |Jeroen             |PC3                 |t-test |3.39e-10 |7.541    |5.005   |10.077  |0.2033 |
|observer1                        |Jeroen Burmanje    |PC3                 |t-test |9.21e-20 |-7.101   |-8.608  |-5.594  |0.3828 |
|neutrophilscount1                |                   |PC3                 |F-test |1.83e-05 |19.379   |        |        |0.0972 |
|eosinophilscount1                |                   |PC3                 |F-test |1.87e-08 |34.672   |        |        |0.1615 |
|neutrophils1                     |                   |PC3                 |F-test |1.46e-05 |19.866   |        |        |0.0994 |
|lymphocytes1                     |                   |PC3                 |F-test |9.49e-03 |6.874    |        |        |0.0368 |
|eosinophils1                     |                   |PC3                 |F-test |8.87e-09 |36.417   |        |        |0.1683 |
|sputum_phenotype1_1              |                   |PC3                 |F-test |8.38e-10 |17.101   |        |        |0.2237 |
|sputum_phenotype1_1              |Eosinophilic       |PC3                 |t-test |2.87e-09 |5.465    |3.529   |7.401   |0.1784 |
|sputum_phenotype1_1              |Neutrophilic       |PC3                 |t-test |1.12e-06 |-5.388   |-7.778  |-2.998  |0.1257 |
|sputum_phenotype_eos1            |                   |PC3                 |F-test |9.02e-11 |19.074   |        |        |0.2433 |
|sputum_phenotype_eos1            |Eosinophilic       |PC3                 |t-test |2.74e-10 |5.635    |3.777   |7.493   |0.1991 |
|sputum_phenotype_eos1            |Neutrophilic       |PC3                 |t-test |1.02e-06 |-6.192   |-8.933  |-3.450  |0.1266 |
|sputum_phenotype_neutro1         |                   |PC3                 |F-test |5.56e-09 |15.460   |        |        |0.2067 |
|sputum_phenotype_neutro1         |Eosinophilic       |PC3                 |t-test |2.64e-09 |5.511    |3.563   |7.459   |0.1791 |
|sputum_phenotype_neutro1         |Neutrophilic       |PC3                 |t-test |1.51e-05 |-4.475   |-6.721  |-2.230  |0.1007 |
|dateofsample2                    |10/10/2019         |PC3                 |t-test |7.41e-04 |16.932   |6.155   |27.708  |0.2349 |
|dateofsample2                    |18/01/2019         |PC3                 |t-test |2.43e-03 |15.016   |4.239   |25.792  |0.1945 |
|dateofdcc2                       |03/02/2020         |PC3                 |t-test |3.96e-03 |16.139   |3.844   |28.434  |0.1544 |
|dateofdcc2                       |18/05/2020         |PC3                 |t-test |1.41e-03 |18.055   |5.760   |30.351  |0.1860 |
|dateofdcc2                       |18/12/2019         |PC3                 |t-test |3.21e-03 |-7.131   |-12.412 |-1.851  |0.1639 |
|observer2                        |                   |PC3                 |F-test |7.63e-04 |5.714    |        |        |0.3226 |
|observer2                        |Jeroen             |PC3                 |t-test |1.56e-03 |8.144    |2.563   |13.725  |0.1797 |
|observer2                        |Jeroen Burmanje    |PC3                 |t-test |4.73e-04 |-5.062   |-8.114  |-2.011  |0.2226 |
|sputum_phenotype1_2              |                   |PC3                 |F-test |5.04e-03 |4.831    |        |        |0.2283 |
|sputum_phenotype1_2              |Eosinophilic       |PC3                 |t-test |4.12e-03 |4.696    |1.185   |8.208   |0.1504 |
|sputum_phenotype1_2              |Neutrophilic       |PC3                 |t-test |5.87e-03 |-7.333   |-13.180 |-1.486  |0.1448 |
|sputum_phenotype_eos2            |Eosinophilic       |PC3                 |t-test |8.10e-03 |4.379    |0.842   |7.916   |0.1296 |
|sputum_phenotype_neutro2         |                   |PC3                 |F-test |9.14e-03 |4.289    |        |        |0.2080 |
|sputum_phenotype_neutro2         |Eosinophilic       |PC3                 |t-test |4.12e-03 |4.696    |1.185   |8.208   |0.1504 |
|neutrophilscount_epigen          |                   |PC3                 |F-test |3.84e-05 |17.818   |        |        |0.0896 |
|eosinophilscount_epigen          |                   |PC3                 |F-test |7.93e-09 |36.661   |        |        |0.1684 |
|neutrophils_epigen               |                   |PC3                 |F-test |2.31e-05 |18.890   |        |        |0.0950 |
|lymphocytes_epigen               |                   |PC3                 |F-test |9.04e-03 |6.964    |        |        |0.0372 |
|eosinophils_epigen               |                   |PC3                 |F-test |4.23e-09 |38.163   |        |        |0.1749 |
|sputum_phenotype_epigen          |                   |PC3                 |F-test |9.57e-11 |19.021   |        |        |0.2428 |
|sputum_phenotype_epigen          |Eosinophilic       |PC3                 |t-test |2.55e-10 |5.781    |3.871   |7.691   |0.1997 |
|sputum_phenotype_epigen          |Neutrophilic       |PC3                 |t-test |8.53e-07 |-5.443   |-7.830  |-3.057  |0.1283 |
|sputum_phenotype_eos_epigen      |                   |PC3                 |F-test |1.66e-11 |20.604   |        |        |0.2578 |
|sputum_phenotype_eos_epigen      |Eosinophilic       |PC3                 |t-test |4.07e-11 |5.854    |4.019   |7.689   |0.2155 |
|sputum_phenotype_eos_epigen      |Neutrophilic       |PC3                 |t-test |8.12e-07 |-6.244   |-8.982  |-3.506  |0.1288 |
|sputum_phenotype_neutro_epigen   |                   |PC3                 |F-test |8.33e-10 |17.105   |        |        |0.2238 |
|sputum_phenotype_neutro_epigen   |Eosinophilic       |PC3                 |t-test |2.25e-10 |5.833    |3.911   |7.755   |0.2008 |
|sputum_phenotype_neutro_epigen   |Neutrophilic       |PC3                 |t-test |1.82e-05 |-4.395   |-6.622  |-2.168  |0.0988 |
|Slide                            |                   |PC3                 |F-test |1.96e-16 |7.631    |        |        |0.5369 |
|Slide                            |205809360142       |PC3                 |t-test |7.82e-04 |7.157    |2.443   |11.870  |0.0613 |
|Slide                            |205809360147       |PC3                 |t-test |1.68e-03 |7.187    |2.113   |12.260  |0.0538 |
|Slide                            |205809360152       |PC3                 |t-test |8.88e-03 |5.488    |0.819   |10.158  |0.0378 |
|Slide                            |205809360168       |PC3                 |t-test |8.35e-03 |5.532    |0.863   |10.200  |0.0384 |
|Slide                            |205809360173       |PC3                 |t-test |5.42e-05 |-8.357   |-12.904 |-3.810  |0.0877 |
|Slide                            |205809360176       |PC3                 |t-test |4.51e-03 |-5.948   |-10.601 |-1.294  |0.0444 |
|Slide                            |205809370061       |PC3                 |t-test |5.87e-05 |-8.320   |-12.868 |-3.771  |0.0869 |
|Slide                            |205809380161       |PC3                 |t-test |2.04e-03 |-6.445   |-11.080 |-1.810  |0.0522 |
|Study_id                         |UGA_180            |PC4                 |t-test |6.98e-03 |14.844   |2.584   |27.104  |0.0397 |
|Study_id                         |UGA_36             |PC4                 |t-test |4.25e-04 |19.871   |7.395   |32.347  |0.0665 |
|Sample_Well                      |H08                |PC4                 |t-test |3.08e-04 |14.417   |5.587   |23.246  |0.0696 |
|Sample_Well                      |H12                |PC4                 |t-test |6.98e-03 |14.844   |2.584   |27.104  |0.0397 |
|uniquekey                        |                   |PC4                 |F-test |5.39e-03 |7.934    |        |        |0.0420 |
|studysubjectid                   |A0639              |PC4                 |t-test |4.25e-04 |19.871   |7.395   |32.347  |0.0665 |
|studysubjectid                   |A0725              |PC4                 |t-test |6.98e-03 |14.844   |2.584   |27.104  |0.0397 |
|centre                           |                   |PC4                 |F-test |3.03e-09 |15.972   |        |        |0.2112 |
|centre                           |New Zealand        |PC4                 |t-test |2.81e-05 |-4.093   |-6.220  |-1.967  |0.0931 |
|centre                           |Uganda             |PC4                 |t-test |9.20e-09 |5.149    |3.248   |7.051   |0.1671 |
|dateofsample1                    |31/07/2018         |PC4                 |t-test |7.90e-03 |13.312   |2.157   |24.467  |0.0538 |
|dateofdcc1                       |10/12/2019         |PC4                 |t-test |4.68e-04 |9.691    |3.568   |15.815  |0.0685 |
|dateofdcc1                       |28/11/2019         |PC4                 |t-test |9.56e-03 |7.236    |1.013   |13.458  |0.0382 |
|observer1                        |                   |PC4                 |F-test |9.64e-05 |6.283    |        |        |0.1275 |
|observer1                        |Hajar              |PC4                 |t-test |5.92e-03 |-4.537   |-8.199  |-0.875  |0.0427 |
|observer1                        |Jeroen             |PC4                 |t-test |3.11e-03 |-3.403   |-5.946  |-0.860  |0.0491 |
|observer1                        |Jeroen Burmanje    |PC4                 |t-test |1.88e-03 |2.654    |0.810   |4.497   |0.0539 |
|totalcellcount1                  |                   |PC4                 |F-test |8.90e-03 |6.995    |        |        |0.0374 |
|totalcellcount_epigen            |                   |PC4                 |F-test |4.11e-03 |8.447    |        |        |0.0446 |
|goodquality_epigen               |                   |PC4                 |F-test |3.15e-03 |8.959    |        |        |0.0472 |
|goodquality_epigen               |Good quality       |PC4                 |t-test |3.15e-03 |4.803    |1.480   |8.126   |0.0472 |
|goodquality_epigen               |Not good quality   |PC4                 |t-test |2.93e-03 |-4.688   |-8.183  |-1.194  |0.0481 |
|Slide                            |                   |PC4                 |F-test |6.16e-06 |3.215    |        |        |0.3281 |
|Slide                            |205809360127       |PC4                 |t-test |1.74e-03 |6.190    |1.807   |10.574  |0.0531 |
|Slide                            |205809360162       |PC4                 |t-test |4.75e-03 |-5.966   |-10.663 |-1.268  |0.0434 |
|Slide                            |205809360168       |PC4                 |t-test |3.96e-03 |-5.708   |-10.110 |-1.306  |0.0452 |
|Slide                            |205809360172       |PC4                 |t-test |1.60e-05 |8.428    |4.151   |12.705  |0.0985 |
|Study_id                         |UGA_12             |PC5                 |t-test |2.69e-03 |-14.564  |-25.351 |-3.778  |0.0498 |
|Study_id                         |UGA_39             |PC5                 |t-test |1.67e-03 |-15.276  |-26.063 |-4.490  |0.0545 |
|Study_id                         |WASP113            |PC5                 |t-test |6.18e-03 |-13.259  |-24.045 |-2.473  |0.0416 |
|Study_id                         |WASP121            |PC5                 |t-test |4.96e-05 |-19.902  |-30.688 |-9.116  |0.0891 |
|Study_id                         |WASP31             |PC5                 |t-test |2.63e-03 |-14.598  |-25.384 |-3.812  |0.0500 |
|Study_id                         |WASP34             |PC5                 |t-test |8.95e-03 |-12.438  |-23.047 |-1.829  |0.0382 |
|Study_id                         |WASP71             |PC5                 |t-test |9.40e-03 |-12.359  |-22.970 |-1.747  |0.0377 |
|Sample_Well                      |E05                |PC5                 |t-test |1.47e-03 |-11.162  |-18.947 |-3.376  |0.0557 |
|Sample_Well                      |G07                |PC5                 |t-test |7.53e-05 |-13.496  |-21.000 |-5.992  |0.0850 |
|studysubjectid                   |A0624              |PC5                 |t-test |2.69e-03 |-14.564  |-25.351 |-3.778  |0.0498 |
|studysubjectid                   |A0631              |PC5                 |t-test |1.67e-03 |-15.276  |-26.063 |-4.490  |0.0545 |
|studysubjectid                   |BR2988             |PC5                 |t-test |8.95e-03 |-12.438  |-23.047 |-1.829  |0.0382 |
|studysubjectid                   |BR4274             |PC5                 |t-test |2.63e-03 |-14.598  |-25.384 |-3.812  |0.0500 |
|studysubjectid                   |BR6650             |PC5                 |t-test |6.18e-03 |-13.259  |-24.045 |-2.473  |0.0416 |
|studysubjectid                   |BR9113             |PC5                 |t-test |4.96e-05 |-19.902  |-30.688 |-9.116  |0.0891 |
|studysubjectid                   |MB1190             |PC5                 |t-test |9.40e-03 |-12.359  |-22.970 |-1.747  |0.0377 |
|centre                           |                   |PC5                 |F-test |4.58e-08 |13.664   |        |        |0.1863 |
|centre                           |Ecuador            |PC5                 |t-test |5.14e-03 |2.270    |0.484   |4.056   |0.0436 |
|centre                           |New Zealand        |PC5                 |t-test |3.84e-04 |3.028    |1.160   |4.896   |0.0693 |
|centre                           |Uganda             |PC5                 |t-test |2.55e-07 |-4.099   |-5.800  |-2.397  |0.1390 |
|group                            |                   |PC5                 |F-test |1.26e-05 |20.165   |        |        |0.1002 |
|group                            |Current asthma     |PC5                 |t-test |1.26e-05 |-4.454   |-6.556  |-2.353  |0.1002 |
|group                            |Never asthma       |PC5                 |t-test |1.34e-05 |3.964    |1.984   |5.944   |0.1024 |
|severity_isaac                   |                   |PC5                 |F-test |5.47e-03 |7.948    |        |        |0.0506 |
|severity_isaac                   |Severe asthma      |PC5                 |t-test |1.35e-03 |-2.715   |-4.540  |-0.889  |0.0673 |
|sptpos                           |                   |PC5                 |F-test |7.06e-03 |7.427    |        |        |0.0396 |
|sptpos                           |Atopic             |PC5                 |t-test |2.60e-03 |-2.371   |-4.063  |-0.678  |0.0495 |
|sputum_phenotype1_first          |                   |PC5                 |F-test |2.98e-05 |8.398    |        |        |0.1234 |
|sputum_phenotype1_first          |Eosinophilic       |PC5                 |t-test |9.04e-05 |-3.146   |-4.885  |-1.407  |0.0814 |
|sputum_phenotype1_first          |Paucigranulocytic  |PC5                 |t-test |1.81e-05 |3.064    |1.527   |4.600   |0.0994 |
|acqscorecat                      |Uncontrolled       |PC5                 |t-test |8.66e-03 |-2.641   |-4.863  |-0.419  |0.0479 |
|dateofsample1                    |06/02/2018         |PC5                 |t-test |4.47e-03 |-13.431  |-23.924 |-2.937  |0.0628 |
|dateofsample1                    |12/12/2018         |PC5                 |t-test |6.76e-03 |-12.816  |-23.341 |-2.291  |0.0572 |
|dateofsample1                    |17/01/2019         |PC5                 |t-test |2.57e-05 |-20.859  |-31.654 |-10.063 |0.1316 |
|dateofsample1                    |27/04/2018         |PC5                 |t-test |4.72e-03 |-13.351  |-23.849 |-2.853  |0.0621 |
|dateofsample1                    |29/10/2018         |PC5                 |t-test |3.47e-03 |-14.216  |-25.011 |-3.420  |0.0658 |
|observer1                        |                   |PC5                 |F-test |2.19e-03 |4.364    |        |        |0.0921 |
|observer1                        |Hajar              |PC5                 |t-test |2.05e-03 |4.415    |1.243   |7.588   |0.0545 |
|monocytesmacrophagescount1       |                   |PC5                 |F-test |6.09e-04 |12.176   |        |        |0.0634 |
|eosinophilscount1                |                   |PC5                 |F-test |4.00e-10 |43.823   |        |        |0.1958 |
|monocytesmacrophages1            |                   |PC5                 |F-test |1.30e-03 |10.682   |        |        |0.0560 |
|eosinophils1                     |                   |PC5                 |F-test |2.64e-10 |44.838   |        |        |0.1994 |
|sputum_phenotype1_1              |                   |PC5                 |F-test |1.17e-05 |9.144    |        |        |0.1335 |
|sputum_phenotype1_1              |Eosinophilic       |PC5                 |t-test |3.55e-05 |-3.311   |-5.040  |-1.583  |0.0909 |
|sputum_phenotype1_1              |Paucigranulocytic  |PC5                 |t-test |8.48e-06 |3.159    |1.637   |4.680   |0.1074 |
|sputum_phenotype_eos1            |                   |PC5                 |F-test |1.28e-05 |9.072    |        |        |0.1326 |
|sputum_phenotype_eos1            |Eosinophilic       |PC5                 |t-test |1.50e-04 |-2.974   |-4.668  |-1.281  |0.0770 |
|sputum_phenotype_eos1            |Paucigranulocytic  |PC5                 |t-test |6.90e-06 |3.301    |1.721   |4.881   |0.1094 |
|sputum_phenotype_neutro1         |                   |PC5                 |F-test |4.46e-05 |8.081    |        |        |0.1199 |
|sputum_phenotype_neutro1         |Eosinophilic       |PC5                 |t-test |7.31e-05 |-3.202   |-4.949  |-1.454  |0.0839 |
|sputum_phenotype_neutro1         |Paucigranulocytic  |PC5                 |t-test |7.08e-05 |2.892    |1.318   |4.466   |0.0865 |
|observer2                        |Hajar              |PC5                 |t-test |4.47e-03 |5.598    |1.299   |9.896   |0.1535 |
|squamouscellscount2              |                   |PC5                 |F-test |7.77e-03 |7.669    |        |        |0.1285 |
|totalcellcount2                  |                   |PC5                 |F-test |1.18e-04 |17.329   |        |        |0.2500 |
|lymphocytes2                     |                   |PC5                 |F-test |8.57e-03 |7.478    |        |        |0.1279 |
|sputum_phenotype1_2              |Eosinophilic       |PC5                 |t-test |1.78e-03 |-4.754   |-7.988  |-1.521  |0.1790 |
|sputum_phenotype1_2              |Paucigranulocytic  |PC5                 |t-test |7.45e-03 |4.092    |0.793   |7.392   |0.1347 |
|sputum_phenotype_neutro2         |Eosinophilic       |PC5                 |t-test |1.78e-03 |-4.754   |-7.988  |-1.521  |0.1790 |
|monocytesmacrophagescount_epigen |                   |PC5                 |F-test |1.99e-03 |9.848    |        |        |0.0516 |
|eosinophilscount_epigen          |                   |PC5                 |F-test |2.41e-10 |45.031   |        |        |0.1992 |
|monocytesmacrophages_epigen      |                   |PC5                 |F-test |2.32e-03 |9.545    |        |        |0.0504 |
|eosinophils_epigen               |                   |PC5                 |F-test |1.74e-10 |45.855   |        |        |0.2030 |
|sputum_phenotype_epigen          |                   |PC5                 |F-test |1.40e-04 |7.185    |        |        |0.1080 |
|sputum_phenotype_epigen          |Eosinophilic       |PC5                 |t-test |3.00e-04 |-2.935   |-4.698  |-1.173  |0.0702 |
|sputum_phenotype_epigen          |Paucigranulocytic  |PC5                 |t-test |8.66e-05 |2.830    |1.273   |4.386   |0.0845 |
|sputum_phenotype_eos_epigen      |                   |PC5                 |F-test |1.17e-04 |7.323    |        |        |0.1099 |
|sputum_phenotype_eos_epigen      |Eosinophilic       |PC5                 |t-test |9.33e-04 |-2.627   |-4.348  |-0.906  |0.0592 |
|sputum_phenotype_eos_epigen      |Paucigranulocytic  |PC5                 |t-test |5.99e-05 |3.005    |1.383   |4.627   |0.0882 |
|sputum_phenotype_neutro_epigen   |                   |PC5                 |F-test |5.76e-04 |6.087    |        |        |0.0930 |
|sputum_phenotype_neutro_epigen   |Eosinophilic       |PC5                 |t-test |5.73e-04 |-2.819   |-4.600  |-1.038  |0.0639 |
|sputum_phenotype_neutro_epigen   |Paucigranulocytic  |PC5                 |t-test |7.69e-04 |2.497    |0.880   |4.113   |0.0628 |
|Slide                            |                   |PC5                 |F-test |8.17e-06 |3.167    |        |        |0.3248 |
|Slide                            |205809360133       |PC5                 |t-test |1.60e-03 |-5.634   |-9.591  |-1.677  |0.0549 |
|Slide                            |205809360176       |PC5                 |t-test |9.55e-04 |-5.781   |-9.655  |-1.908  |0.0600 |
|Slide                            |205809370061       |PC5                 |t-test |6.54e-03 |-4.664   |-8.480  |-0.849  |0.0413 |
|Study_id                         |UGA_36             |PC6                 |t-test |6.95e-03 |-10.314  |-18.829 |-1.800  |0.0396 |
|studysubjectid                   |A0639              |PC6                 |t-test |6.95e-03 |-10.314  |-18.829 |-1.800  |0.0396 |
|centre                           |                   |PC6                 |F-test |1.09e-36 |94.469   |        |        |0.6129 |
|centre                           |Brazil             |PC6                 |t-test |4.80e-08 |3.381    |2.059   |4.703   |0.1529 |
|centre                           |Ecuador            |PC6                 |t-test |9.95e-38 |-6.700   |-7.607  |-5.792  |0.6007 |
|centre                           |New Zealand        |PC6                 |t-test |3.01e-05 |2.784    |1.332   |4.236   |0.0925 |
|age                              |                   |PC6                 |F-test |3.24e-12 |55.844   |        |        |0.2358 |
|dateofdcc1                       |                   |PC6                 |F-test |4.72e-11 |4.149    |        |        |0.7814 |
|dateofdcc1                       |02/03/2020         |PC6                 |t-test |9.31e-03 |-5.523   |-10.256 |-0.790  |0.0384 |
|dateofdcc1                       |09/09/2019         |PC6                 |t-test |4.38e-03 |-6.039   |-10.754 |-1.324  |0.0460 |
|dateofdcc1                       |20/02/2019         |PC6                 |t-test |1.16e-03 |-4.896   |-8.234  |-1.559  |0.0594 |
|dateofdcc1                       |28/08/2019         |PC6                 |t-test |6.38e-03 |-7.067   |-12.838 |-1.297  |0.0422 |
|observer1                        |                   |PC6                 |F-test |4.46e-15 |22.711   |        |        |0.3456 |
|observer1                        |Givaneide          |PC6                 |t-test |2.00e-07 |3.152    |1.855   |4.449   |0.1443 |
|observer1                        |Hajar              |PC6                 |t-test |5.32e-03 |3.027    |0.615   |5.439   |0.0438 |
|observer1                        |Jeroen Burmanje    |PC6                 |t-test |1.72e-17 |-4.338   |-5.341  |-3.336  |0.3397 |
|dateofdcc2                       |                   |PC6                 |F-test |3.32e-06 |6.883    |        |        |0.8814 |
|dateofdcc2                       |14/01/2020         |PC6                 |t-test |1.31e-03 |-6.948   |-11.635 |-2.260  |0.1849 |
|observer2                        |                   |PC6                 |F-test |2.47e-06 |10.823   |        |        |0.4742 |
|observer2                        |Givaneide          |PC6                 |t-test |3.95e-03 |3.510    |0.879   |6.141   |0.1516 |
|observer2                        |Jeroen Burmanje    |PC6                 |t-test |6.18e-06 |-5.079   |-7.353  |-2.804  |0.3327 |
|monocytesmacrophages2            |                   |PC6                 |F-test |7.66e-03 |7.711    |        |        |0.1313 |
|Slide                            |                   |PC6                 |F-test |4.11e-26 |12.803   |        |        |0.6604 |
|Slide                            |205809360152       |PC6                 |t-test |1.59e-03 |4.259    |1.269   |7.249   |0.0540 |
|Slide                            |205809370069       |PC6                 |t-test |3.69e-03 |3.925    |0.922   |6.928   |0.0459 |
|Slide                            |205809370121       |PC6                 |t-test |1.26e-05 |-5.818   |-8.733  |-2.902  |0.1008 |
|Slide                            |205809370129       |PC6                 |t-test |1.73e-04 |-5.037   |-7.993  |-2.081  |0.0756 |
|Slide                            |205809370170       |PC6                 |t-test |6.77e-04 |-4.575   |-7.552  |-1.598  |0.0623 |
|Slide                            |205809370173       |PC6                 |t-test |5.69e-04 |-5.323   |-8.740  |-1.907  |0.0640 |
|Slide                            |205809380033       |PC6                 |t-test |3.16e-04 |-5.556   |-8.962  |-2.150  |0.0697 |
|Slide                            |205809380116       |PC6                 |t-test |6.39e-06 |-6.002   |-8.907  |-3.097  |0.1073 |
|Study_id                         |WASP104            |PC7                 |t-test |6.79e-03 |8.806    |1.557   |16.055  |0.0398 |
|Study_id                         |WASP115            |PC7                 |t-test |6.28e-03 |8.889    |1.643   |16.135  |0.0405 |
|studysubjectid                   |BR5582             |PC7                 |t-test |6.28e-03 |8.889    |1.643   |16.135  |0.0405 |
|studysubjectid                   |NG559              |PC7                 |t-test |6.79e-03 |8.806    |1.557   |16.055  |0.0398 |
|dateofsample1                    |11/05/2016         |PC7                 |t-test |6.70e-03 |8.841    |1.587   |16.096  |0.0560 |
|dateofsample1                    |12/09/2018         |PC7                 |t-test |6.19e-03 |8.924    |1.674   |16.175  |0.0571 |
|dateofdcc1                       |07/04/2017         |PC7                 |t-test |3.13e-03 |6.843    |1.694   |11.992  |0.0491 |
|eosinophilscount1                |                   |PC7                 |F-test |2.33e-03 |9.539    |        |        |0.0503 |
|eosinophils1                     |                   |PC7                 |F-test |1.57e-03 |10.300   |        |        |0.0541 |
|dateofsample2                    |18/12/2018         |PC7                 |t-test |9.93e-03 |8.355    |1.191   |15.519  |0.1417 |
|dateofdcc2                       |30/05/2020         |PC7                 |t-test |8.84e-03 |4.030    |0.637   |7.423   |0.1269 |
|eosinophilscount_epigen          |                   |PC7                 |F-test |1.19e-03 |10.844   |        |        |0.0565 |
|eosinophils_epigen               |                   |PC7                 |F-test |8.05e-04 |11.619   |        |        |0.0606 |
|Study_id                         |UGA_100            |PC8                 |t-test |9.95e-12 |-15.427  |-20.202 |-10.653 |0.2286 |
|Study_id                         |UGA_15             |PC8                 |t-test |5.09e-03 |6.007    |1.232   |10.782  |0.0430 |
|Study_id                         |UGA_99             |PC8                 |t-test |5.39e-11 |-14.795  |-19.570 |-10.020 |0.2142 |
|Study_id                         |WASP81             |PC8                 |t-test |8.86e-03 |5.514    |0.817   |10.211  |0.0379 |
|Sample_Well                      |A01                |PC8                 |t-test |3.30e-03 |4.379    |1.066   |7.692   |0.0475 |
|Sample_Well                      |E10                |PC8                 |t-test |4.38e-09 |-9.496   |-12.963 |-6.029  |0.1755 |
|Sample_Well                      |F10                |PC8                 |t-test |5.13e-07 |-8.304   |-11.895 |-4.712  |0.1317 |
|Sample_Well                      |H10                |PC8                 |t-test |9.74e-03 |-3.862   |-7.194  |-0.531  |0.0369 |
|uniquekey                        |                   |PC8                 |F-test |1.87e-07 |29.393   |        |        |0.1397 |
|studysubjectid                   |A0571              |PC8                 |t-test |5.09e-03 |6.007    |1.232   |10.782  |0.0430 |
|studysubjectid                   |A0678              |PC8                 |t-test |9.95e-12 |-15.427  |-20.202 |-10.653 |0.2286 |
|studysubjectid                   |A0679              |PC8                 |t-test |5.39e-11 |-14.795  |-19.570 |-10.020 |0.2142 |
|studysubjectid                   |MB1436             |PC8                 |t-test |8.86e-03 |5.514    |0.817   |10.211  |0.0379 |
|centre                           |                   |PC8                 |F-test |1.07e-08 |14.888   |        |        |0.1997 |
|centre                           |Brazil             |PC8                 |t-test |3.14e-10 |2.159    |1.437   |2.881   |0.1999 |
|centre                           |New Zealand        |PC8                 |t-test |6.32e-09 |-2.127   |-2.905  |-1.349  |0.1731 |
|acqscorecat                      |                   |PC8                 |F-test |5.38e-03 |7.987    |        |        |0.0522 |
|acqscorecat                      |Uncontrolled       |PC8                 |t-test |6.33e-03 |-1.516   |-2.742  |-0.290  |0.0506 |
|dateofsample1                    |16/07/2019         |PC8                 |t-test |9.07e-03 |5.371    |0.787   |9.955   |0.0520 |
|dateofdcc1                       |                   |PC8                 |F-test |4.54e-16 |6.030    |        |        |0.8386 |
|dateofdcc1                       |03/07/2020         |PC8                 |t-test |4.78e-03 |2.499    |0.530   |4.468   |0.0454 |
|dateofdcc1                       |07/11/2019         |PC8                 |t-test |1.11e-18 |-15.113  |-18.546 |-11.681 |0.3615 |
|dateofdcc1                       |11/12/2019         |PC8                 |t-test |1.17e-03 |-2.864   |-4.818  |-0.910  |0.0596 |
|dateofdcc1                       |13/05/2020         |PC8                 |t-test |1.24e-03 |-3.996   |-6.738  |-1.254  |0.0590 |
|observer1                        |                   |PC8                 |F-test |1.43e-07 |10.404   |        |        |0.1948 |
|observer1                        |Givaneide          |PC8                 |t-test |4.93e-10 |2.182    |1.445   |2.919   |0.2020 |
|observer1                        |Hajar              |PC8                 |t-test |1.09e-04 |-2.443   |-3.831  |-1.056  |0.0836 |
|observer1                        |Jeroen             |PC8                 |t-test |1.83e-04 |-1.655   |-2.625  |-0.686  |0.0784 |
|lymphocytes1                     |                   |PC8                 |F-test |7.07e-03 |7.425    |        |        |0.0396 |
|goodquality_sputum1              |Not good quality   |PC8                 |t-test |1.47e-03 |-1.980   |-3.358  |-0.602  |0.0557 |
|dateofsample2                    |26/02/2019         |PC8                 |t-test |9.78e-03 |5.367    |0.775   |9.959   |0.1422 |
|dateofdcc2                       |                   |PC8                 |F-test |2.21e-03 |3.217    |        |        |0.7765 |
|dateofdcc2                       |31/05/2020         |PC8                 |t-test |5.33e-03 |3.418    |0.721   |6.115   |0.1425 |
|observer2                        |                   |PC8                 |F-test |3.10e-06 |10.597   |        |        |0.4689 |
|observer2                        |Givaneide          |PC8                 |t-test |6.57e-06 |2.543    |1.397   |3.688   |0.3311 |
|observer2                        |Hajar              |PC8                 |t-test |2.74e-03 |-2.358   |-4.071  |-0.646  |0.1628 |
|totalcellcount2                  |                   |PC8                 |F-test |7.10e-03 |7.857    |        |        |0.1313 |
|bronchialepithelialcells2        |                   |PC8                 |F-test |8.92e-03 |7.394    |        |        |0.1266 |
|lymphocytes_epigen               |                   |PC8                 |F-test |5.64e-03 |7.850    |        |        |0.0418 |
|goodquality_epigen               |Not good quality   |PC8                 |t-test |1.88e-03 |-1.873   |-3.208  |-0.539  |0.0530 |
|Array                            |R01C01             |PC8                 |t-test |4.78e-03 |1.322    |0.284   |2.360   |0.0436 |
|Slide                            |                   |PC8                 |F-test |3.46e-21 |10.004   |        |        |0.6031 |
|Slide                            |205809360103       |PC8                 |t-test |1.18e-03 |2.452    |0.778   |4.126   |0.0575 |
|Slide                            |205809360147       |PC8                 |t-test |8.02e-05 |-3.156   |-4.915  |-1.396  |0.0839 |
|Slide                            |205809360162       |PC8                 |t-test |2.57e-04 |-2.933   |-4.704  |-1.163  |0.0725 |
|Slide                            |205809360173       |PC8                 |t-test |1.62e-10 |-5.770   |-7.684  |-3.856  |0.2036 |
|Slide                            |205809370061       |PC8                 |t-test |3.33e-04 |-2.703   |-4.366  |-1.040  |0.0700 |
|Slide                            |205809370069       |PC8                 |t-test |5.38e-05 |3.028    |1.381   |4.675   |0.0878 |
|Slide                            |205809380161       |PC8                 |t-test |3.32e-06 |3.528    |1.874   |5.183   |0.1141 |
|sentrix_row                      |01                 |PC8                 |t-test |4.78e-03 |1.322    |0.284   |2.360   |0.0436 |
|Study_id                         |190                |PC9                 |t-test |1.08e-04 |9.009    |3.879   |14.138  |0.0810 |
|Study_id                         |85                 |PC9                 |t-test |1.43e-05 |10.153   |5.023   |15.282  |0.1006 |
|Study_id                         |UGA_11             |PC9                 |t-test |4.28e-03 |6.452    |1.426   |11.479  |0.0452 |
|Study_id                         |UGA_119            |PC9                 |t-test |9.19e-04 |-7.669   |-12.798 |-2.540  |0.0600 |
|Study_id                         |WASP101            |PC9                 |t-test |5.19e-03 |-6.316   |-11.347 |-1.285  |0.0433 |
|Study_id                         |WASP110            |PC9                 |t-test |4.17e-03 |-6.471   |-11.497 |-1.445  |0.0454 |
|Study_id                         |WASP67             |PC9                 |t-test |5.89e-03 |-6.224   |-11.259 |-1.190  |0.0420 |
|Study_id                         |WASP85             |PC9                 |t-test |3.01e-04 |-8.389   |-13.518 |-3.260  |0.0710 |
|Sample_Well                      |D05                |PC9                 |t-test |1.08e-03 |5.488    |1.767   |9.208   |0.0585 |
|Sample_Well                      |D09                |PC9                 |t-test |8.45e-05 |-6.448   |-10.060 |-2.837  |0.0834 |
|Sample_Well                      |G11                |PC9                 |t-test |8.99e-03 |-4.192   |-7.769  |-0.615  |0.0379 |
|studysubjectid                   |A0625              |PC9                 |t-test |4.28e-03 |6.452    |1.426   |11.479  |0.0452 |
|studysubjectid                   |A0692              |PC9                 |t-test |9.19e-04 |-7.669   |-12.798 |-2.540  |0.0600 |
|studysubjectid                   |AQ7188             |PC9                 |t-test |1.43e-05 |10.153   |5.023   |15.282  |0.1006 |
|studysubjectid                   |AQ9557             |PC9                 |t-test |1.08e-04 |9.009    |3.879   |14.138  |0.0810 |
|studysubjectid                   |MB1439             |PC9                 |t-test |5.89e-03 |-6.224   |-11.259 |-1.190  |0.0420 |
|studysubjectid                   |MB1590             |PC9                 |t-test |4.17e-03 |-6.471   |-11.497 |-1.445  |0.0454 |
|studysubjectid                   |MB2113             |PC9                 |t-test |3.01e-04 |-8.389   |-13.518 |-3.260  |0.0710 |
|studysubjectid                   |MB2147             |PC9                 |t-test |5.19e-03 |-6.316   |-11.347 |-1.285  |0.0433 |
|dateofsample1                    |01/07/2019         |PC9                 |t-test |3.80e-04 |-8.446   |-13.677 |-3.215  |0.0957 |
|dateofsample1                    |15/02/2019         |PC9                 |t-test |4.25e-03 |-6.544   |-11.627 |-1.460  |0.0635 |
|dateofsample1                    |16/09/2018         |PC9                 |t-test |1.73e-04 |8.951    |3.720   |14.182  |0.1063 |
|dateofsample1                    |16/11/2018         |PC9                 |t-test |2.62e-05 |10.095   |4.864   |15.327  |0.1314 |
|dateofsample1                    |19/09/2019         |PC9                 |t-test |5.29e-03 |-6.388   |-11.480 |-1.297  |0.0606 |
|dateofdcc1                       |                   |PC9                 |F-test |6.73e-03 |1.699    |        |        |0.5941 |
|dateofdcc1                       |11/09/2019         |PC9                 |t-test |4.21e-03 |6.483    |1.443   |11.522  |0.0469 |
|dateofdcc1                       |12/05/2020         |PC9                 |t-test |7.59e-03 |-4.447   |-8.157  |-0.736  |0.0407 |
|dateofdcc1                       |18/05/2020         |PC9                 |t-test |5.53e-03 |-6.288   |-11.335 |-1.241  |0.0441 |
|dateofdcc1                       |23/11/2018         |PC9                 |t-test |6.28e-03 |-6.196   |-11.247 |-1.146  |0.0429 |
|dateofsample2                    |16/08/2019         |PC9                 |t-test |4.07e-04 |-6.794   |-10.897 |-2.691  |0.2497 |
|dateofdcc2                       |14/05/2020         |PC9                 |t-test |1.03e-03 |-6.927   |-11.502 |-2.353  |0.1955 |
|dateofdcc2                       |17/12/2019         |PC9                 |t-test |5.86e-03 |4.219    |0.849   |7.590   |0.1422 |
|Slide                            |205809360127       |PC9                 |t-test |3.09e-03 |-2.477   |-4.336  |-0.618  |0.0481 |
|Slide                            |205809360133       |PC9                 |t-test |6.39e-03 |2.224    |0.410   |4.038   |0.0413 |
|Slide                            |205809360152       |PC9                 |t-test |5.80e-03 |-2.327   |-4.203  |-0.451  |0.0420 |
|Study_id                         |163                |PC10                |t-test |7.24e-03 |4.445    |0.758   |8.133   |0.0424 |
|Study_id                         |190                |PC10                |t-test |2.37e-05 |7.243    |3.486   |11.000  |0.1012 |
|Study_id                         |85                 |PC10                |t-test |1.80e-04 |6.382    |2.625   |10.139  |0.0804 |
|Study_id                         |UGA_100            |PC10                |t-test |6.87e-04 |-5.762   |-9.519  |-2.005  |0.0665 |
|Study_id                         |UGA_11             |PC10                |t-test |5.76e-03 |-4.659   |-8.416  |-0.902  |0.0445 |
|Study_id                         |UGA_36             |PC10                |t-test |4.37e-07 |-8.760   |-12.517 |-5.003  |0.1413 |
|Study_id                         |UGA_99             |PC10                |t-test |2.77e-03 |-5.058   |-8.815  |-1.301  |0.0520 |
|Study_id                         |WASP104            |PC10                |t-test |1.61e-03 |-5.341   |-9.099  |-1.584  |0.0577 |
|Study_id                         |WASP109            |PC10                |t-test |1.41e-07 |9.158    |5.401   |12.915  |0.1525 |
|Study_id                         |WASP115            |PC10                |t-test |1.46e-03 |-5.390   |-9.147  |-1.633  |0.0587 |
|Study_id                         |WASP66             |PC10                |t-test |2.55e-10 |11.211   |7.454   |14.968  |0.2124 |
|Study_id                         |WASP69             |PC10                |t-test |8.65e-04 |5.650    |1.893   |9.407   |0.0641 |
|Study_id                         |WASP79             |PC10                |t-test |8.43e-05 |-6.713   |-10.470 |-2.956  |0.0882 |
|Study_id                         |WASP87             |PC10                |t-test |6.41e-08 |9.428    |5.671   |13.185  |0.1602 |
|Study_id                         |WASP97             |PC10                |t-test |4.22e-03 |4.832    |1.075   |8.589   |0.0477 |
|Sample_Well                      |B07                |PC10                |t-test |2.55e-10 |11.211   |7.454   |14.968  |0.2124 |
|Sample_Well                      |F09                |PC10                |t-test |1.05e-04 |4.897    |2.118   |7.677   |0.0859 |
|Sample_Well                      |F10                |PC10                |t-test |1.30e-04 |-4.584   |-7.223  |-1.945  |0.0837 |
|Sample_Well                      |F11                |PC10                |t-test |7.87e-07 |6.123    |3.432   |8.813   |0.1355 |
|Sample_Well                      |H05                |PC10                |t-test |5.47e-03 |-3.259   |-5.870  |-0.648  |0.0453 |
|Sample_Well                      |H08                |PC10                |t-test |1.65e-05 |-5.352   |-8.072  |-2.632  |0.1049 |
|studysubjectid                   |A0625              |PC10                |t-test |5.76e-03 |-4.659   |-8.416  |-0.902  |0.0445 |
|studysubjectid                   |A0639              |PC10                |t-test |4.37e-07 |-8.760   |-12.517 |-5.003  |0.1413 |
|studysubjectid                   |A0678              |PC10                |t-test |6.87e-04 |-5.762   |-9.519  |-2.005  |0.0665 |
|studysubjectid                   |A0679              |PC10                |t-test |2.77e-03 |-5.058   |-8.815  |-1.301  |0.0520 |
|studysubjectid                   |AQ7188             |PC10                |t-test |1.80e-04 |6.382    |2.625   |10.139  |0.0804 |
|studysubjectid                   |AQ9508             |PC10                |t-test |7.24e-03 |4.445    |0.758   |8.133   |0.0424 |
|studysubjectid                   |AQ9557             |PC10                |t-test |2.37e-05 |7.243    |3.486   |11.000  |0.1012 |
|studysubjectid                   |BR5582             |PC10                |t-test |1.46e-03 |-5.390   |-9.147  |-1.633  |0.0587 |
|studysubjectid                   |MB1134             |PC10                |t-test |8.43e-05 |-6.713   |-10.470 |-2.956  |0.0882 |
|studysubjectid                   |MB1263             |PC10                |t-test |6.41e-08 |9.428    |5.671   |13.185  |0.1602 |
|studysubjectid                   |MB1454             |PC10                |t-test |8.65e-04 |5.650    |1.893   |9.407   |0.0641 |
|studysubjectid                   |MB1897             |PC10                |t-test |2.55e-10 |11.211   |7.454   |14.968  |0.2124 |
|studysubjectid                   |NG335              |PC10                |t-test |4.22e-03 |4.832    |1.075   |8.589   |0.0477 |
|studysubjectid                   |NG464              |PC10                |t-test |1.41e-07 |9.158    |5.401   |12.915  |0.1525 |
|studysubjectid                   |NG559              |PC10                |t-test |1.61e-03 |-5.341   |-9.099  |-1.584  |0.0577 |
|dateofsample1                    |                   |PC10                |F-test |2.60e-03 |2.935    |        |        |0.9345 |
|dateofsample1                    |03/09/2018         |PC10                |t-test |1.46e-10 |11.480   |7.779   |15.180  |0.2929 |
|dateofsample1                    |05/07/2018         |PC10                |t-test |5.57e-03 |3.343    |0.664   |6.023   |0.0628 |
|dateofsample1                    |11/05/2016         |PC10                |t-test |2.39e-03 |-5.073   |-8.774  |-1.373  |0.0749 |
|dateofsample1                    |12/09/2018         |PC10                |t-test |2.18e-03 |-5.122   |-8.822  |-1.421  |0.0762 |
|dateofsample1                    |16/09/2018         |PC10                |t-test |1.09e-05 |7.511    |3.810   |11.212  |0.1506 |
|dateofsample1                    |16/11/2018         |PC10                |t-test |8.58e-05 |6.650    |2.949   |10.351  |0.1221 |
|dateofsample1                    |17/04/2018         |PC10                |t-test |1.37e-04 |-6.445   |-10.146 |-2.744  |0.1155 |
|dateofsample1                    |25/06/2019         |PC10                |t-test |3.03e-08 |9.696    |5.996   |13.397  |0.2281 |
|dateofsample1                    |27/04/2016         |PC10                |t-test |6.55e-08 |9.426    |5.725   |13.127  |0.2183 |
|dateofsample1                    |29/04/2016         |PC10                |t-test |2.27e-03 |5.100    |1.399   |8.801   |0.0756 |
|dateofdcc1                       |                   |PC10                |F-test |1.97e-04 |2.144    |        |        |0.6488 |
|dateofdcc1                       |07/11/2019         |PC10                |t-test |8.17e-06 |-5.440   |-8.103  |-2.777  |0.1152 |
|dateofdcc1                       |08/10/2019         |PC10                |t-test |4.50e-03 |2.375    |0.516   |4.233   |0.0490 |
|dateofdcc1                       |09/01/2020         |PC10                |t-test |7.77e-03 |4.416    |0.720   |8.112   |0.0432 |
|dateofdcc1                       |11/01/2019         |PC10                |t-test |3.31e-10 |11.181   |7.415   |14.948  |0.2169 |
|dateofdcc1                       |11/05/2020         |PC10                |t-test |1.73e-04 |4.765    |1.970   |7.561   |0.0836 |
|dateofdcc1                       |11/09/2019         |PC10                |t-test |5.58e-03 |-4.689   |-8.456  |-0.923  |0.0464 |
|dateofdcc1                       |16/01/2020         |PC10                |t-test |8.25e-05 |-6.744   |-10.510 |-2.977  |0.0915 |
|dateofdcc1                       |17/01/2020         |PC10                |t-test |9.51e-04 |5.620    |1.853   |9.386   |0.0654 |
|dateofdcc1                       |17/08/2016         |PC10                |t-test |1.69e-07 |9.128    |5.361   |12.894  |0.1558 |
|dateofdcc1                       |24/03/2017         |PC10                |t-test |4.56e-03 |4.802    |1.035   |8.568   |0.0486 |
|observer1                        |Givaneide          |PC10                |t-test |8.33e-03 |-0.777   |-1.426  |-0.129  |0.0419 |
|dateofsample2                    |18/07/2019         |PC10                |t-test |1.11e-03 |-6.419   |-10.661 |-2.176  |0.2260 |
|dateofsample2                    |18/10/2018         |PC10                |t-test |6.89e-03 |4.826    |0.898   |8.754   |0.1649 |
|dateofsample2                    |18/12/2018         |PC10                |t-test |8.11e-03 |-5.095   |-9.338  |-0.853  |0.1554 |
|dateofsample2                    |27/10/2017         |PC10                |t-test |6.39e-06 |9.453    |5.210   |13.695  |0.3877 |
|dateofdcc2                       |13/05/2020         |PC10                |t-test |2.85e-03 |-4.257   |-7.375  |-1.140  |0.1708 |
|dateofdcc2                       |25/05/2018         |PC10                |t-test |7.36e-06 |9.319    |5.047   |13.592  |0.3449 |
|Array                            |R08C01             |PC10                |t-test |2.40e-04 |-1.477   |-2.359  |-0.594  |0.0774 |
|Slide                            |205809360152       |PC10                |t-test |7.47e-03 |1.740    |0.293   |3.187   |0.0418 |
|Slide                            |205809360173       |PC10                |t-test |3.36e-03 |-1.845   |-3.241  |-0.448  |0.0498 |
|Slide                            |205809360176       |PC10                |t-test |4.59e-03 |1.693    |0.366   |3.019   |0.0471 |
|sentrix_row                      |08                 |PC10                |t-test |2.40e-04 |-1.477   |-2.359  |-0.594  |0.0774 |

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
##  [7] RSQLite_2.3.7           systemfonts_1.3.1       png_0.1-8              
## [10] vctrs_0.6.5             pkgconfig_2.0.3         crayon_1.5.3           
## [13] fastmap_1.2.0           XVector_0.42.0          labeling_0.4.3         
## [16] utf8_1.2.4              tzdb_0.4.0              nloptr_2.0.3           
## [19] bit_4.0.5               xfun_0.45               zlibbioc_1.48.2        
## [22] cachem_1.1.0            blob_1.2.4              highr_0.11             
## [25] cluster_2.1.6           R6_2.5.1                stringi_1.8.4          
## [28] RColorBrewer_1.1-3      boot_1.3-30             Rcpp_1.0.13            
## [31] splines_4.3.3           timechange_0.3.0        tidyselect_1.2.1       
## [34] dichromat_2.0-0.1       codetools_0.2-20        lattice_0.22-6         
## [37] Biobase_2.62.0          withr_3.0.0             KEGGREST_1.42.0        
## [40] S7_0.2.0                askpass_1.2.0           evaluate_0.24.0        
## [43] zip_2.3.1               Biostrings_2.70.3       pillar_1.9.0           
## [46] MatrixGenerics_1.14.0   generics_0.1.3          RCurl_1.98-1.16        
## [49] hms_1.1.3               commonmark_2.0.0        scales_1.4.0           
## [52] minqa_1.2.7             xtable_1.8-4            glue_1.7.0             
## [55] tools_4.3.3             annotate_1.80.0         locfit_1.5-9.10        
## [58] XML_3.99-0.17           grid_4.3.3              AnnotationDbi_1.64.1   
## [61] edgeR_4.0.16            base64_2.0.1            GenomeInfoDbData_1.2.11
## [64] cli_3.6.3               textshaping_0.3.7       fansi_1.0.6            
## [67] gtable_0.3.6            farver_2.1.2            memoise_2.0.1          
## [70] lifecycle_1.0.4         httr_1.4.7              mime_0.12              
## [73] openssl_2.2.0           bit64_4.0.5
```
