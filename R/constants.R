################################################################################
# Define constants
RAW_SCORES_PATH <- "data/raw/scores.csv"
CLEAN_SCORES_PATH <- "data/clean/scores.csv"
PREDICTIVE_PRIOR_PATH <- "models/predictive-prior.stan"

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

FONT_SIZE <- 20

PREDICTIVE_PRIOR_SAMPLE_COUNT <- 100
SEED <- 42
