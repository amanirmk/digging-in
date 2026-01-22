# EXPECTS human_data, by_item.R, comprehension_filter.R, run_brms.R to be loaded already

# RESPONSE TIME

# maximal (filter by resolution or code together)
# critical word only
# critical-onward and critical-only for nonfinal
for (resolution in c("all", "comma", "object")) {
  for (critonward in c(FALSE, TRUE)) {
    brm_data <- human_data %>%
      filter(item_category == "critical") %>%
      comprehension_filter(type="spr")

    if (critonward) {
      brm_data <- combine_critical_onward(brm_data)
    }

    if (resolution == "comma") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "comma")
    } else if (resolution == "object") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "object")
    }

    brm_data <- brm_data %>%
      filter(word_index == critical_word_index) %>%
      code_npz_data()

    run_brms(
      formula = as.formula("RT ~ ambiguity * length * finality + (ambiguity * length * finality | participant) + (ambiguity * length * finality | item)"),
      data = brm_data,
      file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_ambxlenxfin_", resolution, if (critonward) "_critonward" else "", ".txt"))
    )
  }
}

# final vs non-final (filter by resolution or code together)
# critical and then spillover for nonfinal
# critical-onward and critical-only for nonfinal
for (finality in c("final", "nonfinal")) {
  for (resolution in c("all", "comma", "object")) {
    for (critonward in c(FALSE, TRUE)) {
      for (critoffset in c(0, 1)) {

        if (critoffset == 1 & finality == "final") {
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
          comprehension_filter(type="spr")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data)
        }

        if (resolution == "comma") {
          brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "comma")
        } else if (resolution == "object") {
          brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "object")
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
          file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_ambxlen_", finality, "_", resolution, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
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

for (finality in c("final", "nonfinal")) {
  brm_data <- human_data %>%
    filter(item_category == "critical") %>%
    filter(finality == finality) %>%
    comprehension_filter(type="spr") %>%
    filter(ambiguity == "unambiguous") %>%
    filter(word_index == critical_word_index) %>%
    code_npz_data()

  run_brms(
    formula = as.formula("RT ~ resolution * length + (resolution * length | participant) + (resolution * length | item)"),
    data = brm_data,
    file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("rt_resxlen_", finality, ".txt"))
  )
}

# ACCURACY

# maximal (filter by resolution or code together)
# critical word only
# critical-onward and critical-only for nonfinal
for (resolution in c("all", "comma", "object")) {
  for (critonward in c(FALSE, TRUE)) {
    brm_data <- human_data %>%
      filter(item_category == "critical")

    if (critonward) {
      brm_data <- combine_critical_onward(brm_data, y_var = "correct")
    }

    if (resolution == "comma") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "comma")
    } else if (resolution == "object") {
      brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "object")
    }

    brm_data <- brm_data %>%
      filter(word_index == critical_word_index) %>%
      code_npz_data()

    run_brms(
      formula = as.formula("correct ~ ambiguity * length * finality + (ambiguity * length * finality | participant) + (ambiguity * length * finality | item)"),
      data = brm_data,
      family = bernoulli(link = "logit"),
      file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("correct_ambxlenxfin_", resolution, if (critonward) "_critonward" else "", ".txt"))
    )
  }
}

# final vs non-final (filter by resolution or code together)
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
          filter(item_category == "critical")

        if (critonward) {
          brm_data <- combine_critical_onward(brm_data, y_var = "correct")
        }

        if (resolution == "comma") {
          brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "comma")
        } else if (resolution == "object") {
          brm_data <- brm_data %>% filter(ambiguity == "ambiguous" | resolution == "object")
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
          file_path = here("analysis_outputs", "npz_spr_stats", "empirical", paste0("correct_ambxlen_", finality, "_", resolution, if (critonward) "_critonward" else "", if (critoffset == 1) "_spillover" else "", ".txt"))
        )
}}}}