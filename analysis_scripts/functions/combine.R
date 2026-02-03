combine_critical_onward <- function(df, y_var = "RT", to_crit_plus = NULL) {
  stopifnot(y_var %in% names(df))

  # Select words to average
  if (is.null(to_crit_plus)) {
    to_avg <- df %>% filter(word_index >= critical_word_index)
  } else {
    to_avg <- df %>% filter(word_index >= critical_word_index & word_index <= (critical_word_index + to_crit_plus))
  }
  
  # Calculate mean for critical word onward
  mean_post <- to_avg %>%
    group_by(across(any_of(c("participant", "model", "item_category", "item", 
                             "ambiguity", "length", "resolution", "finality")))) %>%
    summarize(combined_crit_mean = mean(!!sym(y_var), na.rm = TRUE), .groups = "drop")
  
  # Join and replace critical word value
  modified_df <- df %>%
    left_join(mean_post, by = intersect(names(df), 
                                        c("participant", "model", "item_category", "item", 
                                          "ambiguity", "length", "resolution", "finality"))) %>%
    mutate(!!sym(y_var) := ifelse(word_index == critical_word_index, 
                                   combined_crit_mean, 
                                   !!sym(y_var)))

  # Remove combined words
  if (is.null(to_crit_plus)) {
    modified_df <- modified_df %>%
      filter(word_index <= critical_word_index)
  } else {
    modified_df <- modified_df %>%
      filter(word_index <= critical_word_index  | word_index > (critical_word_index + to_crit_plus)) %>%
      mutate(word_index = ifelse(word_index > (critical_word_index + to_crit_plus),
                                 word_index - to_crit_plus,
                                 word_index))
  }
  
  return(modified_df)
}

combine_critrel_groups <- function(df, y_var = "RT", critrel_size = 3) {
  stopifnot(y_var %in% names(df))

  # Average RTs for each critical-relative group (defined by critrel_size)
  modified_df <- df %>%
    group_by(across(any_of(c("participant", "model", "item_category", "item", 
                             "ambiguity", "length", "resolution", "finality"))),
             critrel_group = ((word_index - critical_word_index) %/% critrel_size)) %>%
    summarize(!!sym(y_var) := mean(!!sym(y_var), na.rm = TRUE),
              first_word_index = first(word_index),
              critical_word_index = first(critical_word_index),
              .groups = "drop")
    
  return(modified_df)
}