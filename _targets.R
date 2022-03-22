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

data_targets <- list(
    tar_file(
        raw_data_path,
        RAW_DATA_PATH
    ),
    tar_target(
        raw_data,
        read_raw_data(raw_data_path)
    ),
    tar_target(
        is_raw_data_valid,
        validate_raw_data(raw_data)
    ),
    tar_target(
        data,
        command = {
            if (is_raw_data_valid) {
                data <- clean_data(raw_data)
            } else {
                stop("Data not valid. Check `is_raw_data_valid` target")
            }

            data
        }
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

exploratory_analysis_targets <- list(
    tar_target(
        observed_score_plot,
        plot_observed_score(data)
    ),
    tar_target(
        observed_ttp_plot,
        plot_observed_ttp(data)
    ),
    tar_target(
        observed_ttp_vs_time_plot,
        plot_observed_ttp_vs_time(data)
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
        create_model_data(data)
    ),
    tar_target(
        model_fit,
        fit_model(model, model_data, data)
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
        plot_model_score(model_fit, data)
    ),
    tar_target(
        model_ttp_plot,
        plot_model_ttp(model_fit, data)
    ),
    tar_target(
        model_ttp_vs_time_plot,
        plot_model_ttp_vs_time(model_fit, data)
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
    data_targets,
    prior_targets,
    exploratory_analysis_targets,
    model_targets,
    report_targets
)

targets
