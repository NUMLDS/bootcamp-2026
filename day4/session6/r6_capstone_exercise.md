# MLDS Boot Camp - Final R Exercise

You've learned quite a lot about R in a short time. Congratulations! This exercise is designed to give you some additional practice on the material we have discussed this week while the lectures are still fresh in your mind, and to integrate different tools and skills that you have learned.

## Background

You are a data analyst for the New York City Department of Education. You've been tasked with answering the question:

> What can data tell us about the relationship between poverty and test performance in New York public schools?

Some other questions that your department has:

> * What's the difference in test performance between low, medium and high poverty areas?
> * Has this relationship changed over time?
> * Is this relationship at all moderated by access to free / reduced price lunch?

## Brainstorming

Before even looking at the data:

* Empathize: Why is the stakeholder asking these questions?
* Brainstorm: What data and/or visualizations could help answer these questions?
* Insights: What conclusions and/or recommendations do you expect to come from your analysis?

## Your Task

Using the skills you've learned in the past week, tackle the question(s) above. You can use summary tables, statistical models, and/or data visualization in pursuing an answer.

Given the short time period, any answer will of course prove incomplete. The goal of this task is to give you some room to play around with the skills you've just learned. Don't hesitate to try something even if you don't feel comfortable with it yet. Do as much as you can in the time allotted.

**A note on AI:** You're encouraged to use AI for syntax help, the same way we did throughout the week. The analytical decisions — how you group the data, which join to use, what the takeaway is — should be your own.

### Step 1: Set Up Your Project

This is where the majority of your time will be spent.

#### Task 0: Create an R Project

Rather than working out of a single script, set this up the way we did in Session 4: as a self-contained R project.

- Create a new R Project (`.Rproj`)
- Set up the standard project structure:
  - `data/raw/` and `data/processed/`
  - `scripts/` for your numbered analysis scripts (e.g. `1_clean.R`, `2_transform.R`, `3_analyze.R`, `4_plot.R`)
  - a notebook (`.Rmd`) to document and present your findings
  - a `run_all.R` script that sources everything in order
- Load the **tidyverse** at the top of each script that needs it
- **Comment extensively** in every script. In your `.Rmd`, describe your workflow in the text sections, but also comment within your code chunks.

Your code should be **broken down into separate scripts by job** — one script for cleaning, one for merging/transforming, one for your summary tables, one for your plots — not one long script that does everything. This mirrors exactly what we practiced in Session 4.

#### Task 1: Import your data

Place the data files `nys_schools.csv` and `nys_acs.csv` in your `data/raw/` folder, then read them into R using `read_csv()`. These data come from two different sources: one is data on *schools* in New York state from the [New York State Department of Education](http://data.nysed.gov/downloads.php), and the other is data on *counties* from the American Communities Survey from the US Census Bureau. Review the codebook file so that you know what each variable name means in each dataset.

Link to data: https://drive.google.com/drive/folders/1DcWIvLj2motQ5Nkfvjo6GFLcetfvssVq?usp=share_link

#### Task 2: Explore your data

Getting to know your data is a critical part of data analysis. Take the time to explore the structure of the two dataframes you have imported — `glimpse()` is a good place to start. What types of variables are there? Is there any missing data? How can you tell? What else do you notice about the data?

#### Task 3: Recoding and variable manipulation

Using `dplyr`/`tidyr` functions:

1. Deal with missing values, which are currently coded as `-99`.
2. Create a categorical variable that groups counties into "high", "medium", and "low" poverty groups. Decide how you want to split up the groups and briefly explain your decision.
3. The tests that the NYS Department of Education administers changes from time to time, so scale scores are not directly comparable year-to-year. Create a new variable that is the standardized z-score for math and English Language Arts (ELA) for each year (hint: group by year and use the `scale()` function)

Save the result of this step to `data/processed/`.

#### Task 4: Merge datasets

Create a dataset that merges variables from the schools dataset and the ACS dataset, using a `dplyr` join function. Remember that you have learned multiple types of joins, and that you will have to decide which one is appropriate here. Save the merged dataset to `data/processed/`.

---

### Step 2: Analyze the Data

Think back to the original question(s). The best way to answer them and present them to a non-technical audience is using summary tables or visualizations.

#### Task 5: Create summary tables

Using `dplyr`, generate a few summary tables to help answer the questions you were originally asked.

For example:

1. For each county: total enrollment, percent of students qualifying for free or reduced price lunch, and percent of population in poverty.
2. For the counties with the top 5 and bottom 5 poverty rate: percent of population in poverty, percent of students qualifying for free or reduced price lunch, mean reading score, and mean math score.

#### Task 6: Data visualization

Using `ggplot2`, create a few visualizations that you could share with your department. Apply what we covered in Session 5 — a clear takeaway title, sensible labels, and a clean theme.

For example:

1. The relationship between access to free/reduced price lunch and test performance, at the *school* level.
2. Average test performance across *counties* with high, low, and medium poverty.

#### Task 7: Document your findings

In your `.Rmd` notebook, walk through your process and present your key tables and plots, along with a short written takeaway for each of the department's original questions.

Be sure to knit or render your `.Rmd` notebook into an `.html` file that others can easily view.

Add a `README.md` file to your R project that explains the contents of your folder.

---

### Step 3: Github Submission

#### 1. Make sure your forked repo is up to date with the class repo

`git pull upstream main`

#### 2. Save your project within your forked repo

When you have completed the exercise, save your entire project folder (`.Rproj`, `data/`, `scripts/`, `.Rmd`, `.html`, `run_all.R`, `README.md`) in the `submissions` folder of your forked repo, inside a folder named using this convention (`snake_case`, matching R naming best practices): `final_r_exercise_lastname_firstname/`.

#### 3. Push your changes up to your forked repo

`git push origin main`

#### 4. Create a pull request

Create a pull request to submit your folder to the base repo that lives in the MLDS organization. Make sure your project folder is in the `submissions` folder, and then create a pull request that asks to merge changes from your forked repo to the base repo.

#### Reminders

- Attempt to knit your `.Rmd` file into HTML format before committing it to Github. Troubleshoot any errors with the knit process by checking the lines referred to in the error messages.
- Test that `run_all.R` actually runs your project from a fresh session — this is the same reproducibility check we practiced in Session 4.
