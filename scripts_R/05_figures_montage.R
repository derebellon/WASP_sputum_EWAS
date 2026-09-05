###############################################################################
# Script 05 — Merge Volcano & Manhattan plots by comparison groups (2-per-row)
#
# SUMMARY
# - Load already-exported PNGs (from Script 04) for each EWAS comparison.
# - For each macro-section (Asthma, Atopy, Severity, One-vs-Rest), build a
#   grid with a single section title and a panel of images arranged in a grid
#   of at most 2 images per row (automatic wrapping).
# - Save per-section merges (Volcano and Manhattan), and a stacked mega-merge
#   that places the 4 sections one under another (no overlapping).
# - Robust: skips missing images; if a section has none, draws a gray placeholder.
#
# What changed (fixes):
# - No more crowding all images on one row → we wrap to multiple rows (2 per row).
# - No overlapping titles: each section has its own title area; inside the grid
#   there are no extra titles drawn by 'grid'.
# - Viewport handling is explicit: no 'vp=' in grid.draw(); we push/pop viewports.
###############################################################################

# ---- Config ----
source("scripts_R/00_config.R")
report_dir <- EWAS_FIG_DIR

if (!requireNamespace("png", quietly = TRUE)) {
  stop("Package 'png' is required. Install it with: install.packages('png')")
}
suppressPackageStartupMessages(library(grid))

# ---- Label -> A-code map (Match con Script 04 actualizado) ----
code_map <- c(
  # A) ASTHMA
  "asthma_GLOBAL_vs_CONTROLS"             = "A1",
  "asthma_ATOPIC_vs_Control_Atopic"       = "A2",
  "asthma_NONATOPIC_vs_Control_NonAtopic" = "A3",
  
  # B) ATOPY
  "atopy_CONTROLS_C6_vs_C4"               = "A4",
  "atopy_IN_ASTHMA"                       = "A5",
  "atopy_GLOBAL"                          = "A6",
  
  # C) SEVERITY
  "severity_INDEPENDENT"                  = "A7",
  "severity_ATOPIC_C1_vs_C3"              = "A8",
  
  # D) ONE vs REST
  "phenotype_signature_C1_vs_rest"        = "A9",
  "phenotype_signature_C2_vs_rest"        = "A10",
  "phenotype_signature_C3_vs_rest"        = "A11",
  "phenotype_signature_C4_vs_rest"        = "A12",
  "phenotype_signature_C5_vs_rest"        = "A13",
  "phenotype_signature_C6_vs_rest"        = "A14"
)

# ---- Groups (macro-sections) ----
groups <- list(
  "Asthma signatures (A1–A3)" = c(
    "asthma_GLOBAL_vs_CONTROLS",
    "asthma_ATOPIC_vs_Control_Atopic",
    "asthma_NONATOPIC_vs_Control_NonAtopic"
  ),
  "Atopy signatures (A4–A6)" = c(
    "atopy_CONTROLS_C6_vs_C4",
    "atopy_IN_ASTHMA",
    "atopy_GLOBAL"
  ),
  "Severity/control signatures (A7–A8)" = c(
    "severity_INDEPENDENT",
    "severity_ATOPIC_C1_vs_C3"
  ),
  "Phenotype-specific (one-vs-rest) (A9–A14)" = c(
    "phenotype_signature_C1_vs_rest",
    "phenotype_signature_C2_vs_rest",
    "phenotype_signature_C3_vs_rest",
    "phenotype_signature_C4_vs_rest",
    "phenotype_signature_C5_vs_rest",
    "phenotype_signature_C6_vs_rest"
  )
)

# ---- Resolve file paths (prefer A#; fallback to legacy) ----
plot_path <- function(type = c("VOLCANO","MANHATTAN"), label) {
  type <- match.arg(type)
  code <- unname(code_map[label])
  if (!is.na(code)) {
    p1 <- file.path(report_dir, paste0(type, "_", code, "_", label, ".png"))
    if (file.exists(p1)) return(p1)
  }
  p2 <- file.path(report_dir, paste0(type, "_", label, ".png"))
  if (file.exists(p2)) return(p2)
  NA_character_
}

# ---- Read PNG as grob ----
png_to_grob <- function(path) {
  img <- png::readPNG(path)
  grid::rasterGrob(image = img, interpolate = TRUE)
}

