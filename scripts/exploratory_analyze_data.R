################################################################################
# Load libraries
library(tidyverse)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Read data
scores <- read_csv(CLEAN_SCORES_PATH)

################################################################################
# Analyze data
scores %>%
    ggplot(aes(x = time, y = score, color = team)) +
    geom_step(size = 2) +
    scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Score",
        color = "Team"
    )

scores %>%
    ggplot(aes(x = ttp, color = team)) +
    geom_density(size = 2) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time to point (minutes)",
        y = "Density",
        color = "Team"
    )

scores %>%
    rename(Team = team) %>%
    ggplot(aes(x = time, y = ttp)) +
    geom_col() +
    geom_smooth(size = 2) +
    facet_grid(cols = vars(Team), labeller = label_both) +
    scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Time to point (minutes)"
    )
