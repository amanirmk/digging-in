# EXPECTS model_data, by_item.R, run_brms.R to be loaded already

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

        brm_data <- model_data %>%
          filter(item_category == "critical")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data, y_var="surprisal")
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
          formula = as.formula("surprisal ~ ambiguity * length + (ambiguity * length | model) + (ambiguity * length | item)"),
          data = brm_data,
          file_path = here("analysis_outputs", "npz_maze_stats", "surprisal", paste0("surp_ambxlen_", finality, "_", resolution, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}