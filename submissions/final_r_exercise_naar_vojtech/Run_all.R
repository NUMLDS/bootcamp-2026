# ============================================================
# MLDS Final R Exercise
# Run entire analysis pipeline
# ============================================================

# Run scripts in order

source("Scripts/1_clean.R")

source("Scripts/2_transform.R")

source("Scripts/3_analyze.R")

source("Scripts/4_plot.R")

# Confirmation message
message("Analysis completed successfully.")