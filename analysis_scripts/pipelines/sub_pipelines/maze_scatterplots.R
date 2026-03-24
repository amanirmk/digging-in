
# ALL DATA

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="maze") %>%
  # average by item and condition, ignore resolution
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "word_index", ignore_contrasts = c("finality"))

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition, ignore resolution
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "word_index", ignore_contrasts = c("finality"))

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, region) %>% distinct(), by = c("item", "word_index", "ambiguity", "length"))

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 500,
  crop_y_max = 2200,
  crop_x_min = 710,
  crop_x_max = 1550,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("Maze"),
  figure_path = here("analysis_outputs", "npz_maze_figs", "scatterplots", paste0("empirical_vs_predicted_rt_all", img_filetype)),
  width = 4,
  height = 4,
  legend_position = "right",
)

# CONTRAST BY FINALITY

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="maze") %>%
  # average by item and condition, ignore resolution
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "word_index")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition, ignore resolution
  by_item_condition_average(resolution = "ignore", y_var = "RT", x_var = "word_index")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "finality", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, finality, region) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "finality"))

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 500,
  crop_y_max = 2400,
  crop_x_min = 710,
  crop_x_max = 1550,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("Maze (Finality)"),
  figure_path = here("analysis_outputs", "npz_maze_figs", "scatterplots", paste0("empirical_vs_predicted_rt_finality", img_filetype)),
  width = 6,
  height = 4,
  legend_position = "right",
  facet_var = "finality",
  facet_ncol = 2
)

# CONTRAST BY RESOLUTION

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="maze") %>%
  # average by item and condition, ignore finality
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index", ignore_contrasts = c("finality"))

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition, ignore finality
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index", ignore_contrasts = c("finality"))

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, resolution, region) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "resolution"))

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 500,
  crop_y_max = 2200,
  crop_x_min = 710,
  crop_x_max = 1550,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("Maze (Resolution)"),
  figure_path = here("analysis_outputs", "npz_maze_figs", "scatterplots", paste0("empirical_vs_predicted_rt_resolution", img_filetype)),
  width = 6,
  height = 4,
  legend_position = "right",
  facet_var = "resolution",
  facet_ncol = 2
)