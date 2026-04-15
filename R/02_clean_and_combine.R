# =============================================================================
# 02_clean_and_combine.R
# Combine 12 monthly CSVs, clean, and engineer analysis columns.
# Output: data/processed/trips_clean.rds
# =============================================================================

library(tidyverse)
library(lubridate)
library(here)
library(janitor)

raw_dir <- here("data", "raw")
csv_files <- list.files(raw_dir, pattern = "divvy-tripdata\\.csv$", full.names = TRUE)
stopifnot(length(csv_files) == 12)

message("Reading ", length(csv_files), " files ...")

# Force consistent column types — start_station_id and end_station_id are
# sometimes parsed as numeric on months with no alphanumeric ids, which
# breaks bind_rows. Read everything as character and coerce later.
col_types <- cols(
  ride_id            = col_character(),
  rideable_type      = col_character(),
  started_at         = col_datetime(format = ""),
  ended_at           = col_datetime(format = ""),
  start_station_name = col_character(),
  start_station_id   = col_character(),
  end_station_name   = col_character(),
  end_station_id     = col_character(),
  start_lat          = col_double(),
  start_lng          = col_double(),
  end_lat            = col_double(),
  end_lng            = col_double(),
  member_casual      = col_character()
)

trips_raw <- csv_files |>
  map_dfr(~ read_csv(.x, col_types = col_types, progress = FALSE)) |>
  clean_names()

message("Combined rows: ", scales::comma(nrow(trips_raw)))

# -----------------------------------------------------------------------------
# Cleaning
# -----------------------------------------------------------------------------
trips <- trips_raw |>
  mutate(
    ride_length_min = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week     = wday(started_at, label = TRUE, abbr = FALSE,
                           week_start = 1),
    hour_of_day     = hour(started_at),
    month           = floor_date(started_at, unit = "month"),
    season = case_when(
      month(started_at) %in% c(12, 1, 2)  ~ "Winter",
      month(started_at) %in% c(3, 4, 5)   ~ "Spring",
      month(started_at) %in% c(6, 7, 8)   ~ "Summer",
      month(started_at) %in% c(9, 10, 11) ~ "Fall"
    ),
    season = factor(season, levels = c("Winter", "Spring", "Summer", "Fall"))
  ) |>
  # Drop rides under 1 min (false starts/re-docks) and over 24 hrs (likely lost
  # bikes per Divvy documentation). Drop rows with missing timestamps.
  filter(
    !is.na(started_at), !is.na(ended_at),
    ride_length_min >= 1,
    ride_length_min <= 1440,
    member_casual %in% c("member", "casual")
  )

removed <- nrow(trips_raw) - nrow(trips)
message("Removed ", scales::comma(removed),
        " rows (", scales::percent(removed / nrow(trips_raw), 0.1), ")")
message("Final rows: ", scales::comma(nrow(trips)))

# Save the cleaned dataset
saveRDS(trips, here("data", "processed", "trips_clean.rds"))
message("Saved -> data/processed/trips_clean.rds")
