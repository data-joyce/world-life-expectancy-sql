# How Life Expectancy Changed Around the World from 2007 to 2022

A SQL project where I cleaned a world life expectancy dataset and then explored it to see how life expectancy relates to wealth, development status and health indicators.

**Tools:** MySQL

## Goal

I wanted to clean a real dataset with common data problems (duplicates and blank values) and then answer a few questions:

- Which countries improved their life expectancy the most?
- How did the world average change over the years?
- Do richer countries live longer?
- How big is the gap between developed and developing countries?

## Data

`WorldLifeExpectancy.csv`: one row per country per year (2007 to 2022), with life expectancy, status (Developed or Developing), GDP, BMI, adult mortality and other health indicators. The dataset was provided in the Analyst Builder MySQL course.

## Files

| File | What it does |
|---|---|
| `01_data_cleaning.sql` | Removes duplicates and fills blank values |
| `02_exploratory_analysis.sql` | Answers the questions above |
| `WorldLifeExpectancy.csv` | Raw data |

## Part 1: Data cleaning

1. **Duplicates.** Each country should appear only once per year. I combined country and year with `CONCAT`, found 3 duplicates with `ROW_NUMBER()` and deleted them.
2. **Blank status.** 8 rows had no status. A country's status doesn't change from one year to the next, so I used a self join to copy the status from the same country's other years.
3. **Blank life expectancy.** 2 rows had no life expectancy. I filled each one with the average of the year before and the year after, using two self joins.

## Part 2: Exploratory analysis

- **Biggest improvement:** Haiti gained 28.7 years of life expectancy between its lowest and highest year.
- **World average over time:** life expectancy went from 66.8 years in 2007 to 71.6 years in 2022.
- **Wealth:** rows with GDP of 1,500 or more had an average life expectancy of 74.2 years, against 64.7 years for rows below 1,500.
- **Development status:** developed countries average 79.2 years (32 countries) and developing countries 66.8 years (161 countries).
- I also looked at BMI and adult mortality (using a rolling total with a window function).

## Skills

Window functions (`ROW_NUMBER`, rolling `SUM OVER`), self joins, `UPDATE` with `JOIN`, subqueries, `CASE WHEN`, aggregation with `GROUP BY` and `HAVING`.

## Limitations

- The comparison between developed and developing countries is unbalanced: there are 5 times more developing countries.
- The GDP threshold of 1,500 is a simple cut I chose to compare two groups, not an official definition.
- Some rows have 0 in life expectancy or GDP, so I left them out of the averages.
