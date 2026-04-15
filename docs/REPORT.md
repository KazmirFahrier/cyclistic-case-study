# Cyclistic Bike-Share: How Members and Casual Riders Differ

**Author:** Kazmir Fahrier
**Role:** Junior Data Analyst, Cyclistic Marketing Analytics Team
**Date:** April 2026
**Tools:** R · tidyverse · ggplot2

---

## 1. Business Task

Cyclistic's marketing director, Lily Moreno, believes future growth depends on converting **casual riders** (single-ride and full-day pass users) into **annual members**, who are significantly more profitable. To design a targeted conversion campaign, the marketing team needs a clear, evidence-backed answer to one question:

> **How do annual members and casual riders use Cyclistic bikes differently?**

This report answers that question using 12 months of historical trip data and translates the findings into three concrete recommendations the executive team can act on.

---

## 2. Data Sources

| Item | Detail |
|------|--------|
| Provider | Divvy / Lyft (Cyclistic is a fictional stand-in) |
| Period | November 2024 – October 2025 (12 months) |
| Files | 12 monthly CSVs from `divvy-tripdata.s3.amazonaws.com` |
| Volume | ~5M+ trip records, 13 fields each |
| License | [Divvy Data License Agreement](https://divvybikes.com/data-license-agreement) |
| PII | None — all rider identifiers anonymized |

**ROCCC check:** Reliable (operator-owned), Original (first-party), Comprehensive (all rides), Current (monthly updates), Cited (clear license). The data is fit for the business question.

**Known limitation:** Without rider-level identifiers, we cannot tell whether a "casual" rider is a one-time tourist or a repeat customer who could plausibly convert. This shapes how aggressively we can interpret station-level findings.

---

## 3. Data Preparation

All processing is in R using the tidyverse. The full pipeline lives in [`R/`](../R/) and runs end-to-end via `source("R/run_all.R")`.

**Cleaning steps (`R/02_clean_and_combine.R`):**

1. Read all 12 CSVs with explicit column types to avoid type-coercion errors when combining.
2. Combined into a single dataframe via `bind_rows`.
3. Engineered four analysis fields:
   - `ride_length_min` — duration in minutes
   - `day_of_week` — Monday … Sunday (ordered factor)
   - `hour_of_day` — 0–23
   - `season` — Winter / Spring / Summer / Fall
4. Removed rows where:
   - Either timestamp was missing
   - `ride_length_min < 1` (false starts and re-docks, per Divvy documentation)
   - `ride_length_min > 1440` (>24 hr — likely lost or stolen bikes)
   - `member_casual` was not "member" or "casual"

Roughly 1–2% of records are dropped by these filters, which matches the cleaning loss reported in similar published Divvy analyses.

This source export does not include generated chart PNGs. The figure files
referenced below are produced by `R/04_visualize.R` after running the pipeline.

---

## 4. Analysis & Findings

### Finding 1 — Casual rides are roughly twice as long as member rides

Members average around **12 minutes** per ride; casual riders average **22+ minutes**. The gap holds every day of the week and widens on weekends. This is the single most important behavioral signal in the dataset: it strongly suggests members use bikes as a **transportation tool** while casuals use them as a **leisure activity**.

Figure output: `output/figures/02_avg_length_by_dow.png`

### Finding 2 — Members commute, casuals cruise

The hourly pattern makes the use-case difference unmistakable:

- **Members** show a classic two-peak commute curve at **8 AM** and **5 PM**.
- **Casuals** show a single broad afternoon hump centered around **2–4 PM**.

Figure output: `output/figures/03_rides_by_hour.png`

By day of week, members dominate Monday–Friday; casual ride volume jumps on Saturday and Sunday and frequently exceeds member volume on those days.

Figure output: `output/figures/01_rides_by_dow.png`

### Finding 3 — Both groups are seasonal, but casuals swing harder

Both segments peak in summer (June–August) and bottom out in January–February. The casual-rider curve is much steeper — roughly a 6–8× swing from winter to summer, versus 3–4× for members. This means **summer is the high-leverage conversion window**.

Figure output: `output/figures/04_rides_by_month.png`

### Finding 4 — Casual rides cluster at lakefront and tourist stations

The top 15 casual start stations are dominated by Streeter Dr & Grand Ave, DuSable Lake Shore Dr stations, Millennium Park, and Navy Pier — all leisure/tourist locations. Member rides are far more evenly distributed across the network.

Figure output: `output/figures/06_top_casual_stations.png`

### Finding 5 — Bike-type preferences differ modestly

Casual riders are slightly more likely than members to choose electric bikes, and a small share of casual rides use the docked-bike option that members rarely select. Useful for product/inventory teams but not the primary marketing lever.

Figure output: `output/figures/05_bike_type.png`

---

## 5. Summary

| Dimension | Members | Casual riders |
|-----------|--------:|--------------:|
| Avg ride length | ~12 min | ~22+ min |
| Peak hours | 8 AM, 5 PM | 2–4 PM |
| Peak days | Tue–Thu | Sat, Sun |
| Peak season | Summer (moderate swing) | Summer (extreme swing) |
| Spatial pattern | Distributed across city | Concentrated at lakefront/tourist stations |
| Dominant use case | Commuting | Leisure / sightseeing |

Members and casual riders aren't slightly different versions of the same customer — they are using the same product for **fundamentally different jobs**. Any conversion strategy that treats them as the same customer with different price tolerance will underperform.

---

## 6. Top Three Recommendations

### 1. Launch a "Weekend & Leisure" membership tier

A standard annual membership is built for daily commuters. Casual riders ride long, on weekends, in summer — they don't see themselves in that product. A lower-priced **Weekend Membership** (Fri–Sun unlimited rides up to 60 minutes, valid March–October) would be priced to beat 2–3 day-pass purchases per month and would sell against a need casual riders demonstrably already have.

### 2. Run geo-targeted summer campaigns at the top 15 casual stations

The top casual stations are physical, repeatable, high-traffic touchpoints. Recommended actions:

- In-app push notifications when a casual rider docks at one of these stations: *"You've spent $X on day passes this month — a Weekend Membership pays for itself in 3 rides."*
- Static signage at the docks themselves with QR-code conversion offers.
- Concentrate paid social geo-fences on these station footprints, May through September.

### 3. Time the conversion push to the May–July ramp

Casual ridership roughly triples between April and July. A casual rider who converts in May rather than August captures three extra months of membership value. Marketing spend should be **front-loaded in spring**, not spread evenly across the year, with the offer message focused on cost-per-ride math rather than commuting benefits.

---

## 7. Next Steps & Suggested Future Data

- **A/B test** the Weekend Membership price point with a holdout group before full launch.
- **Acquire weather data** (NOAA Chicago) to separate seasonality from weather effects and refine campaign timing.
- **Add anonymized rider-level identifiers** so we can distinguish one-time tourists (low conversion potential) from repeat casual riders (high potential) — this is the single biggest analytical gap in the current dataset.
- **Survey casual riders** at top stations to validate the "leisure vs. commute" framing with stated-preference data.

---

*Code, charts, and reproducible pipeline:* [github.com/KazmirFahrier/cyclistic-case-study](https://github.com/KazmirFahrier/cyclistic-case-study)
