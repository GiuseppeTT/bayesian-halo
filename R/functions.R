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
