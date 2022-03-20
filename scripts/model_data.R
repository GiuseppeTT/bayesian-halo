################################################################################
# Load libraries
library(tidyverse)
library(arrow)
library(cmdstanr)
library(tidybayes)

################################################################################
# Source auxiliary files
source("R/constants.R")
source("R/functions.R")

################################################################################
# Read data
scores <- read_feather(CLEAN_SCORES_PATH)

scores <-
    scores %>%
    filter(game == 1)  # TODO: generalize for more than one game

################################################################################
# Fit model
model_data <-
    scores %>%
    select(team, time) %>%
    compose_data(.n_name = function(name) ifelse(name == "", "sample_size", str_glue("{name}_count")))

model_data <- c(
    model_data,
    mean_rate_of_rates = GAME_MAX_SCORE / GAME_MAX_DURATION
)

model <- cmdstan_model(
    MODEL_PATH,
    dir = COMPILED_MODEL_PATH,
    pedantic = TRUE
)

fit <- model$sample(
    data = model_data,
    seed = SEED,
    chains = CHAIN_COUNT,
    parallel_chains = CHAIN_COUNT,
    iter_sampling = POSTERIOR_MODEL_SAMPLE_COUNT
)

fit <-
    fit %>%
    recover_types(scores)

################################################################################
# Check fit model
fit %>%
    spread_draws(rate[team]) %>%
    median_hdci(rate)

fit %>%
    spread_draws(rate_contrast) %>%
    median_hdci(rate_contrast)

fit %>%
    spread_draws(rate[team]) %>%
    plot_posterior_rates()

fit %>%
    spread_draws(rate_contrast) %>%
    plot_posterior_contrast()

################################################################################
# Check predictive posterior
fit %>%
    spread_draws(predicted_time[t], predicted_score[t]) %>%
    sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
    ungroup() %>%
    recover_covariates(scores, by = "t", team) %>%
    plot_posterior_scores(scores)

fit %>%
    spread_draws(predicted_ttp[t]) %>%
    sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
    ungroup() %>%
    recover_covariates(scores, by = "t", team) %>%
    plot_posterior_ttp_distribution()

fit %>%
    spread_draws(predicted_time[t], predicted_ttp[t]) %>%
    sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
    ungroup() %>%
    recover_covariates(scores, by = "t", team) %>%
    plot_posterior_ttp_vs_time()
