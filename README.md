# bayesian-halo

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

After that, the presentation will be available at `output/github-pages/report.html`.

Notes: you may need to install [docker](https://www.docker.com/).

### Repository structure
The `scripts/make.R` script is the main entrypoint. I recommend to start with this script and later move to `_targets.R`, which defines the pipeline.

Project structure:
- `_targets/`: (Ignored by GitHub) [{targets}](https://docs.ropensci.org/targets/) generated files.
- `.devcontainer/`: [VSCode Remote-Container](https://code.visualstudio.com/docs/remote/containers) files. Used to guarantee a reproducible development environment.
- `.github/`: [GitHub Action](https://github.com/features/actions) files. Used for CI/CD.
- `data/`: Data files.
- `output/`: Output files. The report html file used by GitHub Pages is here.
- `R/`: R files such as utility functions and constants.
- `renv/`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `Rmd/`: Rmd files. The report Rmd file is here.
- `scripts/`: TODO.
- `stan/`: TODO.
- `.gitignore`: List files that git should ignore
- `.Rprofile`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `LICENSE`: License file.
- `renv.lock`: Created by [{renv}](https://rstudio.github.io/renv/articles/renv.html) to setup the virtual environment.
- `README.md`: Must read file. This very file you are reading.
- `_targets_packages.R`: TODO.
- `_targets.R`: TODO.
- `_vscode_packages.R`: TODO.
- `debug.R`: (Ignored by GitHub) a blank R script used for debugging.
