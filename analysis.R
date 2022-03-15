################################################################################
# Load libraries
library(tidyverse)

################################################################################
# Define constants
RAW_DATA_PATH <- "data/raw/scores.csv"
START_TIME <- 15 * 60  # 15 minutes, measured in seconds
FONT_SIZE <- 20

################################################################################
# Define functions
count_time_from_zero <- function(
    times,
    start_time
) {
    return(start_time - times)
}

################################################################################
# Read data
column_types <- cols(
    game = col_double(),
    time = col_time(format = "%M:%S:00"),
    blue = col_double(),
    red = col_double()
)

scores <- read_csv(
    RAW_DATA_PATH,
    col_types = column_types
)

################################################################################
# Clean data
scores <-
    scores %>%
    pivot_longer(c(blue, red), names_to = "team", values_to = "score")

scores <-
    scores %>%
    mutate(time = as.numeric(time)) %>%
    mutate(time = count_time_from_zero(time, start_time = START_TIME))

scores <-
    scores %>%
    mutate(team = str_to_sentence(team))

################################################################################
# Transform data
time_to_kills <-
    scores %>%
    group_by(game, team) %>%
    filter(score != lag(score)) %>%
    mutate(time_to_kill = time - lag(time)) %>%
    ungroup()

time_to_kills <-
    time_to_kills %>%
    select(-score) %>%
    drop_na(time_to_kill)

################################################################################
# Analyze data
scores %>%
    ggplot(aes(x = time, y = score, color = team)) +
    geom_line() +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (seconds)",
        y = "Score",
        color = "Team"
    )

time_to_kills %>%
    ggplot(aes(x = time_to_kill, color = team)) +
    geom_density() +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time to kill (seconds)",
        y = "Density",
        color = "Team"
    )

time_to_kills %>%
    rename(Team = team) %>%
    ggplot(aes(x = time, y = time_to_kill)) +
    geom_col(width = 4) +
    geom_smooth() +
    facet_grid(cols = vars(Team), labeller = label_both) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (seconds)",
        y = "Time to kill (seconds)",
        color = "Team"
    )
