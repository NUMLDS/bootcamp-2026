# run_all.R
# Purpose: run the entire analysis pipeline from raw data to final plots,
# in order. Use this to verify the whole project reproduces cleanly from
# a fresh R session (no leftover objects from earlier work).
#
# To test: Session > Restart R, then source("run_all.R")

# Step 1: import raw data, handle missing values, save cleaned data
source("scripts/1_clean.R")

# Step 2: create poverty groups, standardize test scores, merge datasets
source("scripts/2_transform.R")

# Step 3: generate summary tables answering the department's questions
source("scripts/3_analyze.R")

# Step 4: create visualizations
source("scripts/4_plot.R")

message("Pipeline complete. Check data/processed/ for output files and
         the project root for saved plots (.png).")