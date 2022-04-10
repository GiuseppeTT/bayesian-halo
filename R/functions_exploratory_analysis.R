################################################################################
# Define functions
plot_observed_score <- function(
    data
) {
    plot <-
        data %>%
        ggplot(aes(x = time, y = score, linetype = team)) +
        geom_step(size = 2) +
        scale_x_continuous(limits = c(GAME_MIN_TIME, GAME_MAX_TIME)) +
        scale_y_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Time (minutes)",
            y = "Score",
            linetype = "Team"
        )

    return(plot)
}

plot_observed_tbp_vs_score <- function(
    data
) {
    plot <-
        data %>%
        rename(Team = team) %>%
        ggplot(aes(x = score, y = 60 * tbp)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "TBP (seconds)"
        )

    return(plot)
}

plot_observed_tbp <- function(
    data
) {
    plot <-
        data %>%
        ggplot(aes(x = 60 * tbp, linetype = team)) +
        geom_density(size = 2) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "TBP (seconds)",
            y = "Density",
            linetype = "Team"
        )

    return(plot)
}

plot_observed_tbp_vs_lag_tbp <- function(
    data
) {
    plot <-
        data %>%
        rename(Team = team) %>%
        ggplot(aes(x = 60 * lag(tbp), y = 60 * tbp)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_log10() +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Previous TBP (seconds)",
            y = "TBP (seconds)"
        )

    return(plot)
}

plot_observed_window_tbp <- function(
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
        ggplot(aes(x = 60 * Red, y = 60 * Blue)) +
        geom_point() +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), size = 2) +
        scale_x_log10() +
        scale_y_log10() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Team red' TBP (seconds)",
            y = "Team blue's TBP (seconds)"
        )

    return(plot)
}
