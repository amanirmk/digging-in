
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
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  for (critrel in c(0, 1, 2)) {
    plot_data_subset <- plot_data %>% filter(critical_relative == critrel)
    if (finality != "nonfinal" & critrel > 0) {
      next
    }
    bar_plot(plot_data_subset,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
      y_var = "RT",
      x_var = "length",
      y_min = -50,
      y_max = 750,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 4.5,
      manual_ybreaks = c(0, 200, 400, 600),
      figure_path = here("analysis_outputs", "npz_maze_figs", "gp_bars", paste0("empirical_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
}

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
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "surprisal", x_var = "critical_relative") %>%
    code_npz_data()

  for (critrel in c(0, 1, 2)) {
    plot_data_subset <- plot_data %>% filter(critical_relative == critrel)
    if (finality != "nonfinal" & critrel > 0) {
      next
    }
    bar_plot(plot_data_subset,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#18999D", "long" = "#C66059"),
      y_var = "surprisal",
      x_var = "length",
      y_min = -1,
      y_max = 10,
      y_lab = "Mean GP (bits)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 2.5,
      manual_ybreaks = c(0, 4, 8),
      figure_path = here("analysis_outputs", "npz_maze_figs", "gp_bars", paste0("surprisal_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
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
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  for (critrel in c(0, 1, 2)) {
    plot_data_subset <- plot_data %>% filter(critical_relative == critrel)
    if (finality != "nonfinal" & critrel > 0) {
      next
    }
    bar_plot(plot_data_subset,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#18999D", "long" = "#C66059"),
      y_var = "RT",
      x_var = "length",
      y_min = -75,
      y_max = 250,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 2.25,
      manual_ybreaks = c(0, 200),
      figure_path = here("analysis_outputs", "npz_maze_figs", "gp_bars", paste0("predicted_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
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
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
    code_npz_data()

  for (critrel in c(0, 1, 2)) {
    plot_data_subset <- plot_data %>% filter(critical_relative == critrel)
    if (finality != "nonfinal" & critrel > 0) {
      next
    }
    bar_plot(plot_data_subset,
      grouping = "length",
      fill = "length",
      fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
      y_var = "RT",
      x_var = "length",
      y_min = -100,
      y_max = 600,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 2.5,
      figure_path = here("analysis_outputs", "npz_maze_figs", "gp_bars", paste0("residual_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
}

# for non-final

plot_data <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # non-final only
  filter(finality == "nonfinal") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="maze") %>%
  # combine critical-onward
  combine_critical_onward() %>%
  # average by item and condition, ignore finality and resolution (between-item contrasts in Maze)
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "critical_relative", ignore_contrasts = c("finality")) %>%
  filter(critical_relative == 0) %>%
  # get error bars for condition means over items
  over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
  code_npz_data()

bar_plot(plot_data,
  grouping = "length",
  fill = "length",
  fill_manual = c("short" = "#00BFC4", "long" = "#F8766D"),
  y_var = "RT",
  x_var = "length",
  y_min = -50,
  y_max = 800,
  y_lab = "Mean GP (ms)",
  x_lab = "Length",
  title = paste0("Critical-Onward (nonfinal)"),
  width = 2.5,
  height = 2.5,
  figure_path = here("analysis_outputs", "npz_maze_figs", "gp_bars", paste0("empirical_gp_bar_nonfinal_critonward", img_filetype)),
  legend_position = "none"
)