# ---- Draw a section (title + grid of images with <= 2 per row) ----
# Arguments:
#   title              : character (section title)
#   img_paths          : character vector of file paths (may include NA/missing)
#   ncol               : max images per row (fixed to 2 as requested)
#   newpage            : TRUE for standalone output; FALSE when inside a parent layout
#   title_frac         : fraction of section height reserved for title (0-1)
draw_section <- function(title, img_paths, ncol = 2,
                         newpage = TRUE, title_frac = 0.12) {
  ok <- !is.na(img_paths) & file.exists(img_paths)
  img_paths <- img_paths[ok]
  n <- length(img_paths)
  
  # New page (only when drawing standalone)
  if (newpage) grid.newpage()
  
  # If no images: draw placeholder section
  if (n == 0) {
    pushViewport(viewport(layout = grid.layout(2, 1,
                                               heights = unit.c(unit(title_frac, "npc"), unit(1 - title_frac, "npc"))
    )))
    grid.text(title, gp = gpar(fontsize = 16, fontface = "bold"),
              vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
    pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1))
    grid.rect(gp = gpar(col = NA, fill = "grey95"))
    grid.text("No images found for this section", gp = gpar(col = "grey40", fontsize = 12))
    upViewport(2)
    return(invisible(NULL))
  }
  
  # Number of rows given max 2 per row
  nrow <- ceiling(n / ncol)
  
  # Section layout: row 1 = title; rows 2..(nrow+1) = image rows
  pushViewport(viewport(layout = grid.layout(
    nrow = nrow + 1, ncol = 1,
    heights = unit.c(unit(title_frac, "npc"),
                     rep(unit((1 - title_frac) / nrow, "npc"), nrow))
  )))
  
  # Title
  grid.text(title, gp = gpar(fontsize = 16, fontface = "bold"),
            vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  
  # Image rows
  idx <- 0L
  for (r in seq_len(nrow)) {
    pushViewport(viewport(layout.pos.row = r + 1, layout.pos.col = 1))
    # within this row, create a 1 x ncol grid; empty cells remain blank
    pushViewport(viewport(layout = grid.layout(1, ncol)))
    for (c in seq_len(ncol)) {
      idx <- idx + 1L
      pushViewport(viewport(layout.pos.row = 1, layout.pos.col = c))
      if (idx <= n) {
        gp <- png_to_grob(img_paths[idx])
        grid.draw(gp)
      } else {
        # draw blank cell (optional frame for symmetry)
        grid.rect(gp = gpar(col = NA, fill = NA))
      }
      upViewport() # leave cell
    }
    upViewport()   # leave 1 x ncol grid
    upViewport()   # leave row r
  }
  upViewport()     # leave section
}

# ---- Save a single-section image (title + grid) ----
save_section <- function(title, img_paths, outfile,
                         width_px = 2600, row_height_px = 900,
                         ncol = 2, title_frac = 0.12, res = 150) {
  # Height scales with number of rows (<=2 per row)
  n <- sum(!is.na(img_paths) & file.exists(img_paths))
  n_rows <- max(1L, ceiling(n / ncol))
  height_px <- as.integer(title_frac * row_height_px + (1 - title_frac) * row_height_px * n_rows)
  
  dir.create(dirname(outfile), showWarnings = FALSE, recursive = TRUE)
  png(filename = outfile, width = width_px, height = height_px, res = res)
  on.exit(dev.off(), add = TRUE)
  draw_section(title, img_paths, ncol = ncol, newpage = TRUE, title_frac = title_frac)
  message("[SECTION] Wrote: ", outfile)
}

# ---- Save a stacked mega-merge (four sections, each with its own rows) ----
save_mega_merge <- function(named_paths_list, outfile,
                            width_px = 2800, row_height_px = 900,
                            ncol = 2, title_frac = 0.12, res = 150) {
  
  # Compute per-section row counts and total height
  section_info <- lapply(named_paths_list, function(paths) {
    n <- sum(!is.na(paths) & file.exists(paths))
    rows <- max(1L, ceiling(n / ncol))
    list(n = n, rows = rows)
  })
  
  # height of each section = title strip + rows * row_height_px
  heights_px <- vapply(section_info, function(x)
    as.integer(title_frac * row_height_px + (1 - title_frac) * row_height_px * x$rows),
    integer(1))
  
  total_h <- sum(heights_px)
  dir.create(dirname(outfile), showWarnings = FALSE, recursive = TRUE)
  png(filename = outfile, width = width_px, height = total_h, res = res)
  on.exit(dev.off(), add = TRUE)
  
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(nrow = length(named_paths_list), ncol = 1,
                                             heights = unit(heights_px, "points"))))
  
  r <- 0
  for (nm in names(named_paths_list)) {
    r <- r + 1
    pushViewport(viewport(layout.pos.row = r, layout.pos.col = 1))
    draw_section(nm, named_paths_list[[nm]], ncol = ncol,
                 newpage = FALSE, title_frac = title_frac)
    upViewport()
  }
  message("[MEGA] Wrote: ", outfile)
}

