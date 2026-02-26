by_item_condition_average <- function(
  df,
  resolution = "ignore",
  y_var = "RT",
  x_var = "word_index",
  ignore_contrasts = NULL
) {
  stopifnot(resolution %in% c("ignore", "average", "separate"))
  stopifnot(y_var %in% names(df))
  stopifnot(x_var %in% c("word_index", "critical_relative", "final_relative", "region", "critrel_group"))
  # ignore contrasts is a vector of condition names to ignore when averaging
  stopifnot(is.null(ignore_contrasts) || all(ignore_contrasts %in% c("ambiguity", "length", "finality")))

  if (x_var == "critical_relative") {
    df <- df %>%
      mutate(critical_relative = word_index - critical_word_index)
  } else if (x_var == "final_relative") {
    df <- df %>%
      mutate(final_relative = word_index - final_word_index)
  }
  stopifnot(x_var %in% names(df))

  base_vars <- c("item_category", "item", x_var, "ambiguity", "length", "finality")
  if (!is.null(ignore_contrasts)) {
    base_vars <- setdiff(base_vars, ignore_contrasts)
  }
  group_vars <- base_vars
  if (resolution == "separate") {
    group_vars <- c(group_vars, "resolution")
  }

  # Average over model/participant and return mean y_var
  summary_df <- df %>%
    group_by(across(any_of(group_vars))) %>%
    summarise(
      !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
      .groups = "drop"
    )
  # if resolution is "average", average over resolution levels
  if (resolution == "average") {
    summary_df <- summary_df %>%
      group_by(across(any_of(base_vars))) %>%
      summarise(
        !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
        .groups = "drop"
      )
  }
  return(summary_df)
}

# largely a duplicate of above, but takes two dataframes (human and predicted) and computes residuals, 
# combining humans and llms separately at the level indicated by x_var

resid_by_item_condition_average <- function(
  human_df, 
  pred_df,
  resolution = "ignore",
  x_var = "word_index",
  ignore_contrasts = NULL
) {
  y_var <- "RT"
  stopifnot(resolution %in% c("ignore", "average", "separate"))
  stopifnot(x_var %in% c("word_index", "critical_relative", "final_relative", "region"))
  # ignore contrasts is a vector of condition names to ignore when averaging
  stopifnot(is.null(ignore_contrasts) || all(ignore_contrasts %in% c("ambiguity", "length", "finality")))

  if (x_var == "critical_relative") {
    human_df <- human_df %>%
      mutate(critical_relative = word_index - critical_word_index)
    pred_df <- pred_df %>%
      mutate(critical_relative = word_index - critical_word_index)
  } else if (x_var == "final_relative") {
    human_df <- human_df %>%
      mutate(final_relative = word_index - final_word_index)
    pred_df <- pred_df %>%
      mutate(final_relative = word_index - final_word_index)
  }
  stopifnot(x_var %in% names(human_df))
  stopifnot(x_var %in% names(pred_df))

  base_vars <- c("item_category", "item", x_var, "ambiguity", "length", "finality")
  if (!is.null(ignore_contrasts)) {
    base_vars <- setdiff(base_vars, ignore_contrasts)
  }
  group_vars <- base_vars
  if (resolution == "separate") {
    group_vars <- c(group_vars, "resolution")
  }

  # Average over participant and return mean y_var
  human_df <- human_df %>%
    group_by(across(any_of(group_vars))) %>%
    summarise(
      !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
      .groups = "drop"
    )
  # if resolution is "average", average over resolution levels
  if (resolution == "average") {
    human_df <- human_df %>%
      group_by(across(any_of(base_vars))) %>%
      summarise(
        !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
        .groups = "drop"
      )
  }

  # Average over model and return mean y_var
  pred_df <- pred_df %>%
    group_by(across(any_of(group_vars))) %>%
    summarise(
      !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
      .groups = "drop"
    )
  # if resolution is "average", average over resolution levels
  if (resolution == "average") {
    pred_df <- pred_df %>%
      group_by(across(any_of(base_vars))) %>%
      summarise(
        !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
        .groups = "drop"
      )
  }

  # join human and pred dataframes
  resid_df <- human_df %>%
    inner_join(pred_df, by = group_vars, suffix = c("_human", "_pred")) %>%
    mutate(RT = RT_human - RT_pred) %>%
    select(-RT_human, -RT_pred)

  return(resid_df)
}


over_item_difference_average <- function(
  by_item_condition_df,
  y_var = "RT",
  x_var = "critical_relative",
  difference_var = "ambiguity"
) {
  stopifnot(difference_var %in% c("ambiguity", "length", "finality"))
  stopifnot(y_var %in% names(by_item_condition_df))
  stopifnot(x_var %in% c("word_index", "critical_relative", "final_relative", "region"))
  stopifnot(x_var %in% names(by_item_condition_df))

  # take difference for each item and then average over items
  # there should be exactly two rows per grouping
  group_vars <- c("item_category", "item", x_var, setdiff(c("ambiguity", "length", "finality", "resolution"), difference_var))

  if (difference_var == "ambiguity") {
      summary_df <- by_item_condition_df %>%
        pivot_wider(names_from = ambiguity, values_from = !!sym(y_var)) %>%
        mutate(difference = ambiguous - unambiguous)
  } else if (difference_var == "length") {
      summary_df <- by_item_condition_df %>%
        pivot_wider(names_from = length, values_from = !!sym(y_var)) %>%
        mutate(difference = long - short)
  } else if (difference_var == "finality") {
      summary_df <- by_item_condition_df %>%
        pivot_wider(names_from = finality, values_from = !!sym(y_var)) %>%
        mutate(difference = final - nonfinal)
  }
  # average over items
  summary_df <- summary_df %>%
    group_by(across(any_of(setdiff(group_vars, "item")))) %>%
    summarise(
      stderr = sd(difference, na.rm = TRUE) / sqrt(n()),
      conf = qt(0.975, df = n() - 1) * stderr,
      !!sym(y_var) := mean(difference, na.rm = TRUE),
      .groups = "drop"
    )
  return(summary_df)
}

over_item_average <- function(
  by_item_condition_df,
  y_var = "RT",
  x_var = "word_index"
) {
  stopifnot(y_var %in% names(by_item_condition_df))
  stopifnot(x_var %in% c("word_index", "critical_relative", "final_relative", "region"))
  stopifnot(x_var %in% names(by_item_condition_df))

  group_vars <- c("item_category", x_var, "ambiguity", "length", "finality", "resolution")

  summary_df <- by_item_condition_df %>%
    group_by(across(any_of(group_vars))) %>%
    summarise(
      stderr = sd(!!sym(y_var), na.rm = TRUE) / sqrt(n()),
      conf = qt(0.975, df = n() - 1) * stderr,
      !!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
      .groups = "drop"
    )
  return(summary_df)
}