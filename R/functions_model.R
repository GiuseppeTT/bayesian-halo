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
    model_fit %>%
        spread_draws(rate[team]) %>%
        median_hdci(rate)
        return()
}

table_model_contrast <- function(
    model_fit
) {
    model_fit %>%
        spread_draws(rate_contrast) %>%
        median_hdci(rate_contrast)
        return()
}

plot_model_rate <- function(
    model_fit
) {
    draws <-
        model_fit %>%
        spread_draws(rate[team], rate_contrast)

    draws <-
        draws %>%
        pivot_wider(names_from = "team", values_from = "rate") %>%
        pivot_longer(
            c(Blue, Red, rate_contrast),
            names_to = "parameter",
            values_to = "value"
        ) %>%
        mutate(parameter = fct_recode(
            parameter,
            "Blue's point rate" = "Blue",
            "Red's point rate" = "Red",
            "Rate contrast" = "rate_contrast"
        )) %>%
        mutate(parameter = fct_relevel(
            parameter,
            "Blue's point rate",
            "Red's point rate",
            "Rate contrast"
        ))

    plot <-
        draws %>%
        ggplot(aes(x = fct_rev(parameter), y = value)) +
        stat_pointinterval(point_interval = "median_hdci") +
        coord_flip() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = NULL,
            y = NULL
        )

    return(plot)
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

plot_model_tbp <- function(
    model_fit,
    data
) {
    draws <-
        model_fit %>%
        spread_draws(predicted_tbp[t]) %>%
        sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
        ungroup() %>%
        recover_covariates(data, by = "t", team)

    plot <-
        draws %>%
        ggplot(aes(x = predicted_tbp, color = team, group = str_c(.draw, team))) +
        stat_density(geom = "line", position = "identity", alpha = ALPHA) +
        scale_x_log10() +
        scale_color_viridis_d() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time between points (minutes)",
            y = "Density",
            color = "Team"
        )

    return(plot)
}

plot_model_tbp_vs_score <- function(
    model_fit,
    data
) {
    draws <-
        model_fit %>%
        spread_draws(predicted_score[t], predicted_tbp[t]) %>%
        sample_draws(POSTERIOR_PLOT_SAMPLE_COUNT) %>%
        ungroup() %>%
        recover_covariates(data, by = "t", team)

    plot <-
        draws %>%
        rename(Team = team) %>%
        ggplot(aes(x = predicted_score, y = predicted_tbp, group = str_c(.draw, Team))) +
        geom_smooth(se = FALSE, color = alpha("black", ALPHA)) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "Time between points (minutes)"
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
