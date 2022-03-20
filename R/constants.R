################################################################################
# Define constants
RAW_SCORES_PATH <- "data/raw/scores.csv"
CLEAN_SCORES_PATH <- "data/clean/scores.feather"
COMPILED_MODEL_PATH <- "models"
PRIOR_MODEL_PATH <- "stan/prior_model.stan"
MODEL_PATH <- "stan/model.stan"

RAW_SCORES_COLUMN_TYPES <- cols(
    game = col_double(),
    time = col_time(format = "%M:%S:00"),
    blue = col_double(),
    red = col_double()
)

GAME_MIN_DURATION <- 0
GAME_MAX_DURATION <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

PRIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_MODEL_SAMPLE_COUNT <- 1000
POSTERIOR_PLOT_SAMPLE_COUNT <- 1000
CHAIN_COUNT <- 4
SEED <- 42

ALPHA <- 0.1
FONT_SIZE <- 20
