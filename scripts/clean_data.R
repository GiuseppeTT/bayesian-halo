################################################################################
# Load libraries
library(tidyverse)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Read data
column_types <- cols(
    game = col_double(),
    time = col_time(format = "%M:%S:00"),
    blue = col_double(),
    red = col_double()
)

scores <- read_csv(
    RAW_SCORES_PATH,
    col_types = column_types
)

################################################################################
# Clean data
## Pivot, convert and filter
scores <-
    scores %>%
    pivot_longer(c(blue, red), names_to = "team", values_to = "score")

scores <-
    scores %>%
    mutate(time = convert_time_to_minutes(time)) %>%
    mutate(time = count_time_from_zero(time, start_time = GAME_MAX_DURATION))

scores <-
    scores %>%
    mutate(team = str_to_sentence(team))

scores <-
    scores %>%
    group_by(game, team) %>%
    arrange(time) %>%
    filter(has_changed(score, keep_first = TRUE)) %>%
    ungroup()

## Add time-to-point (ttp)
scores <-
    scores %>%
    group_by(game, team) %>%
    mutate(ttp = time - lag(time)) %>%
    ungroup()

################################################################################
# Write data
scores %>%
    write_csv(CLEAN_SCORES_PATH)
