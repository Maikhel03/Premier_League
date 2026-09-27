# Premier League Match Analysis (2000–2026)

An end-to-end analysis of English Premier League match data spanning 26 seasons, built with SQL Server for data querying/aggregation and Power BI for visualization.

## Overview

This project explores nearly two decades of Premier League results to answer questions about home advantage, scoring trends, club shooting efficiency, and refereeing/discipline patterns. Raw match-level data (results, goals, half-time scores, cards, fouls, attendance, referee, derby and VAR flags) is queried in SQL Server and visualized in a multi-page Power BI dashboard.

## Data

- **Source table:** `EPL_Matches`
- **Coverage:** 19,760 matches across 26 seasons (2000–2026)
- **Clubs:** 46+ unique teams
- **Referees:** 85
- **Fields include:** season, year/month/day, home/away team, full-time and half-time goals, match result, yellow/red cards (home & away), fouls, referee, attendance, derby flag, VAR flag

## Tools & Methodology

- **SQL Server (SSMS)** — 23 queries covering:
  - Match, team, and league summary statistics
  - League standings computed directly from results (points, wins/draws/losses, goal difference) using `UNION ALL` and `CASE`-based aggregation
  - Home/away performance splits with `HAVING`-filtered minimum sample sizes
  - Shooting efficiency and disciplinary metrics via subqueries and `UNION ALL`
  - Contextual questions — derby outcomes, VAR impact, half-time comebacks, attendance trends — using window functions (`SUM(...) OVER (PARTITION BY ...)`)
- **Power BI** — KPI cards, pie chart, time-series line chart, scatter plots, and a filterable referee/discipline table (Team and VAR slicers)

## Key Findings

1. **Home advantage is real and persistent.** Home teams won 45.67% of matches versus a 29.52% away win rate (the remainder drawn) — a gap that held up in aggregate across 26 seasons.
2. **Scoring output.** 26.87K goals were scored across 19.76K matches (1.36 goals/match on average), with home teams contributing the larger share of goals (56.45% vs. 43.55% away) — consistent with the home-win advantage above.
3. **Scoring has trended upward with some volatility.** Season goal totals ranged from the low-to-mid 900s–1,000s in most years up to a peak of 1,222; the 2026 figure (521) is a partial year rather than a real decline, since the dataset was pulled mid-year.
4. **Shot volume tracks goal output, but not perfectly.** Arsenal and Chelsea lead the league in both total shots (~14K each) and shots on target (~5.4K each), converting that volume into the most goals (1,880 and 1,775 respectively). Smaller clubs with high shot accuracy (e.g., Blackpool, Bradford) don't necessarily out-score high-volume clubs, since accuracy alone doesn't capture shot quality or frequency.
5. **Card discipline is dominated by exposure, not just behavior.** Across 85 referees the league average is 1.71 cards per match and 227K total fouls. Anthony Taylor officiated the most matches (864) and issued the most cards overall. The clubs with the most red cards (Arsenal, Everton, Chelsea, Newcastle, Tottenham) are also among the clubs with the most matches played — raw totals likely overstate their indiscipline relative to a rate-based comparison.

## Limitations

- **Raw totals vs. rates:** Several findings (e.g., red cards by team, cards by referee) are compared as totals rather than fully normalized per-match rates, which favors teams/referees with more matches.
- **Partial current year:** The 2026 year is incomplete in the dataset, which distorts the most recent point in any time-series view.
- **Unvisualized queries:** The SQL file includes queries on VAR impact, derby outcomes, half-time comebacks, and attendance trends that were written and tested but are not yet represented on the current Power BI dashboard.
- **No player- or shot-quality-level data:** The dataset is match-level only — there's no expected goals (xG), player-level, or tactical (formation/possession) data, which limits how deep the shooting-efficiency and performance analysis can go.
- **Referee/team sample sizes vary widely** (e.g., some referees have only 2 matches recorded), which can make per-match rates for low-volume referees noisy.

## Future Improvements

- Normalize team and referee card/foul stats on a per-90-minutes or per-match basis throughout (not just in the discipline table) for fairer comparisons.
- Automate data refresh (scheduled ETL / Power BI dataflow) if the source dataset is updated regularly.



## How to Reproduce

1. Load the Premier League match dataset into SQL Server as `EPL_Matches`.
2. Run `New_PL.sql` against it to generate the result sets described above.
3. Open the Power BI file, point it at the same data source, and refresh to regenerate the dashboard pages.
