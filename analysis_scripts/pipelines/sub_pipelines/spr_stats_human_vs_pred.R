# EXPECTS human_data, pred_data, by_item.R, comprehension_filter.R, combine.R, run_brms.R to be loaded already

 human <- human_data %>%
  filter(item_category == "critical") %>%
  comprehension_filter(type="spr") %>%
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

pred <- pred_data %>%
  filter(item_category == "critical") %>%
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "word_index")

all <- human %>%
  left_join(pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "word_index"), suffix = c("_human", "_pred")) %>%
  left_join(human_data %>% select(item, word_index, ambiguity, length, resolution, finality, region, critical_word_index) %>% distinct(), by = c("item", "word_index", "ambiguity", "length", "resolution", "finality"))


dfs <- list()

for (finality_type in c("all", "final", "nonfinal")) {
  for (resolution_type in c("all", "comma", "object")) {
    for (region in c("all", "critical", "non-critical", "pre-critical", "post-critical")) {
      for (ambiguity_type in c("all", "ambiguous", "unambiguous")) {
        for (length_type in c("all", "short", "long")) {

          if (region == "post-critical" & finality_type == "final") {
            next
          }
          if (ambiguity_type == "ambiguous" & resolution_type != "all") {
            next
          }

          data <- all
          
          if (finality_type != "all") {
            data <- data %>% filter(finality == finality_type)
          }

          if (resolution_type != "all") {
            data <- data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
          }

          if (region == "critical") {
            data <- data %>% filter(region == "critical")
          } else if (region == "non-critical") {
            data <- data %>% filter(region != "critical")
          } else if (region == "pre-critical") {
            data <- data %>% filter(word_index < critical_word_index)
          } else if (region == "post-critical") {
            data <- data %>% filter(word_index > critical_word_index)
          }

          if (ambiguity_type != "all") {
            data <- data %>% filter(ambiguity == ambiguity_type)
          }

          if (length_type != "all") {
            data <- data %>% filter(length == length_type)
          }

          # Correlation of human and predicted
          cor_result <- cor.test(data$RT_human, data$RT_pred, method = "pearson")
          resid_mean <- mean(data$RT_human - data$RT_pred)
          rmse <- sqrt(mean((data$RT_human - data$RT_pred)**2))
          cor_df <- data.frame(
            ambiguity = ambiguity_type,
            length = length_type,
            finality = finality_type,
            resolution = resolution_type,
            region = region,
            cor_estimate = cor_result$estimate,
            r_2 = cor_result$estimate^2,
            cor_p_value = cor_result$p.value,
            rmse = rmse,
            resid_mean = resid_mean
          )
          dfs[[paste(finality_type, resolution_type, region, ambiguity_type, length_type, sep = "_")]] <- cor_df
}}}}}

df <- do.call(rbind, dfs)
file <- here("analysis_outputs", "npz_spr_stats", "human_vs_pred", "correlations.txt")
dir_path <- dirname(file)
dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
write.table(df, file = file, sep = ",", row.names = FALSE, quote = FALSE)



# with 3-word window

human <- human_data %>%
  filter(item_category == "critical") %>%
  comprehension_filter(type="spr") %>%
  combine_critrel_groups(critrel_size = 3) %>%
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

pred <- pred_data %>%
  filter(item_category == "critical") %>%
  combine_critrel_groups(critrel_size = 3) %>%
  by_item_condition_average(resolution = "separate", y_var = "RT", x_var = "critrel_group")

all <- human %>%
  left_join(pred, by = c("item_category", "item", "ambiguity", "length", "resolution", "finality", "critrel_group"), suffix = c("_human", "_pred"))

dfs <- list()

for (finality_type in c("all", "final", "nonfinal")) {
  for (resolution_type in c("all", "comma", "object")) {
    for (region in c("all", "critical", "non-critical", "pre-critical", "post-critical")) {
      for (ambiguity_type in c("all", "ambiguous", "unambiguous")) {
        for (length_type in c("all", "short", "long")) {

          if (region == "post-critical" & finality_type == "final") {
            next
          }
          if (ambiguity_type == "ambiguous" & resolution_type != "all") {
            next
          }

          data <- all
          
          if (finality_type != "all") {
            data <- data %>% filter(finality == finality_type)
          }

          if (resolution_type != "all") {
            data <- data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
          }

          if (region == "critical") {
            data <- data %>% filter(critrel_group == 0)
          } else if (region == "non-critical") {
            data <- data %>% filter(critrel_group != 0)
          } else if (region == "pre-critical") {
            data <- data %>% filter(critrel_group < 0)
          } else if (region == "post-critical") {
            data <- data %>% filter(critrel_group > 0)
          }

          if (ambiguity_type != "all") {
            data <- data %>% filter(ambiguity == ambiguity_type)
          }

          if (length_type != "all") {
            data <- data %>% filter(length == length_type)
          }

          # Correlation of human and predicted
          cor_result <- cor.test(data$RT_human, data$RT_pred, method = "pearson")
          resid_mean <- mean(data$RT_human - data$RT_pred)
          rmse <- sqrt(mean((data$RT_human - data$RT_pred)**2))
          cor_df <- data.frame(
            ambiguity = ambiguity_type,
            length = length_type,
            finality = finality_type,
            resolution = resolution_type,
            region = region,
            cor_estimate = cor_result$estimate,
            r_2 = cor_result$estimate^2,
            cor_p_value = cor_result$p.value,
            rmse = rmse,
            resid_mean = resid_mean
          )
          dfs[[paste(finality_type, resolution_type, region, ambiguity_type, length_type, sep = "_")]] <- cor_df
}}}}}

df <- do.call(rbind, dfs)
file <- here("analysis_outputs", "npz_spr_stats", "human_vs_pred", "correlations_chunk3.txt")
dir_path <- dirname(file)
dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
write.table(df, file = file, sep = ",", row.names = FALSE, quote = FALSE)