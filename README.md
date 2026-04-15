# Cyclistic Bike-Share Case Study

**Google Data Analytics Capstone — How do annual members and casual riders use Cyclistic bikes differently?**

This project analyzes 12 months of Divvy bike-share trip data (Nov 2024 – Oct 2025, ~5M+ rides) to inform a marketing strategy aimed at converting casual riders into annual members.

🔗 **Author:** Kazmir Fahrier · [LinkedIn](https://www.linkedin.com/in/kazmir-fahrier) · [GitHub](https://github.com/KazmirFahrier)

---

## TL;DR — Three Findings, Three Recommendations

| # | Finding | Recommendation |
|---|---------|----------------|
| 1 | Casual rides are ~2× longer than member rides on average | Promote a **"Weekend Membership"** tier priced against the cost of 2–3 casual day passes |
| 2 | Casual riders peak Sat/Sun afternoons; members peak weekday 8 AM and 5 PM | Target **weekend lakefront riders** with in-app and email conversion offers |
| 3 | Casual rides cluster at a small set of tourist/lakefront stations | Run **station-level geo-targeted campaigns** at the top 15 casual stations |

See [`docs/REPORT.md`](docs/REPORT.md) for the full write-up.

This source export includes the report and reproducible R pipeline. Generated
summary tables in `data/processed/` and chart PNGs in `output/figures/` are
created locally when you run the pipeline.

---

## Repository Structure

```
cyclistic-case-study/
├── R/
│   ├── 01_download_data.R      # Downloads 12 monthly Divvy CSVs
│   ├── 02_clean_and_combine.R  # Combines, cleans, engineers features
│   ├── 03_analyze.R            # Descriptive analysis -> summary CSVs
│   ├── 04_visualize.R          # ggplot2 charts -> PNGs
│   └── run_all.R               # Orchestrates the full pipeline
├── data/
│   ├── raw/                    # Downloaded CSVs (gitignored)
│   └── processed/              # Cleaned data + summary tables
├── output/
│   └── figures/                # Final PNG charts
├── docs/
│   └── REPORT.md               # Full case-study report
├── README.md
└── .gitignore
```

---

## How to Reproduce

**Requirements:** R ≥ 4.2, ~3 GB free disk space, ~10 min runtime.

```r
# From an R session opened at the repo root:
install.packages(c("tidyverse", "lubridate", "here", "janitor", "scales"))
source("R/run_all.R")
```

That single command will:
1. Download 12 monthly trip files from `divvy-tripdata.s3.amazonaws.com`
2. Clean and combine them (~5M+ rows)
3. Generate summary tables in `data/processed/`
4. Render six publication-ready charts in `output/figures/`

---

## Data Source

Public Divvy / Lyft trip data, released monthly under the [Divvy Data License Agreement](https://divvybikes.com/data-license-agreement). No personally identifiable information is included.

The dataset satisfies **ROCCC**:
- **Reliable** — first-party operational data
- **Original** — published by the system operator
- **Comprehensive** — every ride, all 13 fields
- **Current** — updated monthly
- **Cited** — clear license and provenance

---

## Tools

- **R / tidyverse** — data wrangling
- **lubridate** — datetime handling
- **ggplot2** — visualization
- **janitor / scales** — cleaning and formatting helpers

---

## License

MIT — see [`LICENSE`](LICENSE).
