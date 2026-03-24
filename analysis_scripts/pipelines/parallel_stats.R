library(here)
library(tidyverse)
library(lme4)
library(lmerTest)
library(future)

# Load data
source(here("analysis_scripts", "functions", "load_npz_data.R"))
data_list <- load_npz_data("npz_maze")
maze_human_data <- data_list$human
maze_model_data <- data_list$model

data_list <- load_npz_data("npz_spr")
spr_human_data <- data_list$human
spr_model_data <- data_list$model

# Get predicted RTs
source(here("analysis_scripts", "functions", "predict_rts.R"))
maze_pred_data <- predict_rts(maze_human_data, maze_model_data, make_figure = FALSE)
spr_pred_data <- predict_rts(spr_human_data, spr_model_data, make_figure = FALSE)

# Make sure first two words are removed for all data to be consistent across datasets
maze_human_data <- maze_human_data %>% filter(word_index >= 2)
maze_model_data <- maze_model_data %>% filter(word_index >= 2)
maze_pred_data <- maze_pred_data %>% filter(word_index >= 2)

spr_human_data <- spr_human_data %>% filter(word_index >= 2)
spr_model_data <- spr_model_data %>% filter(word_index >= 2)
spr_pred_data <- spr_pred_data %>% filter(word_index >= 2)

# Set up parallel processing

# Currently meant for a 10+ core system, running 2 analysis scripts in parallel with 5 cores each
plan(multisession, workers = 2)

call_sub_pipeline <- function(sub_pipeline) {
  # Set correct global data based on sub-pipeline type
  if (grepl("maze", sub_pipeline)) {
    human_data <- maze_human_data
    model_data <- maze_model_data
    pred_data <- maze_pred_data
  } else if (grepl("spr", sub_pipeline)) {
    human_data <- spr_human_data
    model_data <- spr_model_data
    pred_data <- spr_pred_data
  } else {
    stop("Unknown sub_pipeline type")
  }

  future({
    # Load libraries in the future
    library(here)
    library(tidyverse)
    library(brms)
    library(bayestestR)
    
    # Load functions in the future
    source(here("analysis_scripts", "functions", "by_item.R"))
    source(here("analysis_scripts", "functions", "code_npz_data.R"))
    source(here("analysis_scripts", "functions", "comprehension_filter.R"))
    source(here("analysis_scripts", "functions", "combine.R"))
    source(here("analysis_scripts", "functions", "run_brms.R"))

    # Run the sub-pipeline
    source(here("analysis_scripts", "pipelines", "sub_pipelines", sub_pipeline))
  }, globals = list(
    human_data = human_data,
    model_data = model_data,
    pred_data = pred_data,
    sub_pipeline = sub_pipeline
  ),
  seed = TRUE)
}

# Run sub-pipelines in parallel
sub_pipelines <- c(
  "spr_stats_human_vs_pred.R",
  "maze_stats_human_vs_pred.R",
  "spr_stats_human.R",
  "maze_stats_human.R",
  "spr_stats_pred.R",
  "maze_stats_pred.R",
  "spr_stats_surp.R",
  "maze_stats_surp.R"
)
futures <- lapply(sub_pipelines, call_sub_pipeline)
lapply(futures, value)

# Shut down parallel processing
plan(sequential)