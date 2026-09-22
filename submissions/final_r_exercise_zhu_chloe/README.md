# NY School Poverty and Test Performance

This project examines the relationship between socioeconomic conditions and test performance in New York public schools.

The analysis combines school-level education data with county-level socioeconomic data from the American Community Survey (ACS).

## Project Structure

- `data/raw/`: Contains the original school and ACS datasets.
- `data/processed/`: Contains cleaned, transformed, and merged datasets.
- `scripts/1_clean.R`: Imports the raw data and cleans missing or invalid values.
- `scripts/2_transform.R`: Creates county poverty groups and standardized Math and ELA scores.
- `scripts/3_merge.R`: Merges the school and ACS datasets by county and year.
- `scripts/4_analyze.R`: Creates county-level summaries and comparisons.
- `scripts/5_plot.R`: Creates the final visualizations.
- `final_report.Rmd`: R Markdown notebook containing the analysis and findings.
- `final_report.html`: Rendered HTML version of the final report.
- `run_all.R`: Runs all analysis scripts in the correct order.

## Analysis

The project explores the relationship between county poverty and student test performance. Counties are divided into low-, medium-, and high-poverty groups, and Math and ELA scores are standardized within each year to make performance comparable across years.

The analysis also examines the relationship between participation in free or reduced-price lunch programs and standardized Math performance.

## Main Findings

Schools in higher-poverty counties generally have lower standardized Math and ELA scores than schools in lower-poverty counties.

Schools with higher rates of students qualifying for free or reduced-price lunch also tend to have lower standardized Math performance.

These findings show associations in the data and should not be interpreted as evidence of a causal relationship.