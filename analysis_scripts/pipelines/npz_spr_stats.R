library(here)
library(tidyverse)
library(lme4)
library(lmerTest)
library(brms)
library(bayestestR)

# Load data
source(here("analysis_scripts", "functions", "load_npz_data.R"))
data_list <- load_npz_data("npz_spr")
human_data <- data_list$human
model_data <- data_list$model

# Get predicted RTs
source(here("analysis_scripts", "functions", "predict_rts.R"))
pred_data <- predict_rts(human_data, model_data, make_figure = FALSE)

# Make sure first two words are removed for all data to be consistent across datasets
human_data <- human_data %>% filter(word_index >= 2)
model_data <- model_data %>% filter(word_index >= 2)
pred_data <- pred_data %>% filter(word_index >= 2)

# Load additional functions
source(here("analysis_scripts", "functions", "by_item.R"))
source(here("analysis_scripts", "functions", "code_npz_data.R"))
source(here("analysis_scripts", "functions", "comprehension_filter.R"))
source(here("analysis_scripts", "functions", "combine.R"))

# Statistics
source(here("analysis_scripts", "functions", "run_brms.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "spr_stats_human.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "spr_stats_pred.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "spr_stats_surp.R"))
source(here("analysis_scripts", "pipelines", "sub_pipelines", "spr_stats_human_vs_pred.R"))