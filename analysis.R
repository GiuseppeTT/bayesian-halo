################################################################################
# Load libraries
library(tidyverse)
library(cmdstanr)
library(tidybayes)

################################################################################
# Define constants
RAW_DATA_PATH <- "data/raw/scores.csv"
PREDICTIVE_PRIOR_PATH <- "models/predictive-prior.stan"

GAME_MIN_DURATION <- 0
GAME_MAX_DURATION <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

FONT_SIZE <- 20

PREDICTIVE_PRIOR_SAMPLE_COUNT <- 100
SEED <- 42

################################################################################
# Define functions
convert_time_to_minutes <- function(
    times
) {
    return(as.numeric(times) / 60)
}

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
    mutate(time = convert_time_to_minutes(time)) %>%
    mutate(time = count_time_from_zero(time, start_time = GAME_MAX_DURATION))

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
    scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Score",
        color = "Team"
    )

time_to_kills %>%
    ggplot(aes(x = time_to_kill, color = team)) +
    geom_density() +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time to kill (minutes)",
        y = "Density",
        color = "Team"
    )

time_to_kills %>%
    rename(Team = team) %>%
    ggplot(aes(x = time, y = time_to_kill)) +
    geom_col(width = 0.1) +
    geom_smooth() +
    facet_grid(cols = vars(Team), labeller = label_both) +
    scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Time to kill (minutes)"
    )

################################################################################
# Check predictive prior
predictive_prior <- cmdstan_model(
    PREDICTIVE_PRIOR_PATH,
    dir = "stan",
    pedantic = TRUE
)

predictive_prior_data <- list(
    max_score = GAME_MAX_SCORE,
    mean_rate_of_rates = GAME_MAX_SCORE / GAME_MAX_DURATION
)

predictive_prior_draws <- predictive_prior$sample(
    data = predictive_prior_data,
    seed = SEED,
    chains = 1,
    iter_warmup = 0,
    iter_sampling = PREDICTIVE_PRIOR_SAMPLE_COUNT,
    fixed_param = TRUE
)

predictive_prior_draws <-
    predictive_prior_draws %>%
    spread_draws(rate, time_to_kills[score]) %>%
    ungroup() %>%
    rename(time_to_kill = time_to_kills)

predictive_prior_draws <-
    predictive_prior_draws %>%
    group_by(.draw) %>%
    mutate(time = cumsum(time_to_kill)) %>%
    ungroup()

predictive_prior_draws <-
    predictive_prior_draws %>%
    select(.chain, .iteration, .draw, rate, time, score, time_to_kill)

predictive_prior_draws %>%
    summarise_draws()

predictive_prior_draws %>%
    ggplot(aes(x = time, y = score, group = .draw)) +
    geom_line(alpha = 0.5) +
    scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Score",
        color = "Team"
    )

predictive_prior_draws %>%
    ggplot(aes(x = time_to_kill, group = .draw)) +
    geom_density(color = alpha("black", 0.5)) +
    scale_x_log10() +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time to kill (minutes)",
        y = "Density"
    )

predictive_prior_draws %>%
    ggplot(aes(x = time, y = time_to_kill, group = .draw)) +
    geom_smooth(se = FALSE, color = alpha("black", 0.5)) +
    coord_cartesian(xlim = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
    scale_y_log10() +
    theme_minimal(FONT_SIZE) +
    labs(
        x = "Time (minutes)",
        y = "Time to kill (minutes)"
    )
