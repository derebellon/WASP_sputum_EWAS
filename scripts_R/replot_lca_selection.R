## =============================================================================
## Re-draw the LCA model-selection figure from the saved bootstrap CSV, WITHOUT
## re-running the (slow) latent class analysis.
##
## The number of classes was chosen a priori as 6: AIC is minimised at 6 and BIC
## is essentially tied between 5 and 6, so the dashed marker is placed at 6 (the
## retained solution) rather than at the raw BIC minimum.
##
## Run from the repository root (fast, no cluster job needed):
##   Rscript scripts_R/replot_lca_selection.R
## Override the marked solution with LCA_CHOSEN_K if ever needed.
## =============================================================================
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2)
})
source("scripts_R/00_config.R")

chosen_k <- as.integer(Sys.getenv("LCA_CHOSEN_K", unset = 6))
boot_csv <- file.path(LCA_TAB_DIR, "LCA_model_comparison_bootstrap.csv")
if (!file.exists(boot_csv)) stop("Bootstrap CSV not found: ", boot_csv)

boot_df   <- read.csv(boot_csv)
n_seeds   <- length(unique(boot_df$seed))
max_clust <- max(boot_df$nclass)

boot_long <- boot_df %>%
  tidyr::pivot_longer(cols = c(BIC, AIC), names_to = "Criterion", values_to = "Value")
mean_long <- boot_long %>%
  dplyr::group_by(Criterion, nclass) %>%
  dplyr::summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop")

# For transparency, report where each criterion is minimised on average.
mins <- mean_long %>% group_by(Criterion) %>% slice_min(Value, n = 1) %>% ungroup()
cat("Mean-criterion minima:\n"); print(mins)
cat("Marking chosen solution at k =", chosen_k, "\n")

p <- ggplot() +
  geom_line(data = boot_long,
            aes(nclass, Value, group = interaction(seed, Criterion)),
            colour = "grey80", linewidth = 0.3, alpha = 0.5) +
  geom_line(data = mean_long, aes(nclass, Value, color = Criterion), linewidth = 1.2) +
  geom_point(data = mean_long, aes(nclass, Value, color = Criterion), size = 2.6) +
  geom_vline(xintercept = chosen_k, linetype = "dashed", colour = "grey40") +
  scale_x_continuous(breaks = 2:max_clust) +
  labs(title = "LCA model selection",
       subtitle = sprintf("Mean BIC and AIC over %d random starts (grey lines: individual seeds); dashed line: retained %d-class solution",
                          n_seeds, chosen_k),
       x = "Number of classes", y = "Criterion value", color = "Metric") +
  theme_minimal()

out <- file.path(LCA_FIG_DIR, "LCA_model_comparison.png")
ggsave(out, p, width = 9, height = 6, dpi = 300)
cat("Saved:", out, "\n")
