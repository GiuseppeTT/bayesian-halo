################################################################################
# Define functions
create_model <- function(
    model_path
) {
    model <- cmdstan_model(
        model_path,
        dir = STAN_OUTPUT_PATH,
        pedantic = TRUE
    )

    return(model)
}

create_model_data <- function(
    data
) {
    model_data <-
        data %>%
        select(team, time) %>%
        compose_data(.n_name = function(name) ifelse(name == "", "sample_size", str_glue("{name}_count")))

    model_data <- c(
        model_data,
        mean_rate_of_rates = PRIOR_MEAN_RATE_OF_RATES
    )

    return(model_data)
}

fit_model <- function(
    model,
    model_data,
    data
) {
    model_fit <- model$sample(
        data = model_data,
        seed = SEED,
        chains = CHAIN_COUNT,
        parallel_chains = CHAIN_COUNT,
        iter_sampling = POSTERIOR_MODEL_SAMPLE_COUNT,
        output_dir = STAN_OUTPUT_PATH
    )

    model_fit <-
        model_fit %>%
        recover_types(data)

    return(model_fit)
}

table_model_rate <- function(
    model_fit
) {
    table <-
        model_fit %>%
        gather_draws(rate[team], rate_contrast) %>%
        ungroup() %>%
        mutate(rate = case_when(
            .variable == "rate_contrast" ~ "Contrast",
            TRUE ~ as.character(team)
        ))

    table <-
        table %>%
        mutate(rate = fct_relevel(
            rate,
            "Blue",
            "Red",
            "Contrast"
        ))

    table <-
        table  %>%
        group_by(rate) %>%
        median_hdci(.value)

    return(table)
}

plot_model_score <- function(
    model_fit,
    data
) {
    draws <-
        model_fit %>%
        spread_draws(predicted_time[t], predicted_score[t]) %>%
        sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
        ungroup() %>%
        recover_covariates(data, by = "t", team)

    plot <-
        draws %>%
        ggplot(aes(
            x = predicted_time,
            y = predicted_score,
            color = team,
            group = str_c(.draw, team)
        )) +
        geom_step(alpha = ALPHA) +
        geom_step(aes(x = time, y = score, color = team, group = NULL), data = data, size = 2) +
        scale_x_continuous(limits = c(GAME_MIN_TIME, GAME_MAX_TIME)) +
        scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        scale_color_viridis_d() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Score",
            color = "Team"
        )

    return(plot)
}

recover_covariates <- function(
    draws,
    data,
    by,
    ...
) {
    data <-
        data %>%
        mutate("{by}" := row_number()) %>%
        select(.data[[by]], ...)

    draws <-
        draws %>%
        left_join(data, by = by)

    return(draws)
}
