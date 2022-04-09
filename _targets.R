################################################################################
# Load target libraries
library(targets)
library(tarchetypes)

################################################################################
# Source auxiliary files
source(here::here("R/constants.R"))
source(here::here("R/functions_data.R"))
source(here::here("R/functions_prior.R"))
source(here::here("R/functions_exploratory_analysis.R"))
source(here::here("R/functions_model.R"))

################################################################################
# Set R options
options(tidyverse.quiet = TRUE)

################################################################################
# Set target options
tar_option_set(
    packages = c(
        "tidyverse",
        "cmdstanr",
        "tidybayes"
    )
)

train_data_targets <- list(
    tar_file(
        raw_train_data_path,
        RAW_TRAIN_DATA_PATH
    ),
    tar_target(
        raw_train_data,
        read_raw_data(raw_train_data_path)
    ),
    tar_target(
        is_raw_train_data_valid,
        validate_raw_data(raw_train_data)
    ),
    tar_target(
        train_data,
        command = {
            if (is_raw_train_data_valid) {
                train_data <- clean_data(raw_train_data)
            } else {
                stop("Train data not valid. Check `is_raw_train_data_valid` target")
            }

            train_data
        }
    )
)

exploratory_analysis_targets <- list(
    tar_target(
        observed_score_plot,
        plot_observed_score(train_data)
    ),
    tar_target(
        observed_tbp_vs_score_plot,
        plot_observed_tbp_vs_score(train_data)
    ),
    tar_target(
        observed_tbp_plot,
        plot_observed_tbp(train_data)
    ),
    tar_target(
        observed_tbp_vs_lag_tbp_plot,
        plot_observed_tbp_vs_lag_tbp(train_data)
    ),
    tar_target(
        window_mean_tbp_plot,
        plot_observed_window_mean_tbp(train_data, window_size = WINDOW_SIZE)
    )
)

prior_targets <- list(
    tar_file(
        prior_model_path,
        PRIOR_MODEL_PATH
    ),
    tar_target(
        prior_model,
        create_prior_model(prior_model_path)
    ),
    tar_target(
        prior_model_data,
        create_prior_model_data()
    ),
    tar_target(
        prior_model_fit,
        fit_prior_model(prior_model, prior_model_data)
    ),
    tar_target(
        prior_model_score_plot,
        plot_prior_model_score(prior_model_fit)
    )
)

train_model_targets <- list(
    tar_file(
        train_model_path,
        MODEL_PATH
    ),
    tar_target(
        train_model,
        create_model(train_model_path)
    ),
    tar_target(
        train_model_data,
        create_model_data(train_data)
    ),
    tar_target(
        train_model_fit,
        fit_model(train_model, train_model_data, train_data)
    ),
    tar_file(
        train_prediction_model_path,
        PREDICTION_MODEL_PATH
    ),
    tar_target(
        train_model_predictions,
        cumulative_predict(
            stan_one_step_predict,
            train_data,
            prediction_model_path = train_prediction_model_path
        )
    ),
    tar_target(
        train_model_rmse,
        calculate_model_rmse(train_model_predictions)
    ),
    tar_target(
        train_model_mae,
        calculate_model_mae(train_model_predictions)
    ),
    tar_target(
        train_model_prediction_coverage,
        calculate_model_prediction_coverage(train_model_predictions)
    ),
    tar_target(
        train_model_prediction_plot,
        plot_model_predictions(train_model_predictions)
    ),
    tar_target(
        train_model_residue_plot,
        plot_model_residues(train_model_predictions)
    ),
    tar_target(
        train_model_rate_table,
        table_model_rate(train_model_fit)
    ),
    tar_target(
        train_model_score_plot,
        plot_model_score(train_model_fit, train_data)
    )
)

test_data_targets <- list(
    tar_file(
        raw_test_data_path,
        RAW_TEST_DATA_PATH
    ),
    tar_target(
        raw_test_data,
        read_raw_data(raw_test_data_path)
    ),
    tar_target(
        is_raw_test_data_valid,
        validate_raw_data(raw_test_data)
    ),
    tar_target(
        test_data,
        command = {
            if (is_raw_test_data_valid) {
                test_data <- clean_data(raw_test_data)
            } else {
                stop("test data not valid. Check `is_raw_test_data_valid` target")
            }

            test_data
        }
    )
)

test_model_targets <- list(
    tar_target(
        test_score_plot,
        plot_observed_score(test_data)
    ),
    tar_file(
        test_model_path,
        MODEL_PATH
    ),
    tar_target(
        test_model,
        create_model(test_model_path)
    ),
    tar_target(
        test_model_data,
        create_model_data(test_data)
    ),
    tar_target(
        test_model_fit,
        fit_model(test_model, test_model_data, test_data)
    ),
    tar_file(
        test_prediction_model_path,
        PREDICTION_MODEL_PATH
    ),
    tar_target(
        test_model_predictions,
        cumulative_predict(
            stan_one_step_predict,
            test_data,
            prediction_model_path = test_prediction_model_path
        )
    ),
    tar_target(
        test_model_rmse,
        calculate_model_rmse(test_model_predictions)
    ),
    tar_target(
        test_model_mae,
        calculate_model_mae(test_model_predictions)
    ),
    tar_target(
        test_model_prediction_coverage,
        calculate_model_prediction_coverage(test_model_predictions, threshold = THRESHOLD)
    ),
    tar_target(
        test_model_interval_median_size,
        calculate_model_interval_median_size(test_model_predictions)
    ),
    tar_target(
        test_model_prediction_plot,
        plot_model_predictions(test_model_predictions)
    ),
    tar_target(
        test_model_residue_plot,
        plot_model_residues(test_model_predictions)
    ),
    tar_target(
        test_model_rate_table,
        table_model_rate(test_model_fit)
    ),
    tar_target(
        test_model_score_plot,
        plot_model_score(test_model_fit, test_data)
    )
)

sad_truth_targets <- list(
    tar_target(
        test_base_predictions,
        cumulative_predict(
            base_one_step_predict,
            test_data
        )
    ),
    tar_target(
        test_base_rmse,
        calculate_model_rmse(test_base_predictions)
    ),
    tar_target(
        test_base_mae,
        calculate_model_mae(test_base_predictions)
    ),
    tar_target(
        test_base_prediction_coverage,
        calculate_model_prediction_coverage(test_base_predictions)
    ),
    tar_target(
        test_base_prediction_plot,
        plot_model_predictions(test_base_predictions)
    ),
    tar_target(
        test_base_residue_plot,
        plot_model_residues(test_base_predictions)
    )
)

report_targets <- list(
    tar_render(
        report,
        REPORT_SOURCE_PATH,
        output_file = REPORT_OUTPUT_PATH
    )
)

targets <- c(
    train_data_targets,
    exploratory_analysis_targets,
    prior_targets,
    train_model_targets,
    test_data_targets,
    test_model_targets,
    sad_truth_targets,
    report_targets
)

targets
