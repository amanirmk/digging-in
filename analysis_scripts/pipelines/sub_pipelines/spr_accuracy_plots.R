
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
    # average by item and condition, average resolution (combines unambiguous levels)
    by_item_condition_average(resolution = "average", y_var = "correct", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
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
    title = paste0("Comprehension Accuracy (", figure_suffix, " items)"),
    width = 5,
    height = 3,
    figure_path = here("analysis_outputs", "npz_spr_figs", "accuracy", paste0("empirical_accuracy_bar_", figure_suffix, img_filetype)),
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
    # average by item and condition, average resolution (combines unambiguous levels)
    by_item_condition_average(resolution = "average", y_var = "correct", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
    filter(critical_relative == 0) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "correct", x_var = "critical_relative") %>%
    code_npz_data()

    bar_plot(plot_data,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
      y_var = "correct",
      x_var = "length",
      y_min = -0.2,
      y_max = 0.2,
      y_lab = "Accuracy",
      x_lab = "Length",
      title = paste0("Accuracy GP (", figure_suffix, " items)"),
      width = 3,
      height = 3,
      figure_path = here("analysis_outputs", "npz_spr_figs", "accuracy", paste0("empirical_accuracy_gp_bar_", figure_suffix, img_filetype)),
      legend_position = "none"
    )
}