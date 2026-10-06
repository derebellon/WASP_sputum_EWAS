###############################################################################

# Script 04b — EWAS Summary and Unions (Reduce step)

# (Corre SOLO CUANDO EL JOB ARRAY ESTÉ 100% TERMINADO)

###############################################################################



library(dplyr)

library(readr)

library(purrr)

library(tibble)

library(tidyr)



source("scripts_R/00_config.R")
report_dir <- EWAS_TAB_DIR



cat("Recolectando resultados para Uniones...\n")



inputs_labels <- c("asthma_GLOBAL_vs_CONTROLS", "asthma_ATOPIC_vs_Control_Atopic", "asthma_NONATOPIC_vs_Control_NonAtopic", "atopy_CONTROLS_C6_vs_C4", "atopy_IN_ASTHMA", "atopy_GLOBAL", "severity_INDEPENDENT", "severity_ATOPIC_C1_vs_C3", "phenotype_signature_C1_vs_rest", "phenotype_signature_C2_vs_rest", "phenotype_signature_C3_vs_rest", "phenotype_signature_C4_vs_rest", "phenotype_signature_C5_vs_rest", "phenotype_signature_C6_vs_rest")



code_map <- c("asthma_GLOBAL_vs_CONTROLS"="A1", "asthma_ATOPIC_vs_Control_Atopic"="A2", "asthma_NONATOPIC_vs_Control_NonAtopic"="A3", "atopy_CONTROLS_C6_vs_C4"="A4", "atopy_IN_ASTHMA"="A5", "atopy_GLOBAL"="A6", "severity_INDEPENDENT"="A7", "severity_ATOPIC_C1_vs_C3"="A8", "phenotype_signature_C1_vs_rest"="A9", "phenotype_signature_C2_vs_rest"="A10", "phenotype_signature_C3_vs_rest"="A11", "phenotype_signature_C4_vs_rest"="A12", "phenotype_signature_C5_vs_rest"="A13", "phenotype_signature_C6_vs_rest"="A14")



results_long <- bind_rows(lapply(inputs_labels, function(lbl) {
  
  code <- code_map[lbl]
  
  file_path <- file.path(report_dir, paste0("EWAS_", code, "_", lbl, ".csv"))
  
  if(!file.exists(file_path)) stop("ERROR: Falta archivo ", file_path, ". ¿Terminó el Job Array?")
  
  
  
  df <- read_csv(file_path, show_col_types = FALSE)
  
  tibble(
    
    comparison = lbl,
    
    probeID    = df$probeID,
    
    beta       = as.numeric(df$beta),
    
    p          = as.numeric(df$p),
    
    fdr        = as.numeric(df$fdr),
    
    chromosome = suppressWarnings(as.integer(df$chromosome)),
    
    position   = suppressWarnings(as.numeric(df$position)),
    
    gene       = as.character(df$gene)
    
  )
  
}))



union_by_set <- function(res_long, set_vec) {
  
  passed <- res_long %>% filter(comparison %in% set_vec, is.finite(fdr), fdr < 0.20)
  
  if (nrow(passed) == 0) return(list(union_tbl = tibble(), union_summary = tibble()))
  
  
  
  best_per_probe <- passed %>% arrange(probeID, fdr, p) %>% group_by(probeID) %>% slice(1) %>% ungroup()
  
  n_pass <- passed %>% count(probeID, name = "n_comparisons_pass")
  
  
  
  union_tbl <- best_per_probe %>% left_join(n_pass, by = "probeID") %>%
    
    transmute(probeID, best_comparison = comparison, min_fdr = fdr, min_p = p, n_comparisons_pass, beta_best = beta, gene, chromosome, position) %>% arrange(min_fdr, min_p)
  
  
  
  counts <- union_tbl %>% summarise(
    
    n_FDR_lt_0_20 = sum(is.finite(min_fdr) & min_fdr < 0.20),
    
    n_FDR_lt_0_10 = sum(is.finite(min_fdr) & min_fdr < 0.10),
    
    n_FDR_lt_0_05 = sum(is.finite(min_fdr) & min_fdr < 0.05),
    
    n_Hits_05_Beta01 = sum(is.finite(min_fdr) & min_fdr < 0.05 & abs(beta_best) > 0.01),
    
    n_p_lt_0_10   = sum(is.finite(min_p) & min_p < 0.10),
    
    n_p_lt_0_20   = sum(is.finite(min_p) & min_p < 0.20)
    
  )
  
  
  
  tops <- lapply(set_vec, function(cmp) {
    
    sub <- res_long %>% filter(comparison == cmp, is.finite(fdr), fdr < 0.20) %>% arrange(desc(abs(beta)), p)
    
    list(cmp = cmp, cpgs = paste(head(sub$probeID, 10), collapse=", "), genes = paste(unique(head(sub$gene[!is.na(sub$gene) & sub$gene != ""], 10)), collapse=", "))
    
  })
  
  
  
  union_summary <- counts %>% mutate(
    
    comparisons_included = paste(set_vec, collapse = " + "),
    
    top10_cpgs_por_comparacion = paste0(vapply(tops, function(x) paste0(x$cmp, ": ", x$cpgs), ""), collapse = " | "),
    
    top10_genes_por_comparacion= paste0(vapply(tops, function(x) paste0(x$cmp, ": ", x$genes), ""), collapse = " | ")
    
  )
  
  list(union_tbl = union_tbl, union_summary = union_summary)
  
}



