################################################################################
# Load target libraries
library(tidyverse)
library(fs)

################################################################################
# Source auxiliary files
source(here::here("R/constants.R"))

################################################################################
# Clean project
targets::tar_destroy()

STAN_OUTPUT_PATH %>%
    dir_ls() %>%
    map(file_delete)

RESULTS_PATH %>%
    dir_ls() %>%
    map(file_delete)
