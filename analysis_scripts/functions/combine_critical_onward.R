combine_critical_onward <- function(df, y_var = "RT") {
  stopifnot(y_var %in% names(df))
  
  # Calculate mean for critical word onward
  mean_post <- df %>%
    filter(word_index >= critical_word_index) %>%
    group_by(across(any_of(c("participant", "model", "item_category", "item", 
                             "ambiguity", "length", "resolution", "finality")))) %>%
    summarize(critical_onward_mean = mean(!!sym(y_var), na.rm = TRUE), .groups = "drop")
  
  # Join and replace critical word value
  modified_df <- df %>%
    left_join(mean_post, by = intersect(names(df), 
                                        c("participant", "model", "item_category", "item", 
                                          "ambiguity", "length", "resolution", "finality"))) %>%
    mutate(!!sym(y_var) := ifelse(word_index == critical_word_index, 
                                   critical_onward_mean, 
                                   !!sym(y_var))) %>%
    filter(word_index <= critical_word_index) %>%
    select(-critical_onward_mean)
  
  return(modified_df)
}