save_union_outputs <- function(union_code, union_name, res_list) {
  
  union_tbl <- res_list$union_tbl; union_summary <- res_list$union_summary
  
  write_csv(union_tbl, file.path(report_dir, paste0("EWAS_", union_code, "_UNION_list.csv")))
  
  write_csv(union_summary, file.path(report_dir, paste0("EWAS_", union_code, "_UNION_summary.csv")))
  
  
  
  md_path <- file.path(report_dir, paste0("Table_", union_code, "_UNION_summary.md"))
  
  if (nrow(union_summary) == 0) {
    
    writeLines(c(paste0("# ", union_name, " (", union_code, ")"), "", "**No significant CpGs found (FDR < 0.20)**"), md_path)
    
  } else {
    
    hdr <- c("comparisons_included","n_FDR_lt_0_20","n_FDR_lt_0_10","n_FDR_lt_0_05", "n_Hits_05_Beta01", "n_p_lt_0_10","n_p_lt_0_20","top10_cpgs_por_comparacion","top10_genes_por_comparacion")
    
    vals <- paste(union_summary %>% select(all_of(hdr)) %>% slice(1) %>% as.character(), collapse = " | ")
    
    writeLines(c(paste0("# ", union_name, " (", union_code, ")"), "", paste0("| ", paste(hdr, collapse=" | "), " |"), paste0("| ", paste(rep("-", length(hdr)), collapse=" | "), " |"), paste0("| ", vals, " |")), md_path)
    
  }
  
}



save_union_outputs("SUM_ASTHMA", "Asthma summary (SUMA de A1+A2+A3)", union_by_set(results_long, c("asthma_GLOBAL_vs_CONTROLS", "asthma_ATOPIC_vs_Control_Atopic", "asthma_NONATOPIC_vs_Control_NonAtopic")))

save_union_outputs("SUM_ATOPY", "Atopy summary (SUMA de A4+A5+A6)", union_by_set(results_long, c("atopy_CONTROLS_C6_vs_C4", "atopy_IN_ASTHMA", "atopy_GLOBAL")))

save_union_outputs("SUM_SEVERITY", "Severity summary (SUMA de A7+A8)", union_by_set(results_long, c("severity_INDEPENDENT", "severity_ATOPIC_C1_vs_C3")))

save_union_outputs("SUM_ONEVSREST", "One-vs-rest summary (SUMA de A9–A14)", union_by_set(results_long, c("phenotype_signature_C1_vs_rest", "phenotype_signature_C2_vs_rest", "phenotype_signature_C3_vs_rest", "phenotype_signature_C4_vs_rest", "phenotype_signature_C5_vs_rest", "phenotype_signature_C6_vs_rest")))



summary_all <- bind_rows(lapply(inputs_labels, function(lbl) {
  
  read_csv(file.path(report_dir, paste0("EWAS_", code_map[lbl], "_", lbl, "_SUMMARY.csv")), show_col_types = FALSE)
  
})) %>% arrange(comparison)



write_csv(summary_all, file.path(report_dir, "EWAS_SUMMARY_A1_to_A14.csv"))

cat("\n[✓] All Summaries and Unions complete!\n")