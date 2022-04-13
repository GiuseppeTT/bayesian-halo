# Bayesian Halo

## Description
This repository holds the source code for my analysis of two [Halo Infinite](https://www.xbox.com/games/halo-infinite) matches. You can access the final report here: https://giuseppett.github.io/bayesian-halo/report.html

## Analysis abstract
**Introduction:** I used bayesian stats to model a match of [Halo Infinite](https://www.xbox.com/games/halo-infinite). The game consists of 2 teams of 12 players that must score points by defeating players of the other team. A team wins if it is the first to achieve 100 points or has the biggest score by the 15 minutes mark.

**Results:** The model obtained a median absolute error of 2.6 seconds in predicting when each team will score its next point. Moreover, it provided powerful insights such as estimates for the teams’ performance and the probability of a team winning at any given time.

**Conclusion:** The model was little better than a cumulative average (median absolute error of 3.4 seconds). Therefore, the bayesian model is well suited for a highly accurate analysis, but fails to justify its complexity and computational demand for simpler applications.

## How to use
### ... On VSCode
You can run the project inside a development container by following these steps in VSCode:
- Open VSCode
- Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
- Open the command palette (press `F1` key), select the command "Git: Clone" and clone this repository https://github.com/GiuseppeTT/bayesian-halo.git
- Open the command palette (press `F1` key) and select the command "Remote-Containers: Open Folder in Container..."
- Open a new terminal (press `` ctrl+shift+` ``) and execute the command `Rscript scripts/set_up.R`
- Open a new terminal (press `` ctrl+shift+` ``) and execute the command `Rscript scripts/make.R`

After that, the report will be available at `output/github-pages/report.html`.

Notes: you may need to install [docker](https://www.docker.com/).

## Repository structure
The `scripts/make.R` script is the main entrypoint. I recommend to start with this script and later move to `_targets.R`, which defines the pipeline. You may also want to check `.github/workflows/deply.yaml` which is reponsible for running the pipeline on GitHub and deploying to report to GitHub pages.

Project structure:
- `_targets/`: (Ignored by GitHub) [{targets}](https://docs.ropensci.org/targets/) generated files. Hold caches results.
- `.devcontainer/`: [VSCode Remote-Container](https://code.visualstudio.com/docs/remote/containers) files. Used to guarantee a reproducible development environment.
- `.github/`: [GitHub Action](https://github.com/features/actions) files. Used for CI/CD.
- `data/`: Data files.
- `output/`: Output files. The report html file used by GitHub Pages is here.
- `R/`: R files such as utility functions and constants.
- `renv/`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `Rmd/`: Rmd files. The source Rmd file for the report is here.
- `scripts/`: Utility scripts.
- `stan/`: [stan](https://mc-stan.org/cmdstanr/) files.
- `.gitignore`: List files that git should ignore.
- `.Rprofile`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `LICENSE`: License file.
- `renv.lock`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `README.md`: Must read file. This very file you are reading.
- `_targets_packages.R`: Created by [{targets}](https://docs.ropensci.org/targets/) so that [{renv}](https://rstudio.github.io/renv/articles/renv.html) can find R packages used in the pipeline (`_targets.R`).
- `_targets.R`: Defines the [{targets}](https://docs.ropensci.org/targets/) pipeline.
- `_vscode_packages.R`: Manually created so that [{renv}](https://rstudio.github.io/renv/articles/renv.html) can find R pacakges necessary to use R in VSCode.
- `debug.R`: (Ignored by GitHub) a blank R script used for debugging.
