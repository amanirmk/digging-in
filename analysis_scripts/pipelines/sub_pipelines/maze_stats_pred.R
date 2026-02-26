
# RESPONSE TIME

# maximal (filter by resolution/finality or code together)
# critical and then spillover for nonfinal
# critical-onward and critical-only for nonfinal
for (finality_type in c("all", "final", "nonfinal")) {
  for (resolution_type in c("all", "comma", "object")) {
    for (critonward in c(FALSE, TRUE)) {
      for (critoffset in c(0, 1)) {

        if (critoffset == 1 & (finality_type == "final" || finality_type == "all")) {
          next
        }
        if (critoffset == 1 & critonward == TRUE) {
          next
        }
        if (critonward == TRUE & finality_type == "final") {
          next
        }

        brm_data <- pred_data %>%
          filter(item_category == "critical")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data)
        }

        if (resolution_type != "all") {
          brm_data <- brm_data %>% filter(resolution == resolution_type)
        }

        if (finality_type != "all") {
          brm_data <- brm_data %>% filter(finality == finality_type)
        }

        brm_data <- brm_data %>%
          filter(word_index == critical_word_index + critoffset) %>%
          code_npz_data()

        run_brms(
          formula = as.formula("RT ~ ambiguity * length + (ambiguity * length | model) + (ambiguity * length | item)"),
          data = brm_data,
          file_path = here("analysis_outputs", "npz_maze_stats", "predicted", paste0("rt_ambxlen_", finality_type, "_", resolution_type, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}