
# RESPONSE TIME

# maximal (filter by resolution or code together)
# critical word only
# critical-onward and critical-only for nonfinal
for (resolution_type in c("all", "comma", "object")) {
  for (critonward in c(FALSE, TRUE)) {
    brm_data <- human_data %>%
      filter(item_category == "critical") %>%
      comprehension_filter(type="spr")

    if (critonward) {
      brm_data <- combine_critical_onward(brm_data)
    }

    if (resolution_type != "all") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
    }

    brm_data <- brm_data %>%
      filter(word_index == critical_word_index) %>%
      code_npz_data()

    run_brms(
      formula = as.formula("RT ~ ambiguity * length * finality + (ambiguity * length * finality | participant) + (ambiguity * length * finality | item)"),
      data = brm_data,
      file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_ambxlenxfin_", resolution_type, if (critonward) "_critonward" else "", ".txt"))
    )
  }
}

# final vs non-final (filter by resolution or code together)
# critical and then spillover for nonfinal
# critical-onward and critical-only for nonfinal
for (finality_type in c("final", "nonfinal")) {
  for (resolution_type in c("all", "comma", "object")) {
    for (critonward in c(FALSE, TRUE)) {
      for (critoffset in c(0, 1)) {

        if (critoffset == 1 & finality_type == "final") {
          next
        }
        if (critoffset == 1 & critonward == TRUE) {
          next
        }
        if (critonward == TRUE & finality_type == "final") {
          next
        }

        brm_data <- human_data %>%
          filter(item_category == "critical") %>%
          comprehension_filter(type="spr")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data)
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
          formula = as.formula("RT ~ ambiguity * length + (ambiguity * length | participant) + (ambiguity * length | item)"),
          data = brm_data,
          file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_ambxlen_", finality_type, "_", resolution_type, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}

# unambiguous comma vs unambiguous object
# critical word only

brm_data <- human_data %>%
  filter(item_category == "critical") %>%
  comprehension_filter(type="spr") %>%
  filter(ambiguity == "unambiguous") %>%
  filter(word_index == critical_word_index) %>%
  code_npz_data()
  
run_brms(
  as.formula("RT ~ resolution * length * finality + (resolution * length * finality | participant) + (resolution * length * finality | item)"),
  data = brm_data,
  file_path = here("analysis_outputs", "npz_spr_stats", "empirical", "rt_resxlenxfin.txt")
)

for (finality_type in c("final", "nonfinal")) {
  brm_data <- human_data %>%
    filter(item_category == "critical") %>%
    filter(finality == finality_type) %>%
    comprehension_filter(type="spr") %>%
    filter(ambiguity == "unambiguous") %>%
    filter(word_index == critical_word_index) %>%
    code_npz_data()

  run_brms(
    formula = as.formula("RT ~ resolution * length + (resolution * length | participant) + (resolution * length | item)"),
    data = brm_data,
    file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_resxlen_", finality_type, ".txt"))
  )
}

# ACCURACY

# maximal (filter by resolution or code together)
# critical word only
# critical-onward and critical-only for nonfinal
for (resolution_type in c("all", "comma", "object")) {
  for (critonward in c(FALSE, TRUE)) {
    brm_data <- human_data %>%
      filter(item_category == "critical")

    if (critonward) {
      brm_data <- combine_critical_onward(brm_data, y_var = "correct")
    }

    if (resolution_type != "all") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == resolution_type)
    }

    brm_data <- brm_data %>%
      filter(word_index == critical_word_index) %>%
      code_npz_data()

    run_brms(
      formula = as.formula("correct ~ ambiguity * length * finality + (ambiguity * length * finality | participant) + (ambiguity * length * finality | item)"),
      data = brm_data,
      family = bernoulli(link = "logit"),
      file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("correct_ambxlenxfin_", resolution_type, if (critonward) "_critonward" else "", ".txt"))
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

        brm_data <- human_data %>%
          filter(item_category == "critical")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data, y_var = "correct")
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
          formula = as.formula("correct ~ ambiguity * length + (ambiguity * length | participant) + (ambiguity * length | item)"),
          data = brm_data,
          family = bernoulli(link = "logit"),
          file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("correct_ambxlen_", finality_type, "_", resolution_type, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}