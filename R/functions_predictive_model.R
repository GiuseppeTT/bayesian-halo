################################################################################
# Define functions
cumulative_predict <- function(
    one_step_predict_function,
    data,
    ...
) {
    data <-
        data %>%
        arrange(time)

    predictions <-
        data %>%
        slider::slide(
            one_step_predict_function,
            ...,
            .before = Inf
        ) %>%
        bind_rows()

    selected_data <-
        data %>%
        select(time, team, score)

    predictions <-
        predictions %>%
        right_join(selected_data, by = c("team", "score"))

    predictions <-
        predictions %>%
        drop_na(.predicted) %>%
        relocate(time, .after = score)

    predictions <-
        predictions %>%
        mutate(.size = .upper - .lower) %>%
        mutate(.contain = (.lower <= time) & (time <= .upper)) %>%
        mutate(.residue = time - .predicted)

    return(predictions)
}

stan_one_step_predict <- function(
    data,
    prediction_model_path
) {
    prediction_model <- create_model(prediction_model_path)

    prediction_model_data <- create_model_data(data)

    prediction_model_fit <- fit_model(
        prediction_model,
        prediction_model_data,
        data
    )

    prediction_model_fit <-
        prediction_model_fit %>%
        recover_types(data)

    prediction <-
        prediction_model_fit %>%
        spread_draws(predicted_time[team]) %>%
        median_hdci() %>%
        ungroup() %>%
        select(team, .predicted = predicted_time, .lower, .upper)

    scores <-
        data %>%
        group_by(team) %>%
        summarise(score = last(score) + 1) %>%
        pull(score)

    prediction <-
        prediction %>%
        mutate(score = scores, .after = team)

    last_team <-
        data %>%
        summarise(team = last(team)) %>%
        pull(team)

    prediction <-
        prediction %>%
        filter(team == last_team)

    return(prediction)
}

base_one_step_predict <- function(
    data
) {
    prediction <-
        data %>%
        drop_na(tbp) %>%
        group_by(team) %>%
        summarise(
            score = last(score) + 1,
            .predicted = last(time) + mean(tbp),
            .lower = last(time) + mean(tbp) + qt(0.05 / 2, df = n() - 1) * sd(tbp) * sqrt(1 + 1 / n()),
            .upper = last(time) + mean(tbp) + qt(1 - 0.05 / 2, df = n() - 1) * sd(tbp) * sqrt(1 + 1 / n())
        )

    last_team <-
        data %>%
        summarise(team = last(team)) %>%
        pull(team)

    prediction <-
        prediction %>%
        filter(team == last_team)

    return(prediction)
}

plot_model_predictions <- function(
    predictions
) {
    plot <-
        predictions %>%
        rename(Team = team) %>%
        ggplot(aes(x = score)) +
        geom_step(aes(y = .predicted), size = 4, alpha = 0.5) +
        geom_point(aes(y = time)) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        scale_y_continuous(limits = c(GAME_MIN_TIME, GAME_MAX_TIME)) +
        coord_flip() +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "Time (minutes)"
        )

    return(plot)
}

plot_model_residues <- function(
    predictions
) {
    plot <-
        predictions %>%
        rename(Team = team) %>%
        mutate(across(where(is.numeric) & !score, ~ 60 * .x)) %>%
        ggplot(aes(x = score, y = .residue)) +
        geom_ribbon(aes(ymin = .lower - .predicted, ymax = .upper - .predicted), alpha = 0.25) +
        geom_line(aes(y = .lower - .predicted), alpha = 0.5) +
        geom_line(aes(y = .upper - .predicted), alpha = 0.5) +
        geom_line(size = 1) +
        facet_grid(cols = vars(Team), labeller = label_both) +
        scale_x_continuous(limits = c(GAME_MIN_SCORE, GAME_MAX_SCORE)) +
        coord_cartesian(ylim = c(-20, 30)) +
        theme_minimal(FONT_SIZE) +
        labs(
            x = "Score",
            y = "Observed - predicted\ntime (seconds)"
        )

    return(plot)
}

calculate_model_rmse <- function(
    predictions
) {
    predictions %>%
        summarise(rmse = sqrt(mean(.residue^2))) %>%
        pull(rmse) %>%
        return()
}

calculate_model_mae <- function(
    predictions
) {
    predictions %>%
        summarise(mae = median(abs(.residue))) %>%
        pull(mae) %>%
        return()
}

calculate_model_coverage <- function(
    predictions,
    threshold = 0 # in seconds
) {
    predictions %>%
        filter(!(!.contain & near(time, .lower, tol = threshold / 60))) %>%
        summarise(coverage = mean(.contain)) %>%
        pull(coverage) %>%
        return()
}

calculate_model_interval_median_size <- function(
    predictions
) {
    predictions %>%
        summarise(median_size = median(.size, na.rm = TRUE)) %>%
        pull(median_size) %>%
        return()
}
