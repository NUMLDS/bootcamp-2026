# ---------------------------------------------------------------------------
# run_all.R
# Reproducibility entry point: runs the whole project from a fresh session.
# Open final_r_exercise.Rproj first so the working directory is the project root.
#
source(file.path("scripts", "0_import.R"))
source(file.path("scripts", "1_clean.R"))
source(file.path("scripts", "2_transform.R"))
source(file.path("scripts", "3_analyze.R"))
source(file.path("scripts", "4_plot.R"))
