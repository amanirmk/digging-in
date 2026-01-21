# EXPECTS human_data, img_filetype, bar_plot.R, line_plot.R, by_item.R to be loaded already

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "correct", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "correct", x_var = "critical_relative") %>%
    code_npz_data()

  bar_plot_with_pattern(plot_data,
    grouping = "length",
    fill = "length",
    fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    pattern_var = "ambiguity",
    pattern_manual = c("ambiguous" = "stripe", "unambiguous" = "none"),
    y_var = "correct",
    x_var = "length",
    y_min = 0.8,
    y_max = 1.05,
    y_lab = "Accuracy",
    x_lab = "Length",
    title = paste0("Accuracy at Critical (", figure_suffix, " items)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_maze_figs", "accuracy", paste0("crit_bar_", figure_suffix, img_filetype)),
    legend_position = "right"
  )
}

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "correct", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "correct", x_var = "critical_relative") %>%
    code_npz_data()

  for (critrel in c(0, 1, 2)) {
    plot_data_subset <- plot_data %>% filter(critical_relative == critrel)
    # if data is empty, skip
    if (nrow(plot_data_subset) == 0) {
      next
    }
    bar_plot(plot_data_subset,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
      y_var = "correct",
      x_var = "length",
      y_min = -0.2,
      y_max = 0.2,
      y_lab = "Accuracy",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, " items)"),
      width = 3,
      height = 3,
      figure_path = here("analysis_outputs", "npz_maze_figs", "accuracy", paste0("empirical_accuracy_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
}

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
    # remove regions not in all conditions
    filter(!(region %in% excluded_regions)) %>%
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "correct", x_var = "region", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "correct", x_var = "region") %>%
    code_npz_data()
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    y_var = "correct",
    x_var = "region",
    y_min = 0.8,
    y_max = 1.05,
    y_lab = "Accuracy",
    x_lab = "Sentence Region",
    title = paste("Accuracy by Sentence Region (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", "accuracy", paste0("accuracy_by_region_", figure_suffix, img_filetype))
  )
}

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
    # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
    by_item_condition_average(resolution = "ignore", y_var = "correct", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
    # get error bars for condition means over items
    over_item_average(y_var = "correct", x_var = "critical_relative") %>%
    code_npz_data() %>%
    filter(critical_relative >= -3 & critical_relative <= 3)
  
  line_plot(plot_data,
    grouping = "interaction(ambiguity, length)",
    linetype = "ambiguity",
    linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
    color = "length",
    color_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
    y_var = "correct",
    x_var = "critical_relative",
    y_min = 0.8,
    y_max = 1.05,
    y_lab = "Accuracy",
    x_lab = "Critical-Relative Index",
    title = paste("Accuracy by Critical-Relative Index (", figure_suffix, " items)"),
    width = 6,
    height = 4,
    figure_path = here("analysis_outputs", "npz_maze_figs", "accuracy", paste0("accuracy_by_critical_relative_", figure_suffix, img_filetype))
  )
}