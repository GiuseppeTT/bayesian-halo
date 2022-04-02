################################################################################
# Define functions
plot_observed_score <- function(
    data
) {
    plot <-
        data %>%
        ggplot(aes(x = time, y = score, color = team)) +
        geom_step(size = 2) +
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

plot_observed_tbp_vs_score <- function(
    data
) {
    plot <-
        data %>%
        rename(Team = team) %>%
        ggplot(aes(x = score, y = tbp)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "Time between points (minutes)"
        )

    return(plot)
}

plot_observed_tbp <- function(
    data
) {
    plot <-
        data %>%
        ggplot(aes(x = tbp, color = team)) +
        geom_density(size = 2) +
        scale_color_viridis_d() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time between points (minutes)",
            y = "Density",
            color = "Team"
        )

    return(plot)
}

plot_observed_tbp_vs_lag_tbp <- function(
    data
) {
    plot <-
        data %>%
        rename(Team = team) %>%
        ggplot(aes(x = lag(tbp), y = tbp)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_log10() +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Lag time between points (minutes)",
            y = "Time between points (minutes)"
        )

    return(plot)
}

plot_observed_window_mean_tbp <- function(
    data,
    window_size  # In seconds
) {
    data <-
        data %>%
        mutate(time = floor(time * 60 / window_size)) %>%
        group_by(team, time) %>%
        summarise(mean = mean(tbp)) %>%
        ungroup()

    data <-
        data %>%
        pivot_wider(names_from = "team", values_from = "mean")

    plot <-
        data %>%
        ggplot(aes(x = Red, y = Blue)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Red time between points (minutes)",
            y = "Blue time between points (minutes)"
        )

    return(plot)
}
