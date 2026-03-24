
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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "length",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Length",
    title = paste0("Empirical RT at Critical (", figure_suffix, ")"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("empirical_crit_bar_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

# for spillover

for (critrel in c(1, 2)) {
  plot_data <- human_data %>%
    # only critical items
    filter(item_category == "critical") %>%
    # only nonfinal
    filter(finality == "nonfinal") %>%
    # filter for comprehension question accuracy
    comprehension_filter(type="maze") %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == critrel) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "length",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Length",
    title = paste0("Empirical RT at Critical + ", critrel),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("empirical_crit_bar_", critrel, img_filetype)),
    legend_position = "right"
  )
}

# average critical-spillover region

plot_data <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # only non-final items
  filter(finality == "nonfinal") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="maze") %>%
  # combine critical-onward
  combine_critical_onward(to_crit_plus=2) %>%
  # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
  filter(critical_relative == 0) %>%
  # get error bars for condition means over items
  over_item_average(y_var = "RT", x_var = "critical_relative") %>%
  code_npz_data()

bar_plot_with_pattern(plot_data,
  grouping = "length",
  fill = "length",
  fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
  pattern_var = "ambiguity",
  pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
  y_var = "RT",
  x_var = "length",
  y_min = 0,
  y_max = 2100,
  y_lab = "Response Time (ms)",
  x_lab = "Length",
  title = paste0("Mean Empirical RT of Critical+[0-2] (nonfinal)"),
  width = 5,
  height = 3,
  figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("empirical_crit_bar_crit_thru_spill", img_filetype)),
  legend_position = "right"
)

# for surprisal data

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "surprisal", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "surprisal", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#18999D", "long" = "#C66059"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "surprisal",
    x_var = "length",
    y_min = 0,
    y_max = 24,
    y_lab = "Surprisal (bits)",
    x_lab = "Length",
    title = paste0("Surprisal at Critical (", figure_suffix, ")"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("surprisal_crit_bar_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

# for predicted RT data

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#18999D", "long" = "#C66059"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "length",
    y_min = 0,
    y_max = 1500,
    y_lab = "Response Time (ms)",
    x_lab = "Length",
    title = paste0("Predicted RT at Critical (", figure_suffix, ")"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("pred_rt_crit_bar_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

# for residual RT data

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    resid_by_item_condition_average(pred_data, resolution = "ignore", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "length",
    y_min = -100,
    y_max = 800,
    y_lab = "Response Time (ms)",
    x_lab = "Length",
    title = paste0("Residual RT at Critical (", figure_suffix, ")"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("residual_crit_bar_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

# critical-onward 

plot_data <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # only non-final items
  filter(finality == "nonfinal") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="maze") %>%
  # combine critical-onward
  combine_critical_onward() %>%
  # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
  filter(critical_relative == 0) %>%
  # get error bars for condition means over items
  over_item_average(y_var = "RT", x_var = "critical_relative") %>%
  code_npz_data()

bar_plot_with_pattern(plot_data,
  grouping = "length",
  fill = "length",
  fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
  pattern_var = "ambiguity",
  pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
  y_var = "RT",
  x_var = "length",
  y_min = 0,
  y_max = 2100,
  y_lab = "Response Time (ms)",
  x_lab = "Length",
  title = paste0("Empirical RT at Critical-Onward (nonfinal)"),
  width = 5,
  height = 3,
  figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("empirical_crit_bar_nonfinal_critonward", img_filetype)),
  legend_position = "right"
)

for (finality in c("all", "final", "nonfinal")) {
  if (finality == "all") {
    human_subset <- human_data
    pred_subset <- pred_data
    figure_suffix <- "all"
  } else if (finality == "final") {
    human_subset <- human_data %>% filter(finality == "final")
    pred_subset <- pred_data %>% filter(finality == "final")
    figure_suffix <- "final"
  } else {
    human_subset <- human_data %>% filter(finality == "nonfinal")
    pred_subset <- pred_data %>% filter(finality == "nonfinal")
    figure_suffix <- "nonfinal"
  }
  
  human_plot_data <- human_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # filter for pre-critical word accuracy
    comprehension_filter(type="maze") %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  pred_plot_data <- pred_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  human_plot_data$Measurement <- "Empirical"
  pred_plot_data$Measurement <- "Predicted"
  plot_data <- rbind(human_plot_data, pred_plot_data)

  bar_plot_with_pattern(plot_data %>% filter(length == "short"),
    grouping = "Measurement",
    fill = "Measurement",
    fill_manual = c("Empirical" = "#00BFC4", "Predicted" = "#18999D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "ambiguity",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Ambiguity",
    title = paste0("Response Time at Critical (", figure_suffix, ", short)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("combined_crit_bar_short_", figure_suffix, img_filetype)),
    legend_position = "right"
  )

  bar_plot_with_pattern(plot_data %>% filter(length == "long"),
    grouping = "Measurement",
    fill = "Measurement",
    fill_manual = c("Empirical" = "#F8766D", "Predicted" = "#C66059"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "ambiguity",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Ambiguity",
    title = paste0("Response Time at Critical (", figure_suffix, ", long)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("combined_crit_bar_long_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

for (resolution in c("comma", "object")) {
  if (resolution == "comma") {
    human_subset <- human_data %>% filter(resolution == "comma")
    pred_subset <- pred_data %>% filter(resolution == "comma")
    figure_suffix <- "comma"
  } else {
    human_subset <- human_data %>% filter(resolution == "object")
    pred_subset <- pred_data %>% filter(resolution == "object")
    figure_suffix <- "object"
  }
  
  human_plot_data <- human_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # filter for pre-critical word accuracy
    comprehension_filter(type="maze") %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  pred_plot_data <- pred_subset %>%
    # only critical items
    filter(item_category == "critical") %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  human_plot_data$Measurement <- "Empirical"
  pred_plot_data$Measurement <- "Predicted"
  plot_data <- rbind(human_plot_data, pred_plot_data)

  bar_plot_with_pattern(plot_data %>% filter(length == "short"),
    grouping = "Measurement",
    fill = "Measurement",
    fill_manual = c("Empirical" = "#00BFC4", "Predicted" = "#18999D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "ambiguity",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Ambiguity",
    title = paste0("Response Time at Critical (", figure_suffix, ", short)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("combined_crit_bar_short_", figure_suffix, img_filetype)),
    legend_position = "right"
  )

  bar_plot_with_pattern(plot_data %>% filter(length == "long"),
    grouping = "Measurement",
    fill = "Measurement",
    fill_manual = c("Empirical" = "#F8766D", "Predicted" = "#C66059"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "RT",
    x_var = "ambiguity",
    y_min = 0,
    y_max = 2100,
    y_lab = "Response Time (ms)",
    x_lab = "Ambiguity",
    title = paste0("Response Time at Critical (", figure_suffix, ", long)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "critical_bars", paste0("combined_crit_bar_long_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}