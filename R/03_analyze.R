# =============================================================================
# 03_analyze.R
# Descriptive analysis comparing members vs casual riders.
# Output: data/processed/summary_*.csv files
# =============================================================================

library(tidyverse)
library(here)
library(scales)

trips <- readRDS(here("data", "processed", "trips_clean.rds"))

# -----------------------------------------------------------------------------
# 1. Headline numbers
# -----------------------------------------------------------------------------
overview <- trips |>
  group_by(member_casual) |>
  summarise(
    rides            = n(),
    avg_ride_min     = mean(ride_length_min),
    median_ride_min  = median(ride_length_min),
    max_ride_min     = max(ride_length_min),
    .groups = "drop"
  ) |>
  mutate(share_of_rides = rides / sum(rides))

write_csv(overview, here("data", "processed", "summary_overview.csv"))
print(overview)

# -----------------------------------------------------------------------------
# 2. Day-of-week pattern
# -----------------------------------------------------------------------------
by_dow <- trips |>
  group_by(member_casual, day_of_week) |>
  summarise(
    rides        = n(),
    avg_ride_min = mean(ride_length_min),
    .groups = "drop"
  )

write_csv(by_dow, here("data", "processed", "summary_by_dow.csv"))

# -----------------------------------------------------------------------------
# 3. Hour-of-day pattern
# -----------------------------------------------------------------------------
by_hour <- trips |>
  group_by(member_casual, hour_of_day) |>
  summarise(rides = n(), .groups = "drop")

write_csv(by_hour, here("data", "processed", "summary_by_hour.csv"))

# -----------------------------------------------------------------------------
# 4. Seasonality / monthly trend
# -----------------------------------------------------------------------------
by_month <- trips |>
  group_by(member_casual, month) |>
  summarise(rides = n(), .groups = "drop")

write_csv(by_month, here("data", "processed", "summary_by_month.csv"))

by_season <- trips |>
  group_by(member_casual, season) |>
  summarise(
    rides        = n(),
    avg_ride_min = mean(ride_length_min),
    .groups = "drop"
  )

write_csv(by_season, here("data", "processed", "summary_by_season.csv"))

# -----------------------------------------------------------------------------
# 5. Bike type preference
# -----------------------------------------------------------------------------
by_bike <- trips |>
  group_by(member_casual, rideable_type) |>
  summarise(rides = n(), .groups = "drop") |>
  group_by(member_casual) |>
  mutate(share = rides / sum(rides)) |>
  ungroup()

write_csv(by_bike, here("data", "processed", "summary_by_bike.csv"))

# -----------------------------------------------------------------------------
# 6. Top start stations for casual riders (conversion-targeting opportunity)
# -----------------------------------------------------------------------------
top_casual_stations <- trips |>
  filter(member_casual == "casual", !is.na(start_station_name)) |>
  count(start_station_name, sort = TRUE) |>
  slice_head(n = 15)

write_csv(top_casual_stations,
          here("data", "processed", "top_casual_stations.csv"))

message("Analysis complete. Summaries written to data/processed/")
