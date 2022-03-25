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
        observed_ttp_plot,
        plot_observed_ttp(train_data)
    ),
    tar_target(
        observed_ttp_vs_time_plot,
        plot_observed_ttp_vs_time(train_data)
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
        prior_model_rate_table,
        table_prior_model_rate(prior_model_fit)
    ),
    tar_target(
        prior_model_rate_plot,
        plot_prior_model_rate(prior_model_fit)
    ),
    tar_target(
        prior_model_score_plot,
        plot_prior_model_score(prior_model_fit)
    ),
    tar_target(
        prior_model_ttp_plot,
        plot_prior_model_ttp(prior_model_fit)
    ),
    tar_target(
        prior_model_ttp_vs_time_plot,
        plot_prior_model_ttp_vs_time(prior_model_fit)
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

model_targets <- list(
    tar_file(
        model_path,
        MODEL_PATH
    ),
    tar_target(
        model,
        create_model(model_path)
    ),
    tar_target(
        model_data,
        create_model_data(test_data)
    ),
    tar_target(
        model_fit,
        fit_model(model, model_data, test_data)
    ),
    tar_target(
        model_rate_table,
        table_model_rate(model_fit)
    ),
    tar_target(
        model_contrast_table,
        table_model_contrast(model_fit)
    ),
    tar_target(
        model_rate_plot,
        plot_model_rate(model_fit)
    ),
    tar_target(
        model_contrast_plot,
        plot_model_contrast(model_fit)
    ),
    tar_target(
        model_score_plot,
        plot_model_score(model_fit, test_data)
    ),
    tar_target(
        model_ttp_plot,
        plot_model_ttp(model_fit, test_data)
    ),
    tar_target(
        model_ttp_vs_time_plot,
        plot_model_ttp_vs_time(model_fit, test_data)
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
    test_data_targets,
    model_targets,
    report_targets
)

targets
