################################################################################
# Define functions
read_raw_data <- function(
    raw_data_path
) {
    column_types <- cols(
        time = col_time(format = "%M:%S:00"),
        blue = col_double(),
        red = col_double()
    )

    raw_data <- read_csv(
        raw_data_path,
        col_types = column_types
    )

    return(raw_data)
}

validate_raw_data <- function(
    raw_data
) {
    validations <-
        raw_data %>%
        summarise(
            is_time_non_increasing = all(time <= lag(time), na.rm = TRUE),
            is_time_in_the_right_range = all(
                hms::hms(minutes = GAME_MIN_TIME) <= time &
                time <= hms::hms(minutes = GAME_MAX_TIME)
            ),

            is_blue_score_non_decreasing = all(blue >= lag(blue), na.rm = TRUE),
            is_blue_score_in_the_right_range = all(GAME_MIN_SCORE <= blue & blue <= GAME_MAX_SCORE),

            is_red_score_non_decreasing = all(red >= lag(red), na.rm = TRUE),
            is_red_score_in_the_right_range = all(GAME_MIN_SCORE <= red & red <= GAME_MAX_SCORE)
        )

    validations <-
        validations %>%
        pivot_longer(everything(), names_to = "validation", values_to = "result")

    results <-
        validations %>%
        pull(result)

    is_raw_data_valid <- all(results)

    return(is_raw_data_valid)
}

clean_data <- function(
    raw_data
) {
    data <- raw_data

    data <-
        data %>%
        pivot_longer(c(blue, red), names_to = "team", values_to = "score")

    data <-
        data %>%
        mutate(time = convert_time_to_minutes(time)) %>%
        mutate(time = count_time_from_zero(time, start_time = GAME_MAX_TIME))

    data <-
        data %>%
        mutate(team = str_to_sentence(team)) %>%
        mutate(team = factor(team)) %>%
        mutate(team = fct_relevel(team, "Blue", "Red"))

    data <-
        data %>%
        group_by(team) %>%
        arrange(time, .by_group = TRUE) %>%
        filter(has_changed(score, keep_first = TRUE)) %>%
        ungroup()

    data <-
        data %>%
        group_by(team) %>%
        mutate(ttp = time - lag(time)) %>%
        ungroup()

    return(data)
}

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

has_changed <- function(
    xs,
    keep_first = FALSE
) {
    has_changed_ <- xs != dplyr::lag(xs)

    if (keep_first)
        has_changed_[1] <- TRUE
    else
        has_changed_[1] <- FALSE

    return(has_changed_)
}