# ---- Helper to collect paths for a group/type ----
collect_paths_for_group <- function(type, labels) {
  vapply(labels, function(lb) plot_path(type, lb), character(1))
}

# =========================
# BUILD & SAVE
# =========================

# 1) Per-section merges — VOLCANO (2 per row)
volcano_sections <- list()
for (gname in names(groups)) {
  labs  <- groups[[gname]]
  paths <- collect_paths_for_group("VOLCANO", labs)
  volcano_sections[[gname]] <- paths
  tag <- switch(gname,
                "Asthma signatures (A1–A3)"                  = "ASTHMA_A1A3",
                "Atopy signatures (A4–A6)"                   = "ATOPY_A4A6",
                "Severity/control signatures (A7–A8)"       = "SEVERITY_A7A8",
                "Phenotype-specific (one-vs-rest) (A9–A14)" = "ONEvsREST_A9A14",
                gsub("[^A-Za-z0-9]+", "_", gname)
  )
  out <- file.path(report_dir, paste0("VOLCANO_MERGE_", tag, ".png"))
  save_section(paste0(gname, " — Volcano"), paths, out, ncol = 2)
}

# 2) Mega-merge — VOLCANO (stack all four sections)
volcano_mega_out <- file.path(report_dir, "VOLCANO_MERGE_ALL_GROUPS.png")
save_mega_merge(volcano_sections, volcano_mega_out, ncol = 2)

# 3) Per-section merges — MANHATTAN (2 per row)
manhattan_sections <- list()
for (gname in names(groups)) {
  labs  <- groups[[gname]]
  paths <- collect_paths_for_group("MANHATTAN", labs)
  manhattan_sections[[gname]] <- paths
  tag <- switch(gname,
                "Asthma signatures (A1–A3)"                  = "ASTHMA_A1A3",
                "Atopy signatures (A4–A6)"                   = "ATOPY_A4A6",
                "Severity/control signatures (A7–A8)"       = "SEVERITY_A7A8",
                "Phenotype-specific (one-vs-rest) (A9–A14)" = "ONEvsREST_A9A14",
                gsub("[^A-Za-z0-9]+", "_", gname)
  )
  out <- file.path(report_dir, paste0("MANHATTAN_MERGE_", tag, ".png"))
  save_section(paste0(gname, " — Manhattan"), paths, out, ncol = 2)
}

# 4) Mega-merge — MANHATTAN (stack all four sections)
manhattan_mega_out <- file.path(report_dir, "MANHATTAN_MERGE_ALL_GROUPS.png")
save_mega_merge(manhattan_sections, manhattan_mega_out, ncol = 2)

###############################################################################
# FINAL SUMMARY (generated outputs under report_dir)
# - Per-section PNGs (2-per-row inside the section):
#     VOLCANO_MERGE_ASTHMA_A1A3.png
#     VOLCANO_MERGE_ATOPY_A4A6.png
#     VOLCANO_MERGE_SEVERITY_A7A8.png
#     VOLCANO_MERGE_ONEvsREST_A9A14.png
#     MANHATTAN_MERGE_ASTHMA_A1A3.png
#     MANHATTAN_MERGE_ATOPY_A4A6.png
#     MANHATTAN_MERGE_SEVERITY_A7A8.png
#     MANHATTAN_MERGE_ONEvsREST_A9A14.png
# - Mega-merges (all four sections stacked, each with its own grid and title):
#     VOLCANO_MERGE_ALL_GROUPS.png
#     MANHATTAN_MERGE_ALL_GROUPS.png
#
# Notes:
# - Height scales automatically with the number of rows needed (2 images per row).
# - If a section has no images, a gray placeholder is drawn instead.
###############################################################################
