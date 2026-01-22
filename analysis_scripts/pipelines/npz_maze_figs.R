library(here)
library(tidyverse)
library(ggpattern)
library(lme4)
library(lmerTest)

img_filetype <- ".png"

# Load data
source(here("analysis_scripts", "functions", "load_npz_data.R"))
data_list <- load_npz_data("npz_maze")
human_data <- data_list$human
model_data <- data_list$model

# Get predicted RTs
source(here("analysis_scripts", "functions", "predict_rts.R"))
pred_data <- predict_rts(human_data, model_data, make_figure = TRUE, figure_path = here("analysis_outputs", "npz_maze_figs", paste0("coefficients", img_filetype)))

# Make sure first two words are removed for all data to be consistent across datasets
human_data <- human_data %>% filter(word_index >= 2)
model_data <- model_data %>% filter(word_index >= 2)
pred_data <- pred_data %>% filter(word_index >= 2)

# Load additional functions
source(here("analysis_scripts", "functions", "by_item.R"))
source(here("analysis_scripts", "functions", "code_npz_data.R"))
source(here("analysis_scripts", "functions", "comprehension_filter.R"))
source(here("analysis_scripts", "functions", "combine_critical_onward.R"))

# Line plots
source(here("analysis_scripts", "functions", "line_plot.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_region_lineplots.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_critrel_lineplots.R"))

# Bar plots
source(here("analysis_scripts", "functions", "bar_plot.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_gp_barplots.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_critical_barplots.R"))

# Scatter plot
source(here("analysis_scripts", "functions", "scatter_plot.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_scatterplots.R"))

# Accuracy plots
source(here("analysis_scripts", "pipelines", "sub_pipelines", "maze_accuracy_plots.R"))