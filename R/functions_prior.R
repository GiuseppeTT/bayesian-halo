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
        scale_x_continuous(limits = c(GAME_MIN_TIME, GAME_MAX_TIME)) +
        scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Score",
            color = "Team"
        )

    return(plot)
}
