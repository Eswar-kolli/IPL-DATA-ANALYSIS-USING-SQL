
# 🏏 IPL Data Analysis Using SQL

An end-to-end SQL data analysis project using IPL match and ball-by-ball data to explore team performance, venue trends, toss impact, player statistics, and season-wise business insights.The project was developed using Microsoft SQL Server and SSMS as a practical Data Analytics portfolio project.
## 🎯 Project Objectives

The main objectives of this project are:

* Validate the quality and completeness of IPL data.
* Identify duplicate and missing records.
* Standardize season, team, and venue names.
* Analyze team performance and highest innings totals.
* Analyze venue-wise scoring patterns.
* Study the relationship between toss results and match outcomes.
* Identify top-performing batsmen and bowlers.
* Analyze season-wise player performance.
* Calculate team winning percentages.
* Identify consistently performing teams.
* Create reusable SQL views for frequently used analysis.
* Build a season-level summary table containing key IPL metrics.
## 🗃️ Dataset

The dataset used in this project is the **IPL Complete Dataset** from Kaggle.

**Dataset:** IPL Complete Dataset
* **Author:** Prateek Bhardwaj
* **Original data source:** Cricsheet

The dataset contains two main tables used in this project:

### `matches`

Contains match-level information such as:

* Match ID
* Season
* City
* Date
* Match type
* Team 1
* Team 2
* Toss winner
* Toss decision
* Winner
* Player of the Match
* Venue

### `deliveries`

Contains ball-by-ball information such as:

* Match ID
* Inning
* Batting team
* Bowling team
* Over
* Ball
* Batter
* Bowler
* Non-striker
* Batter runs
* Extra runs
* Total runs
* Extras type
* Dismissal information

### `Dataset Source`

#### [Kaggle – IPL Complete Dataset](https://www.kaggle.com/datasets/patrickb1912/ipl-complete-dataset-20082020)



## 📂 Project Files

### 1. DATA VALIDATION AND CLEANING

**File:** `1.DATA VALIDATION AND CLEANING.sql`

This is the first stage of the project. Before performing analysis, I used SQL to check the quality and consistency of the data.

### What this file covers

**Record count validation**

Checks the total number of records in both the `matches` and `deliveries` tables.

**Duplicate checking**

Checks for duplicate match IDs in the `matches` table.

**Missing value analysis**

Checks important columns in the `matches` table for NULL values, including:

* ID
* Season
* City
* Date
* Match type
* Winner
* Player of the Match
* Venue

**Season standardization**

Different season formats are converted into a consistent year format.

For example:

```text
2007/08 → 2008
2009/10 → 2010
2020/21 → 2020
```

**Team name standardization**

Historical team names are standardized so that the same team is not treated as different teams during analysis.

Examples:

```text
Kings XI Punjab → Punjab Kings
Delhi Daredevils → Delhi Capitals
Royal Challengers Bangalore → Royal Challengers Bengaluru
Rising Pune Supergiant → Rising Pune Supergiants
```

**Venue standardization**

Different variations of venue names are consolidated into standardized venue names.

This makes venue-based analysis more consistent.

---

## 2. TEAM & VENUE ANALYSIS

**File:** `2.TEAM & VENUE ANALYSIS.sql`

This file focuses on team scoring performance and venue characteristics.

### Analysis included

**Highest team totals**

Finds the highest innings totals in the dataset.

**Highest score by each team**

Finds the highest innings total achieved by each batting team.

**Average first-innings score by venue**

Calculates the average first-innings score for each venue.

**Season-wise venue analysis**

Compares average first-innings scores by venue across different seasons.

**Most frequently used venues**

Identifies venues that have hosted the highest number of matches.

**Most successful team at each venue**

Uses the `RANK()` window function to identify the team with the most wins at each venue.

This also allows ties to be handled instead of returning only one team.

---

## 3. TOSS IMPACT ANALYSIS

**File:** `3.TOSS IMPACT ANALYSIS.sql`

This file looks at the relationship between winning the toss and winning the match.

### Analysis included

**Overall toss impact**

Calculates how often the team that won the toss also won the match.

**Season-wise toss impact**

Breaks down toss and match results by season.

**Toss decision preference**

Shows how often teams chose to bat or field after winning the toss.

**Season-wise toss preference**

Shows how toss decisions changed across seasons.

**Toss decision and match outcome**

Compares match-winning results based on whether the toss-winning team chose to bat or field.

This section helps answer a simple business question:

> Does winning the toss provide an advantage in winning the match?

