################################################################################
# Define functions
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

plot_observed_scores <- function(
    scores
) {
    plot <-
        scores %>%
        ggplot(aes(x = time, y = score, color = team)) +
        geom_step(size = 2) +
        scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
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

plot_observed_ttp_distribution <- function(
    scores
) {
    plot <-
        scores %>%
        ggplot(aes(x = ttp, color = team)) +
        geom_density(size = 2) +
        scale_color_viridis_d() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time to point (minutes)",
            y = "Density",
            color = "Team"
        )

    return(plot)
}

plot_observed_ttp_vs_time <- function(
    scores
) {
    plot <-
        scores %>%
        rename(Team = team) %>%
        ggplot(aes(x = time, y = ttp)) +
        geom_col() +
        geom_smooth(size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Time to point (minutes)"
        )

    return(plot)
}

plot_prior_rate <- function(
    draws
) {
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

plot_prior_scores <- function(
    draws
) {
    plot <-
        draws %>%
        ggplot(aes(x = time, y = score, group = .draw)) +
        geom_step(alpha = ALPHA) +
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

plot_prior_ttp_distribution <- function(
    draws
) {
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

plot_prior_ttp_vs_time <- function(
    draws
) {
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

plot_posterior_rates <- function(
    draws
) {
    plot <-
        draws %>%
        ggplot(aes(x = team, y = rate)) +
        stat_pointinterval(point_interval = "median_hdci") +
        scale_y_continuous(limits = c(0, NA)) +
        coord_flip() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Team",
            y = "Rate"
        )

    return(plot)
}

plot_posterior_contrast <- function(
    draws
) {
    plot <-
        draws %>%
        ggplot(aes(x = "Rate contrast", y = rate_contrast)) +
        stat_pointinterval(point_interval = "median_hdci") +
        geom_hline(yintercept = 0, color = "red", size = 2) +
        coord_flip() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = NULL,
            y = "Rate"
        )

    return(plot)
}

plot_posterior_scores <- function(
    draws,
    scores
) {
    plot <-
        draws %>%
        ggplot(aes(
            x = predicted_time,
            y = predicted_score,
            color = team,
            group = str_c(.draw, team)
        )) +
        geom_step(alpha = ALPHA / 10) +
        geom_step(aes(x = time, y = score, color = team, group = NULL), data = scores, size = 2) +
        scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
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

plot_posterior_ttp_distribution <- function(
    draws
) {
    plot <-
        draws %>%
        ggplot(aes(x = predicted_ttp, color = team, group = str_c(.draw, team))) +
        stat_density(geom = "line", position = "identity", alpha = ALPHA) +
        scale_x_log10() +
        scale_color_viridis_d() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time to point (minutes)",
            y = "Density"
        )

    return(plot)
}

plot_posterior_ttp_vs_time <- function(
    draws
) {
    plot <-
        draws %>%
        rename(Team = team) %>%
        ggplot(aes(x = predicted_time, y = predicted_ttp, group = str_c(.draw, Team))) +
        geom_smooth(se = FALSE, color = alpha("black", ALPHA)) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_DURATION, GAME_MAX_DURATION)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Time to point (minutes)"
        )

    return(plot)
}
