################################################################################
# Define constants
RAW_TRAIN_DATA_PATH <- here::here("data/raw/train.csv")
RAW_TEST_DATA_PATH <- here::here("data/raw/test.csv")

STAN_OUTPUT_PATH <- here::here("output/stan/")
PRIOR_MODEL_PATH <- here::here("stan/prior_model.stan")
MODEL_PATH <- here::here("stan/model.stan")
PREDICTION_MODEL_PATH <- here::here("stan/prediction_model.stan")
WINNING_PROBABILITY_MODEL_PATH <- here::here("stan/winning_probability_model.stan")

REPORT_SOURCE_PATH <- here::here("Rmd/index.Rmd")
REPORT_OUTPUT_PATH <- here::here("output/github-pages/index.html")
REPORT_PREVIEW_IMAGE_PATH <- here::here("output/github-pages/images/preview.png")

NETWORK_PATH <- here::here("output/github-pages/targets.html")

GAME_MIN_TIME <- 0
GAME_MAX_TIME <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

PRIOR_MEAN_GAME_TIME <- 10
PRIOR_MEAN_RATE_OF_RATES <- GAME_MAX_SCORE / PRIOR_MEAN_GAME_TIME
PRIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_MODEL_SAMPLE_COUNT <- 1000
CHAIN_COUNT <- 4
SEED <- 42

WINDOW_SIZE <- 5

THRESHOLD <- 0.01

ALPHA <- 0.01
FONT_SIZE <- 16

DECIMALS <- 1
