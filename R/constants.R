################################################################################
# Define constants
RAW_SCORES_PATH <- "data/raw/scores.csv"
CLEAN_SCORES_PATH <- "data/clean/scores.csv"
PRIOR_MODEL_PATH <- "models/prior-model.stan"
MODEL_PATH <- "models/model.stan"

RAW_SCORES_COLUMN_TYPES <- cols(
    game = col_double(),
    time = col_time(format = "%M:%S:00"),
    blue = col_double(),
    red = col_double()
)

CLEAN_SCORES_COLUMN_TYPES <- cols(
    game = col_double(),
    time = col_double(),
    team = col_factor(c("Blue", "Red")),
    score = col_double(),
    ttp = col_double()
)

GAME_MIN_DURATION <- 0
GAME_MAX_DURATION <- 15
GAME_MIN_SCORE <- 0
GAME_MAX_SCORE <- 100

PRIOR_MODEL_SAMPLE_COUNT <- 100
CHAIN_COUNT <- 4
SEED <- 42

FONT_SIZE <- 20
