################################################################################
# Load libraries
library(tidyverse)
library(cmdstanr)
library(tidybayes)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Fit prior model
prior_model <- cmdstan_model(
    PRIOR_MODEL_PATH,
    dir = "stan",
    pedantic = TRUE
)

prior_data <- list(
    max_score = GAME_MAX_SCORE,
    mean_rate_of_rates = GAME_MAX_SCORE / GAME_MAX_DURATION
)

prior_model_fit <- prior_model$sample(
    data = prior_data,
    seed = SEED,
    chains = 1,
    iter_warmup = 0,
    iter_sampling = PRIOR_MODEL_SAMPLE_COUNT,
    fixed_param = TRUE
)

prior_model_draws <-
    prior_model_fit %>%
    spread_draws(rate, ttps[score]) %>%
    ungroup() %>%
    rename(ttp = ttps)

prior_model_draws <-
    prior_model_draws %>%
    group_by(.draw) %>%
    mutate(time = cumsum(ttp)) %>%
    ungroup()

prior_model_draws <-
    prior_model_draws %>%
    select(.chain, .iteration, .draw, rate, time, score, ttp)

################################################################################
# Check predictive prior
prior_model_draws %>%
    median_hdci(rate)

prior_model_draws %>%
    group_by(score) %>%
    median_hdci(ttp)

prior_model_draws %>%
    plot_drawn_prior_rate()

prior_model_draws %>%
    plot_drawn_scores()

prior_model_draws %>%
    plot_drawn_ttp_distribution()

prior_model_draws %>%
    plot_drawn_ttp_vs_time()
