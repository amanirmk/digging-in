
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
    # filter for comprehension question accuracy
    comprehension_filter(type="spr") %>%
    # average by item and condition, average resolution (combines unambiguous levels)
    by_item_condition_average(resolution = "average", y_var = "RT", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
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
      y_var = "RT",
      x_var = "length",
      y_min = -3,
      y_max = 210,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 4.5,
      manual_ybreaks = c(0, 50, 100, 150, 200),
      figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("empirical_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
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
    # average by item and condition, average resolution (combines unambiguous levels)
    by_item_condition_average(resolution = "average", y_var = "surprisal", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "surprisal", x_var = "critical_relative") %>%
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
      figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("surprisal_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
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
    # average by item and condition, average resolution (combines unambiguous levels)
    by_item_condition_average(resolution = "average", y_var = "RT", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
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
      fill_manual = c("short" = "#18999D", "long" = "#C66059"),
      y_var = "RT",
      x_var = "length",
      y_min = -10,
      y_max = 55,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 1.9,
      manual_ybreaks = c(0, 50),
      figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("predicted_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
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
    # filter for comprehension question accuracy
    comprehension_filter(type="spr") %>%
    # average by item and condition, average resolution (combines unambiguous levels)
    resid_by_item_condition_average(pred_data, resolution = "average", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
    filter(critical_relative >= 0 & critical_relative <= 2) %>%
    # get error bars for condition means over items
    over_item_difference_average(y_var = "RT", x_var = "critical_relative") %>%
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
      y_var = "RT",
      x_var = "length",
      y_min = -20,
      y_max = 300,
      y_lab = "Mean GP (ms)",
      x_lab = "Length",
      title = paste0("Critical + ", critrel, " (", figure_suffix, ")"),
      width = 2.5,
      height = 2.5,
      figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("residual_gp_bar_", figure_suffix, "_", critrel, img_filetype)),
      legend_position = "none"
    )
  }
}

# critical and spill for nonfinal

plot_data <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # non-final only
  filter(finality == "nonfinal") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="spr") %>%
  # combine critical-onward
  combine_critical_onward(to_crit_plus=2) %>%
  # average by item and condition, average resolution (combines unambiguous levels)
  by_item_condition_average(resolution = "average", y_var = "RT", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
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
  y_min = -20,
  y_max = 300,
  y_lab = "Mean GP (ms)",
  x_lab = "Length",
  title = paste0("Mean Critical+[0-2]"),
  width = 2.5,
  height = 2.5,
  figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("empirical_gp_bar_nonfinal_crit_thru_spill", img_filetype)),
  legend_position = "none"
)

# critical-onward version for nonfinal

plot_data <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # non-final only
  filter(finality == "nonfinal") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="spr") %>%
  # combine critical-onward
  combine_critical_onward() %>%
  # average by item and condition, average resolution (combines unambiguous levels)
  by_item_condition_average(resolution = "average", y_var = "RT", x_var = "critical_relative", ignore_contrasts = if (finality == "all") c("finality") else NULL) %>%
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
  y_min = -20,
  y_max = 300,
  y_lab = "Mean GP (ms)",
  x_lab = "Length",
  title = paste0("Critical-Onward (nonfinal)"),
  width = 2.5,
  height = 2.5,
  figure_path = here("analysis_outputs", "npz_spr_figs", "gp_bars", paste0("empirical_gp_bar_nonfinal_critonward", img_filetype)),
  legend_position = "none"
)