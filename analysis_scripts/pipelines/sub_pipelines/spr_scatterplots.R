
# ALL DATA

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="spr") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, resolution, finality, region, critical_word_index) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "resolution", "finality"))

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 200,
  crop_y_max = 1200,
  crop_x_min = 230,
  crop_x_max = 672,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("SPR"),
  figure_path = here("analysis_outputs", "npz_spr_figs", "scatterplots", paste0("empirical_vs_predicted_rt_all", img_filetype)),
  width = 4,
  height = 4,
  legend_position = "right",
)

# WITH 3-WORD WINDOWS

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="spr") %>%
  # chunk into 3-word averages in relation to critical word
  combine_critrel_groups(critrel_size = 3) %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # chunk into 3-word averages in relation to critical word
  combine_critrel_groups(critrel_size = 3) %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "critrel_group"), suffix = c("_human", "_pred")) %>%
  filter(critrel_group <= 0)

plot_data$length <- ifelse(plot_data$critrel_group == 0, plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 200,
  crop_y_max = 1200,
  crop_x_min = 230,
  crop_x_max = 672,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("SPR"),
  figure_path = here("analysis_outputs", "npz_spr_figs", "scatterplots", paste0("empirical_vs_predicted_rt_all_chunk3", img_filetype)),
  width = 4,
  height = 4,
  legend_position = "right",
)

# CONTRAST BY FINALITY

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for pre-critical word accuracy
  comprehension_filter(type="spr") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, resolution, finality, region) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "resolution", "finality"))

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 200,
  crop_y_max = 1200,
  crop_x_min = 230,
  crop_x_max = 672,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("SPR (Finality)"),
  figure_path = here("analysis_outputs", "npz_spr_figs", "scatterplots", paste0("empirical_vs_predicted_rt_finality", img_filetype)),
  width = 6,
  height = 4,
  legend_position = "right",
  facet_var = "finality",
  facet_ncol = 2
)

# WITH 3-WORD WINDOWS

plot_data_human <- human_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # filter for comprehension question accuracy
  comprehension_filter(type="spr") %>%
  # chunk into 3-word averages in relation to critical word
  combine_critrel_groups(critrel_size = 3) %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # chunk into 3-word averages in relation to critical word
  combine_critrel_groups(critrel_size = 3) %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "critrel_group"), suffix = c("_human", "_pred")) %>%
  filter(critrel_group <= 0)

plot_data$length <- ifelse(plot_data$critrel_group == 0, plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 200,
  crop_y_max = 1200,
  crop_x_min = 230,
  crop_x_max = 672,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("SPR (Finality)"),
  figure_path = here("analysis_outputs", "npz_spr_figs", "scatterplots", paste0("empirical_vs_predicted_rt_finality_chunk3", img_filetype)),
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
  comprehension_filter(type="spr") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data_pred <- pred_data %>%
  # only critical items
  filter(item_category == "critical") %>%
  # average by item and condition
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

plot_data <- plot_data_human %>%
  left_join(plot_data_pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, resolution, finality, region) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "resolution", "finality"))

# for simplicity in facets, double the ambiguous level with one for each resolution
unambiguous <- plot_data %>% filter(ambiguity == "unambiguous")
ambiguous_comma <- plot_data %>% filter(ambiguity == "ambiguous")
ambiguous_comma$resolution <- "comma"
ambiguous_object <- plot_data %>% filter(ambiguity == "ambiguous")
ambiguous_object$resolution <- "object"
plot_data <- bind_rows(unambiguous, ambiguous_comma, ambiguous_object)

plot_data$length <- ifelse(plot_data$region == "critical", plot_data$length, "non-critical region")
plot_data$length <- factor(plot_data$length, levels = c("non-critical region", "short", "long"), ordered = TRUE)
plot_data <- plot_data %>% arrange(length)

scatter_plot(plot_data,
  x_var = "RT_pred",
  y_var = "RT_human",
  color = "length",
  shape = "ambiguity",
  crop_y_min = 200,
  crop_y_max = 1200,
  crop_x_min = 230,
  crop_x_max = 672,
  color_manual = c("non-critical region" = "black", "short" = "#00BFC4", "long" = "#F8766D"),
  shape_manual = c("ambiguous" = 4, "unambiguous" = 16),
  loess_linetype = "ambiguity",
  loess_linetype_manual = c("ambiguous" = "41", "unambiguous" = "solid"),
  x_lab = "Predicted RT (ms)",
  y_lab = "Empirical RT (ms)",
  title = paste0("SPR (Resolution)"),
  figure_path = here("analysis_outputs", "npz_spr_figs", "scatterplots", paste0("empirical_vs_predicted_rt_resolution", img_filetype)),
  width = 6,
  height = 4,
  legend_position = "right",
  facet_var = "resolution",
  facet_ncol = 2
)