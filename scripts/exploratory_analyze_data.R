################################################################################
# Load libraries
library(tidyverse)
library(arrow)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Read data
scores <- read_feather(CLEAN_SCORES_PATH)

################################################################################
# Analyze data
scores %>%
    plot_observed_scores()

scores %>%
    plot_observed_ttp_distribution()

scores %>%
    plot_observed_ttp_vs_time()
