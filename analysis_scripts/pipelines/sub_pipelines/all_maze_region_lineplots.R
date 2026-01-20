# EXPECTS human_data, model_data, pred_data, img_filetype, line_plot.R to be loaded already

excluded_regions <- c("would_be_comma", "comma", "object", "postmod")

for (finality in c("all", "final", "nonfinal")) {
  if (finality == "all") {
    data_subset <- human_data
    figure_suffix <- "all"
  } else if (finality == "final") {
    data_subset <- human_data %>% filter(finality == "final")
    figure_suffix <- "final"
  } else {
    data_subset <- human_data %>% filter(finality == "nonfinal")
    figure_suffix <- "nonfinal"
  }
  
  plot_data <- data_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # filter for pre-critical word accuracy
    comprehension_filter(type="maze") %>%
    # remove regions not in all conditions
    filter(!(region %in% excluded_regions)) %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "region", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "region") %>%
    code_npz_data()
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    y_var = "RT",
    x_var = "region",
    y_min = 700,
    y_max = 2200,
    y_lab = "Response Time (ms)",
    x_lab = "Sentence Region",
    title = paste("Empirical RTs by Sentence Region (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", paste0("rt_by_region_", figure_suffix, img_filetype))
  )
}

# Duplicate of above for surprisal data

for (finality in c("all", "final", "nonfinal")) {
  if (finality == "all") {
    data_subset <- model_data
    figure_suffix <- "all"
  } else if (finality == "final") {
    data_subset <- model_data %>% filter(finality == "final")
    figure_suffix <- "final"
  } else {
    data_subset <- model_data %>% filter(finality == "nonfinal")
    figure_suffix <- "nonfinal"
  }
  
  plot_data <- data_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # remove regions not in all conditions
    filter(!(region %in% excluded_regions)) %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "surprisal", x_var = "region", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "surprisal", x_var = "region") %>%
    code_npz_data()
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#18999D", "long" = "#C66059"),
    y_var = "surprisal",
    x_var = "region",
    y_min = 0,
    y_max = 24,
    y_lab = "Surprisal (bits)",
    x_lab = "Sentence Region",
    title = paste0("LLM Surprisal by Sentence Region (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", paste0("surprisal_by_region_", figure_suffix, img_filetype))
  )
}

# Duplicate of above for predicted data

for (finality in c("all", "final", "nonfinal")) {
  if (finality == "all") {
    data_subset <- pred_data
    figure_suffix <- "all"
  } else if (finality == "final") {
    data_subset <- pred_data %>% filter(finality == "final")
    figure_suffix <- "final"
  } else {
    data_subset <- pred_data %>% filter(finality == "nonfinal")
    figure_suffix <- "nonfinal"
  }
  
  plot_data <- data_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # remove regions not in all conditions
    filter(!(region %in% excluded_regions)) %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "region", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "region") %>%
    code_npz_data()
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#18999D", "long" = "#C66059"),
    y_var = "RT",
    x_var = "region",
    y_min = 700,
    y_max = 1500,
    y_lab = "Response Time (ms)",
    x_lab = "Sentence Region",
    title = paste0("Predicted RTs by Sentence Region (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", paste0("pred_rt_by_region_", figure_suffix, img_filetype))
  )
}

# Duplicate of above for residual data

for (finality in c("all", "final", "nonfinal")) {
  if (finality == "all") {
    data_subset <- human_data
    figure_suffix <- "all"
  } else if (finality == "final") {
    data_subset <- human_data %>% filter(finality == "final")
    figure_suffix <- "final"
  } else {
    data_subset <- human_data %>% filter(finality == "nonfinal")
    figure_suffix <- "nonfinal"
  }

  plot_data <- data_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # filter for pre-critical word accuracy
    comprehension_filter(type="maze") %>%
    # remove regions not in all conditions
    filter(!(region %in% excluded_regions)) %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    resid_by_item_condition_average(pred_data, resolution = "ignore", x_var = "region", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "region") %>%
    code_npz_data()
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#18999D", "long" = "#C66059"),
    y_var = "RT",
    x_var = "region",
    y_min = -400,
    y_max = 800,
    y_lab = "Residual Response Time (ms)",
    x_lab = "Sentence Region",
    title = paste0("Residual RTs by Sentence Region (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", paste0("resid_rt_by_region_", figure_suffix, img_filetype))
  )
}