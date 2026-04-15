# =============================================================================
# run_all.R — orchestrate the full pipeline
# =============================================================================
library(here)

source(here("R", "01_download_data.R"))
source(here("R", "02_clean_and_combine.R"))
source(here("R", "03_analyze.R"))
source(here("R", "04_visualize.R"))

message("\nPipeline complete. See output/figures/ for charts and ",
        "data/processed/ for summary CSVs.")
