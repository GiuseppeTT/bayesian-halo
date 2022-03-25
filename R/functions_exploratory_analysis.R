################################################################################
# Define functions
plot_observed_score <- function(
    data
) {
    plot <-
        data %>%
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

plot_observed_ttp <- function(
    data
) {
    plot <-
        data %>%
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

plot_observed_ttp_vs_score <- function(
    data
) {
    plot <-
        data %>%
        rename(Team = team) %>%
        ggplot(aes(x = score, y = ttp)) +
        geom_point() +
        geom_smooth(size = 2) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "Time to point (minutes)"
        )

    return(plot)
}
