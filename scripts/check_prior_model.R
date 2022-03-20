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
prior_data <- list(
    max_score = GAME_MAX_SCORE,
    mean_rate_of_rates = GAME_MAX_SCORE / GAME_MAX_DURATION
)

prior_model <- cmdstan_model(
    PRIOR_MODEL_PATH,
    dir = COMPILED_MODEL_PATH,
    pedantic = TRUE
)

prior_model_fit <- prior_model$sample(
    data = prior_data,
    seed = SEED,
    chains = 1,
    iter_warmup = 0,
    iter_sampling = PRIOR_MODEL_SAMPLE_COUNT,
    fixed_param = TRUE
)

################################################################################
# Check prior model
prior_model_fit %>%
    spread_draws(rate) %>%
    median_hdci(rate)

prior_model_fit %>%
    spread_draws(ttp[t]) %>%
    median_hdci(ttp)

prior_model_fit %>%
    spread_draws(rate) %>%
    plot_prior_rate()

################################################################################
# Check predictive prior
prior_model_fit %>%
    spread_draws(time[t], score[t]) %>%
    plot_prior_scores()

prior_model_fit %>%
    spread_draws(ttp[t]) %>%
    plot_prior_ttp_distribution()

prior_model_fit %>%
    spread_draws(time[t], ttp[t]) %>%
    plot_prior_ttp_vs_time()
