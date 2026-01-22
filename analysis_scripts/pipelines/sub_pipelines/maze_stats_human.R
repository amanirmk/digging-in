# EXPECTS human_data, by_item.R, comprehension_filter.R, run_brms.R to be loaded already

# RESPONSE TIME

# maximal (filter by resolution/finality or code together)
# critical and then spillover for nonfinal
# critical-onward and critical-only for nonfinal
for (finality in c("final", "nonfinal")) {
  for (resolution in c("all", "comma", "object")) {
    for (critonward in c(FALSE, TRUE)) {
      for (critoffset in c(0, 1)) {

        if (critoffset == 1 & (finality == "final" || finality == "all")) {
          next
        }
        if (critoffset == 1 & critonward == TRUE) {
          next
        }
        if (critonward == TRUE & finality == "final") {
          next
        }

        brm_data <- human_data %>%
          filter(item_category == "critical") %>%
          comprehension_filter(type="maze")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data)
        }

        if (resolution == "comma") {
          brm_data <- brm_data %>% filter(resolution == "comma")
        } else if (resolution == "object") {
          brm_data <- brm_data %>% filter(resolution == "object")
        }

        if (finality == "final") {
          brm_data <- brm_data %>% filter(finality == "final")
        } else {
          brm_data <- brm_data %>% filter(finality == "nonfinal")
        }

        brm_data <- brm_data %>%
          filter(word_index == critical_word_index + critoffset) %>%
          code_npz_data()

        run_brms(
          formula = as.formula("RT ~ ambiguity * length + (ambiguity * length | participant) + (ambiguity * length | item)"),
          data = brm_data,
          file_path = here("analysis_outputs", "npz_maze_stats", "empirical", paste0("rt_ambxlen_", finality, "_", resolution, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}

# ACCURACY

# maximal (filter by resolution/finality or code together)
# critical and then spillover for nonfinal
# critical-onward and critical-only for nonfinal
for (finality in c("final", "nonfinal")) {
  for (resolution in c("all", "comma", "object")) {
    for (critonward in c(FALSE, TRUE)) {
      for (critoffset in c(0, 1)) {

        if (critoffset == 1 & (finality == "final" || finality == "all")) {
          next
        }
        if (critoffset == 1 & critonward == TRUE) {
          next
        }
        if (critonward == TRUE & finality == "final") {
          next
        }

        brm_data <- human_data %>%
          filter(item_category == "critical") %>%
          comprehension_filter(type="maze")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data)
        }

        if (resolution == "comma") {
          brm_data <- brm_data %>% filter(resolution == "comma")
        } else if (resolution == "object") {
          brm_data <- brm_data %>% filter(resolution == "object")
        }

        if (finality == "final") {
          brm_data <- brm_data %>% filter(finality == "final")
        } else {
          brm_data <- brm_data %>% filter(finality == "nonfinal")
        }

        brm_data <- brm_data %>%
          filter(word_index == critical_word_index + critoffset) %>%
          code_npz_data()

        run_brms(
          formula = as.formula("correct ~ ambiguity * length + (ambiguity * length | participant) + (ambiguity * length | item)"),
          data = brm_data,
          family = bernoulli(link = "logit"),
          file_path = here("analysis_outputs", "npz_maze_stats", "empirical", paste0("correct_ambxlen_", finality, "_", resolution, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}