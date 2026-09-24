# English Premier League SQL Analysis

## Project Overview

This project analyzes English Premier League match data spanning the 2000/01 to 2025/26 seasons using Microsoft SQL Server.

The objective is to use SQL to explore team performance, match outcomes, goals, attendance, discipline, refereeing, VAR, expected goals (xG), and other factors that can provide insights into Premier League matches.

The project was developed as part of my data analytics portfolio to demonstrate practical SQL skills in cleaning, querying, transforming, aggregating, and analyzing real-world sports data.

## Dataset

The dataset contains 9,880 Premier League matches across 26 seasons, with 85 columns covering match results, team performance, goals, statistics, attendance, referees, managers, form, competitions, VAR, and expected goals.

### Main categories of data

* Match information
* Home and away teams
* Full-time and half-time results
* Goals
* Shots and shots on target
* Fouls
* Corners
* Yellow and red cards
* Attendance
* Referees
* League position and season statistics
* Team form
* Head-to-head form
* VAR
* Derby information
* Stadium and manager information
* European and domestic competition information

## Tools Used

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* GitHub

## Key Questions

The analysis seeks to answer questions such as:

1. What percentage of Premier League matches end in a home win, draw, or away win?
2. Which clubs have accumulated the most points across the dataset?
3. Which clubs have the strongest home records?
4. Which clubs have the strongest away records?
5. Which clubs have scored the most goals?
6. What is the average number of goals scored per match?
7. Which seasons had the highest scoring rates?
8. What were the highest-scoring matches?
9. What were the biggest winning margins?
10. How strongly does leading at half-time relate to winning?
11. How frequently do teams recover from being behind at half-time?
12. Which teams received the most yellow and red cards?
13. Which referees officiated the most matches?
14. Which referees recorded the highest cards-per-match rate?
15. Which matches had the highest attendance?
16. Which clubs had the highest average home attendance?
17. How did average attendance change across seasons?
18. How do derby matches compare with non-derby matches?
19. How do matches involving VAR compare with matches without VAR?
20. Which teams have scored more goals than their expected goals?

## SQL Techniques Demonstrated

The project demonstrates the use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `CASE`
* Aggregate functions
* `COUNT`
* `SUM`
* `AVG`
* `MIN`
* `MAX`
* `ROUND`
* `DISTINCT`
* `UNION`
* `UNION ALL`
* Common Table Expressions (CTEs)
* Window functions
* Conditional aggregation
* Calculated fields
* Percentage calculations
* Filtering and handling missing values

## Example Analysis

### Match Result Distribution

Across the dataset:

* Home wins account for approximately 45.7% of matches.
* Draws account for approximately 24.8%.
* Away wins account for approximately 29.5%.

### Goals

The dataset contains approximately 26,870 goals, with an average of approximately 2.72 goals per match.

Home teams account for approximately 15,169 goals, while away teams account for approximately 11,701 goals.

### Attendance

The average recorded attendance across the dataset is approximately 34,640 spectators per match.

## Project Structure

```text
EPL-SQL-Analysis
│
├── README.md
│
├── SQL
│   ├── 01_Data_Overview.sql
│   ├── 02_Match_Results.sql
│   ├── 03_Team_Performance.sql
│   ├── 04_Goal_Analysis.sql
│   ├── 05_Discipline_Analysis.sql
│   ├── 06_Attendance_Analysis.sql
│   ├── 07_xG_Analysis.sql
│   └── 08_Advanced_Analysis.sql
│
└── Data
    └── README.md
```

## Key Findings

The SQL analysis identified several patterns within the dataset, including the overall distribution of match outcomes, differences between home and away performance, scoring trends across seasons, disciplinary patterns, attendance trends, and differences between actual goals and expected goals.

Further findings are documented alongside the individual SQL queries.

## Limitations

The dataset covers multiple Premier League eras, during which the number of participating clubs, competition structures, available statistics, and data collection methods changed.

Expected-goals data is not available for every match, particularly for older seasons. Therefore, xG-based analysis should only use matches where xG values are available.

Similarly, differences between the VAR and non-VAR periods should be interpreted as descriptive comparisons rather than proof that VAR itself caused changes in match outcomes.

## Future Improvements

Possible extensions to this project include:

* Connecting the SQL database to Power BI.
* Creating season-by-season team performance dashboards.
* Analyzing home advantage over time.
* Comparing expected goals with actual goals.
* Investigating team performance before and after managerial changes.
* Creating predictive models using Python.
* Building a relational database with separate Team, Match, Referee, and Season tables.

## Author

**Odujobi Michael**

Data Analytics Portfolio Project

Skills demonstrated: SQL, data analysis, data cleaning, exploratory analysis, and sports analytics.
