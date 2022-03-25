################################################################################
# Define constants
RAW_TRAIN_DATA_PATH <- here::here("data/raw/train.csv")
RAW_TEST_DATA_PATH <- here::here("data/raw/test.csv")

STAN_OUTPUT_PATH <- here::here("stan_output")
PRIOR_MODEL_PATH <- here::here("stan/prior_model.stan")
MODEL_PATH <- here::here("stan/model.stan")

RESULTS_PATH <- here::here("results/")
REPORT_SOURCE_PATH <- here::here("Rmd/report.Rmd")
REPORT_OUTPUT_PATH <- here::here("results/report.html")

GAME_MIN_DURATION <- 0
GAME_MAX_DURATION <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

PRIOR_MEAN_RATE_OF_RATES <- GAME_MAX_SCORE / (2/3 * GAME_MAX_DURATION)
PRIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_PLOT_SAMPLE_COUNT <- 1000
CHAIN_COUNT <- 4
SEED <- 42

ALPHA <- 0.01
FONT_SIZE <- 20
