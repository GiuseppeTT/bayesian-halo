# Bayesian Halo

## Description
TODO.

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
