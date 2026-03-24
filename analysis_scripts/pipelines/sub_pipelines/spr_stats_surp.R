
# RESPONSE TIME

# maximal (filter by resolution or code together)
# critical word only
# critical-onward and critical-only for nonfinal
for (resolution_type in c("all", "comma", "object")) {
  for (critonward in c(FALSE, TRUE)) {
    brm_data <- model_data %>%
      filter(item_category == "critical")

    if (critonward) {
      brm_data <- combine_critical_onward(brm_data, y_var="surprisal")
    }

    if (resolution_type != "all") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
    }

    brm_data <- brm_data %>%
      filter(word_index == critical_word_index) %>%
      code_npz_data()

    run_brms(
      formula = as.formula("surprisal ~ ambiguity * length * finality + (ambiguity * length * finality | model) + (ambiguity * length * finality | item)"),
      data = brm_data,
      file_path = here("analysis_outputs", "npz_spr_stats", "surprisal", paste0("surp_ambxlenxfin_", resolution_type, if (critonward) "_critonward" else "", ".txt"))
    )
  }
}

# final vs non-final (filter by resolution or code together)
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

        brm_data <- model_data %>%
          filter(item_category == "critical")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data, y_var="surprisal")
        }

        if (resolution_type != "all") {
          brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
        }

        if (finality_type != "all") {
          brm_data <- brm_data %>% filter(finality == finality_type)
        }

        brm_data <- brm_data %>%
          filter(word_index == critical_word_index + critoffset) %>%
          code_npz_data()

        run_brms(
          formula = as.formula("surprisal ~ ambiguity * length + (ambiguity * length | model) + (ambiguity * length | item)"),
          data = brm_data,
          file_path = here("analysis_outputs", "npz_spr_stats", "surprisal", paste0("surp_ambxlen_", finality_type, "_", resolution_type, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}

# unambiguous comma vs unambiguous object
# critical word only

brm_data <- model_data %>%
  filter(item_category == "critical") %>%
  filter(ambiguity == "unambiguous") %>%
  filter(word_index == critical_word_index) %>%
  code_npz_data()
  
run_brms(
  as.formula("surprisal ~ resolution * length * finality + (resolution * length * finality | model) + (resolution * length * finality | item)"),
  data = brm_data,
  file_path = here("analysis_outputs", "npz_spr_stats", "surprisal", "surp_resxlenxfin.txt")
)

for (finality_type in c("final", "nonfinal")) {
  brm_data <- model_data %>%
    filter(item_category == "critical") %>%
    filter(finality == finality_type) %>%
    filter(ambiguity == "unambiguous") %>%
    filter(word_index == critical_word_index) %>%
    code_npz_data()

  run_brms(
    formula = as.formula("surprisal ~ resolution * length + (resolution * length | model) + (resolution * length | item)"),
    data = brm_data,
    file_path = here("analysis_outputs", "npz_spr_stats", "surprisal", paste0("surp_resxlen_", finality_type, ".txt"))
  )
}