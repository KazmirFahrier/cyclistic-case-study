# =============================================================================
# 04_visualize.R
# Build polished ggplot charts for the report.
# Output: output/figures/*.png
# =============================================================================

library(tidyverse)
library(here)
library(scales)

fig_dir <- here("output", "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# Brand palette — Cyclistic-style teal vs. coral for casual
pal <- c(member = "#1F77B4", casual = "#FF7F0E")

theme_cyclistic <- function() {
  theme_minimal(base_size = 13) +
    theme(
      plot.title       = element_text(face = "bold", size = 16),
      plot.subtitle    = element_text(color = "grey30", margin = margin(b = 10)),
      plot.caption     = element_text(color = "grey50", size = 9, hjust = 0),
      legend.position  = "top",
      legend.title     = element_blank(),
      panel.grid.minor = element_blank()
    )
}

caption_txt <- "Source: Divvy / Lyft public trip data, Nov 2024 – Oct 2025"

save_fig <- function(plot, name, w = 9, h = 5.5) {
  ggsave(file.path(fig_dir, name), plot, width = w, height = h, dpi = 200, bg = "white")
}

# -----------------------------------------------------------------------------
# Chart 1 — Rides by day of week
# -----------------------------------------------------------------------------
by_dow <- read_csv(here("data", "processed", "summary_by_dow.csv"),
                   show_col_types = FALSE) |>
  mutate(day_of_week = factor(
    day_of_week,
    levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
  ))

p1 <- ggplot(by_dow, aes(day_of_week, rides, fill = member_casual)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.75) +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = pal) +
  labs(
    title    = "Members ride on weekdays. Casuals ride on weekends.",
    subtitle = "Ride volume by rider type and day of week",
    x = NULL, y = "Rides",
    caption  = caption_txt
  ) +
  theme_cyclistic()

save_fig(p1, "01_rides_by_dow.png")

# -----------------------------------------------------------------------------
# Chart 2 — Average ride length by day of week
# -----------------------------------------------------------------------------
p2 <- ggplot(by_dow, aes(day_of_week, avg_ride_min, fill = member_casual)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.75) +
  scale_fill_manual(values = pal) +
  labs(
    title    = "Casual rides last roughly twice as long as member rides.",
    subtitle = "Average ride length (minutes) by rider type and day of week",
    x = NULL, y = "Avg ride length (min)",
    caption  = caption_txt
  ) +
  theme_cyclistic()

save_fig(p2, "02_avg_length_by_dow.png")

# -----------------------------------------------------------------------------
# Chart 3 — Hourly ridership pattern
# -----------------------------------------------------------------------------
by_hour <- read_csv(here("data", "processed", "summary_by_hour.csv"),
                    show_col_types = FALSE)

p3 <- ggplot(by_hour, aes(hour_of_day, rides, color = member_casual)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 1.5) +
  scale_color_manual(values = pal) +
  scale_x_continuous(breaks = seq(0, 23, 3)) +
  scale_y_continuous(labels = comma) +
  labs(
    title    = "Members commute. Casuals cruise.",
    subtitle = "Members peak at 8 AM and 5 PM. Casuals build steadily into the afternoon.",
    x = "Hour of day", y = "Rides",
    caption  = caption_txt
  ) +
  theme_cyclistic()

save_fig(p3, "03_rides_by_hour.png")

# -----------------------------------------------------------------------------
# Chart 4 — Monthly trend
# -----------------------------------------------------------------------------
by_month <- read_csv(here("data", "processed", "summary_by_month.csv"),
                     show_col_types = FALSE)

p4 <- ggplot(by_month, aes(month, rides, color = member_casual)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = pal) +
  scale_y_continuous(labels = comma) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") +
  labs(
    title    = "Both groups peak in summer, but casual ridership swings harder.",
    subtitle = "Monthly ride volume by rider type",
    x = NULL, y = "Rides",
    caption  = caption_txt
  ) +
  theme_cyclistic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

save_fig(p4, "04_rides_by_month.png")

# -----------------------------------------------------------------------------
# Chart 5 — Bike type preference
# -----------------------------------------------------------------------------
by_bike <- read_csv(here("data", "processed", "summary_by_bike.csv"),
                    show_col_types = FALSE)

p5 <- ggplot(by_bike, aes(rideable_type, share, fill = member_casual)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.75) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = pal) +
  labs(
    title    = "Bike type preference by rider segment",
    subtitle = "Share of each segment's rides by bike type",
    x = NULL, y = "Share of rides",
    caption  = caption_txt
  ) +
  theme_cyclistic()

save_fig(p5, "05_bike_type.png")

# -----------------------------------------------------------------------------
# Chart 6 — Top 15 casual start stations
# -----------------------------------------------------------------------------
top_stations <- read_csv(here("data", "processed", "top_casual_stations.csv"),
                         show_col_types = FALSE)

p6 <- ggplot(top_stations,
             aes(x = n, y = fct_reorder(start_station_name, n))) +
  geom_col(fill = pal["casual"]) +
  scale_x_continuous(labels = comma) +
  labs(
    title    = "Casual riders concentrate at lakefront and tourist stations.",
    subtitle = "Top 15 start stations for casual riders",
    x = "Casual rides", y = NULL,
    caption  = caption_txt
  ) +
  theme_cyclistic()

save_fig(p6, "06_top_casual_stations.png", h = 6.5)

message("Saved ", length(list.files(fig_dir)), " figures to output/figures/")
