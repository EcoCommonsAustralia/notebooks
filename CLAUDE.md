# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is the **EcoCommons Australia** notebooks repository — a collection of ecological modelling and geospatial tutorials. Each notebook exists in two formats:
- `.ipynb` — Jupyter notebook (runnable in Google Colab or ARDC Jupyter)
- `.qmd` — Quarto Markdown (runnable in RStudio)

Notebooks are organized into two categories:
- **Ecological Modelling** — GLM, Random Forest, Occupancy Models, EOO/AOO
- **Geo/Ecological Skills** — raster format conversions, species data retrieval, imbalanced datasets, richness/diversity

## Updating the README Notebook Table

**Do not edit the notebook table in `README.md` manually.** It is auto-generated.

To add a new notebook:
1. Place both the `.ipynb` and `.qmd` files in `notebooks/`
2. Add a row to `automation/notebooks-table-data.csv` (8 fields: `display_name, notebook_name, econotebook_blogpost_path, youtube_video_path, github_repository_path, arxiv_index, should_open_in_sagemaker_labs, readme_section`)
   - `readme_section` must be either `models` or `skills`
3. Regenerate the table:
   ```bash
   python3 automation/autogenerate_notebooks_table.py
   ```
4. Commit to a feature branch and open a PR.

## Converting QMD to IPYNB

The script `notebooks/Convert_QMDtoipynb.R` converts a `.qmd` file to `.ipynb` using R's `jsonlite`. Edit the `qmd_file` and `ipynb_file` paths at the top before running. It parses ` ```{r} ` code fences into Jupyter code cells; everything else becomes markdown cells.

## Related Repositories

- **[EcoCommonsAustralia/notebook-blog](https://github.com/EcoCommonsAustralia/notebook-blog)** — the Quarto-based static site (hosted on GitHub Pages) that renders notebooks from this repo as human-readable HTML blog posts. Each notebook in `notebooks/` has a corresponding page there, linked via the `econotebook_blogpost_path` column in `automation/notebooks-table-data.csv`.
- **[EcoCommons-Australia-2024-2026/ec-notebook_site_materials](https://github.com/EcoCommons-Australia-2024-2026/ec-notebook_site_materials)** — shared site assets (images, footer) used by notebook-blog.

**Data flow:** This repo holds the executable source files (`.ipynb` / `.qmd`). The notebook-blog consumes those `.qmd` files and publishes them as the browsable documentation site. The README table in this repo links back to the rendered pages on notebook-blog via auto-generated badges.

## R Packages

All R dependencies are listed in `R_packages.qmd`. Key packages include `terra`, `sf`, `raster`, `rgdal`, `galah`, `biomod2`, `randomForest`, `ggplot2`, `tidyverse`, and `leaflet`. Two packages install from GitHub remotes:
- `johnbaums/rmaxent`
- `atlasoflivingaustralia/potions`
