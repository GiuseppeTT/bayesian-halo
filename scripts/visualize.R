################################################################################
# Source auxiliary files
source(here::here("R/constants.R"))

################################################################################
# Visualize targets
visNetwork::visSave(
    graph = targets::tar_visnetwork(),
    file = NETWORK_PATH
)
