################################################################################
# Define constants
RAW_DATA_PATH <- "data/raw/scores.csv"
CLEAN_DATA_PATH <- "data/clean/scores.feather"
STAN_OUTPUT_PATH <- "stan_output"
PRIOR_MODEL_PATH <- "stan/prior_model.stan"
MODEL_PATH <- "stan/model.stan"
RESULTS_PATH <- "results/"
REPORT_SOURCE_PATH <- "Rmd/report.Rmd"
REPORT_OUTPUT_PATH <- here::here("results/report.html")

GAME_MIN_DURATION <- 0
GAME_MAX_DURATION <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

PRIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_PLOT_SAMPLE_COUNT <- 1000
CHAIN_COUNT <- 4
SEED <- 42

ALPHA <- 0.01
FONT_SIZE <- 20