---

## 4. PLAYER PERFORMANCE ANALYSIS

**File:** `4.PLAYER PERFORMANCE ANALYSIS.sql`

This file focuses on individual player performance.

### Analysis included

**Top 10 run scorers**

Finds the players with the highest total runs.

The file also demonstrates two approaches:

* `TOP`
* `OFFSET` and `FETCH`

**Top 10 wicket takers**

Finds the bowlers with the highest number of wickets using relevant dismissal types.

**Highest individual score in a match**

Calculates each batter's runs in each match and identifies the highest individual score.

**Most Player of the Match awards**

Finds the player who has received the highest number of Player of the Match awards.

---

## 5. ADVANCED BUSINESS ANALYSIS

**File:** `5.ADVANCED BUSINESS ANALYSIS.sql`

This file moves from basic analysis into more business-oriented questions.

### Analysis included

**Matches played per season**

Shows how many matches were played in each IPL season.

**Incomplete/no-result matches**

Identifies the individual matches that ended without a result.

There are only a small number of such matches in the dataset, so the query shows the actual matches rather than only providing a season-level count.

**Most successful teams**

Ranks teams based on the number of matches they have won.

**First-batting vs second-batting performance**

Calculates the winning percentage for teams batting first and teams batting second.

**Season-wise top scorer**

Uses a CTE and `RANK()` to identify the highest run scorer in each season.

**Season-wise top wicket taker**

Uses a CTE and `RANK()` to identify the highest wicket taker in each season.

**Team winning percentage**

Calculates matches played, wins and winning percentage for each team.

Two SQL approaches are demonstrated using:

* A derived table
* A CTE

**Team consistency analysis**

Looks at teams across seasons and calculates:

* Seasons played
* Total matches
* Total wins
* Winning percentage
* Average wins per season

The average wins per season are then used to classify team consistency into High, Medium and Low categories.

---

## 6. VIEWS & SUMMARY TABLE

**File:** `6.VIEWS & SUMMARY TABLE.sql`

The final file focuses on creating reusable database objects from the analysis.

## SQL Views

Five views are created:

### `vw_venue_matches`

Provides the number of matches hosted at each venue.

### `vw_team_performance`

Provides team-level:

* Matches played
* Wins
* Winning percentage

### `vw_batsman_performance`

Provides season-wise batting performance including:

* Total runs
* Matches played

### `vw_bowler_performance`

Provides season-wise wicket totals for bowlers.

### `vw_venue_performance`

Provides venue-level:

* Matches played
* Highest innings total
* Average innings score

These views make the analysis reusable without having to write the complete queries again.

---

## 📋 Season Summary Table

The same file also creates a `season_summary` table that brings important season-level metrics into one place.

The table contains:

* Season
* Matches played
* Completed matches
* No-result matches
* Teams participated
* Teams with wins
* Unique cities
* Unique venues
* Total runs
* Average match runs
* Highest innings score
* Toss winner and match winner count
* Toss win-to-match win percentage

The summary table is built using multiple CTEs and joins to combine different season-level calculations.

---

## 🧠 SQL Concepts Used

Throughout the project, I used and practiced:

* Filtering with `WHERE`
* Aggregation
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `INNER JOIN`
* `LEFT JOIN`
* `UNION`
* `UNION ALL`
* `CASE`
* Subqueries
* Common Table Expressions (CTEs)
* Window functions
* `RANK()`
* `TOP`
* `OFFSET`
* `FETCH`
* `CAST`
* `NULLIF`
* `UPDATE`
* SQL Views
* Summary tables

---

## 🔍 Project Workflow

```text
IPL Dataset
     │
     ▼
Data Validation
     │
     ▼
Data Cleaning & Standardization
     │
     ▼
Team & Venue Analysis
     │
     ▼
Toss Impact Analysis
     │
     ▼
Player Performance Analysis
     │
     ▼
Advanced Business Analysis
     │
     ▼
Views & Season Summary Table
```

## 🛠️ Tools Used

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **SQL**
* **Git**
* **GitHub**

---

## 🎯 What This Project Demonstrates

This project demonstrates how I approach a data analysis problem from raw data to structured insights:

**Validate → Clean → Analyze → Summarize**

It gave me practical experience working with relational data, writing analytical SQL queries, using CTEs and window functions, and converting business questions into SQL solutions.

The project is also structured so that the analysis can be extended later into a **Power BI dashboard** using the views and season summary table.

---

## 👨‍💻 Author

**Eswar**

Data Analytics Portfolio Project

