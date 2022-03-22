################################################################################
# Define functions
create_prior_model <- function(
    prior_model_path
) {
    prior_model <- cmdstan_model(
        prior_model_path,
        dir = STAN_OUTPUT_PATH,
        pedantic = TRUE
    )

    return(prior_model)
}

create_prior_model_data <- function(
) {
    prior_model_data <- list(
        max_score = GAME_MAX_SCORE,
        mean_rate_of_rates = PRIOR_MEAN_RATE_OF_RATES
    )

    return(prior_model_data)
}

fit_prior_model <- function(
    prior_model,
    prior_model_data
) {
    prior_model_fit <- prior_model$sample(
        data = prior_model_data,
        seed = SEED,
        chains = 1,
        iter_warmup = 0,
        iter_sampling = PRIOR_MODEL_SAMPLE_COUNT,
        fixed_param = TRUE,
        output_dir = STAN_OUTPUT_PATH
    )

    return(prior_model_fit)
}

table_prior_model_rate <- function(
    prior_model_fit
) {
    prior_model_fit %>%
        spread_draws(rate) %>%
        median_hdci(rate) %>%
        return()
}

plot_prior_model_rate <- function(
    prior_model_fit
) {
    draws <-
        prior_model_fit %>%
        spread_draws(rate)

    plot <-
        draws %>%
        ggplot(aes(x = "Rate", y = rate)) +
        stat_pointinterval(point_interval = "median_hdci") +
        coord_flip() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = NULL,
            y = "Rate"
        )

    return(plot)
}

plot_prior_model_score <- function(
    prior_model_fit
) {
    draws <-
        prior_model_fit %>%
        spread_draws(time[t], score[t])

    plot <-
        draws %>%
        ggplot(aes(x = time, y = score, group = .draw)) +
        geom_step(alpha = 10 * ALPHA) +
        scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
        scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Score",
            color = "Team"
        )

    return(plot)
}

plot_prior_model_ttp <- function(
    prior_model_fit
) {
    draws <-
        prior_model_fit %>%
        spread_draws(ttp[t])

    plot <-
        draws %>%
        ggplot(aes(x = ttp, group = .draw)) +
        geom_density(color = alpha("black", ALPHA)) +
        scale_x_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time to point (minutes)",
            y = "Density"
        )

    return(plot)
}

plot_prior_model_ttp_vs_time <- function(
    prior_model_fit
) {
    draws <-
        prior_model_fit %>%
        spread_draws(time[t], ttp[t])

    plot <-
        draws %>%
        ggplot(aes(x = time, y = ttp, group = .draw)) +
        geom_smooth(se = FALSE, color = alpha("black", ALPHA)) +
        coord_cartesian(xlim = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Time to point (minutes)"
        )

    return(plot)
}
