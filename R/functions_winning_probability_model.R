################################################################################
# Define functions
cumulative_winning_probability <- function(
    data
) {
    data <-
        data %>%
        arrange(time) %>%
        filter(score < 100)

    winning_probabilities <-
        data %>%
        slider::slide(
            one_step_winning_probability,
            .before = Inf
        ) %>%
        bind_rows()

    return(winning_probabilities)
}

one_step_winning_probability <- function(
    data
) {
    winning_probability_model <- create_model(WINNING_PROBABILITY_MODEL_PATH)

    winning_probability_model_data <- create_winning_probability_model_data(data)

    winning_probability_model_fit <- fit_model(
        winning_probability_model,
        winning_probability_model_data,
        data
    )

    winning_probability_model_fit <-
        winning_probability_model_fit %>%
        recover_types(data)

    winning_probability <-
        winning_probability_model_fit %>%
        spread_draws(winning_probability) %>%
        mean_hdci() %>%
        ungroup() %>%
        select(winning_probability, .lower, .upper)

    last_time <-
        data %>%
        pull(time) %>%
        last()

    winning_probability <-
        winning_probability %>%
        mutate(time = last_time, .before = winning_probability)

    return(winning_probability)
}

create_winning_probability_model_data <- function(
    data
) {
    model_data <-
        data %>%
        select(team, time, score) %>%
        compose_data(.n_name = function(name) ifelse(name == "", "sample_size", str_glue("{name}_count")))

    model_data <- c(
        model_data,
        max_score = GAME_MAX_SCORE,
        mean_rate_of_rates = PRIOR_MEAN_RATE_OF_RATES
    )

    return(model_data)
}

plot_winning_probabilities <- function(
    winning_probabilities
) {
    plot <-
        winning_probabilities %>%
        ggplot(aes(x = time)) +
        geom_ribbon(aes(ymin = .lower, ymax = .upper), alpha = 0.25) +
        geom_line(aes(y = .lower), alpha = 0.5) +
        geom_line(aes(y = .upper), alpha = 0.5) +
        geom_step(aes(y = winning_probability), size = 1) +
        scale_x_continuous(limits = c(GAME_MIN_TIME, GAME_MAX_TIME)) +
        scale_y_continuous(limits = c(0, 1), labels = scales::percent) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Team blue's\nprobability of winning"
        )

    return(plot)
}
