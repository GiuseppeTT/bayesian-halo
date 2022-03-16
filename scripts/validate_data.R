################################################################################
# Load libraries
library(tidyverse)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Read data
scores <- read_csv(
    RAW_SCORES_PATH,
    col_types = RAW_SCORES_COLUMN_TYPES
)

################################################################################
# Validate data
scores %>%
    group_by(game) %>%
    summarise(
        is_time_non_increasing = all(time <= lag(time), na.rm = TRUE),
        is_time_in_the_right_range = all(
            hms::hms(minutes = GAME_MIN_DURATION) <= time &
            time <= hms::hms(minutes = GAME_MAX_DURATION)
        ),

        is_blue_score_non_decreasing = all(blue >= lag(blue), na.rm = TRUE),
        is_blue_score_in_the_right_range = all(GAME_MIN_SCORE <= blue & blue <= GAME_MAX_SCORE),

        is_red_score_non_decreasing = all(red >= lag(red), na.rm = TRUE),
        is_red_score_in_the_right_range = all(GAME_MIN_SCORE <= red & red <= GAME_MAX_SCORE)
    ) %>%
    pivot_longer(-game, names_to = "validation", values_to = "result")
