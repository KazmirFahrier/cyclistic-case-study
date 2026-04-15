# =============================================================================
# 01_download_data.R
# Cyclistic Case Study — Download 12 months of Divvy trip data
# Window: November 2024 through October 2025 (most recent 12 months)
# =============================================================================

library(here)

# Create folders if they don't exist
dir.create(here("data", "raw"), showWarnings = FALSE, recursive = TRUE)
dir.create(here("data", "processed"), showWarnings = FALSE, recursive = TRUE)

# Months to pull: Nov 2024 -> Oct 2025
months <- c(
  "202411", "202412",
  "202501", "202502", "202503", "202504", "202505", "202506",
  "202507", "202508", "202509", "202510"
)

base_url <- "https://divvy-tripdata.s3.amazonaws.com/"

for (m in months) {
  zip_name  <- paste0(m, "-divvy-tripdata.zip")
  zip_path  <- here("data", "raw", zip_name)
  csv_name  <- paste0(m, "-divvy-tripdata.csv")
  csv_path  <- here("data", "raw", csv_name)

  if (file.exists(csv_path)) {
    message("Already have ", csv_name, " — skipping.")
    next
  }

  message("Downloading ", zip_name, " ...")
  download.file(
    url      = paste0(base_url, zip_name),
    destfile = zip_path,
    mode     = "wb"
  )

  unzip(zip_path, exdir = here("data", "raw"))
  file.remove(zip_path)
}

message("Done. Files available in data/raw/")
