code_npz_data <- function(df) {
    coded_df <- df
    # +1/-1 sum-coded contrasts
    contrasts <- list(
      ambiguity = c("ambiguous" = 1, "unambiguous" = -1),
      length = c("long" = 1, "short" = -1),
      resolution = c("comma" = 1, "object" = -1),
      finality = c("final" = 1, "nonfinal" = -1)
    )
    for (var in names(contrasts)) {
      if (var %in% names(coded_df)) {
        coded_df[[var]] <- factor(coded_df[[var]], levels = names(contrasts[[var]]))
        contrasts(coded_df[[var]]) <- matrix(contrasts[[var]], ncol = 1)
      }
    }
    # make sure potential grouping levels are factors
    grouping_vars <- c("participant", "item_category", "item", "model")
    for (var in grouping_vars) {
      if (var %in% names(coded_df)) {
        coded_df[[var]] <- as.factor(coded_df[[var]])
      }
    }
    # give regions an explicit order
    if ("region" %in% names(coded_df)) {
      coded_df$region <- factor(coded_df$region, levels = c(
        "beginning",
        "would_be_comma",
        "comma",
        "object",
        "art/pos",
        "noun",
        "postmod",
        "critical",
        "ending"
      ))
    }
    return(coded_df)
}