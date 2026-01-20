comprehension_filter <- function(df, type) {
    stopifnot(type %in% c("maze", "spr"))
    filtered_df <- df
    # If SPR, filter for comprehension question accuracy
    if (type == "spr") {
        filtered_df <- filtered_df %>%
            filter(correct == 1)
    }
    # If Maze, filter for pre-critical word accuracy
    if (type == "maze") {
        valid_trials <- filtered_df %>%
            filter(word_index < critical_word_index) %>%
            group_by(participant, item_category, item) %>%
            summarise(all_correct = all(correct == 1), .groups = "drop") %>%
            filter(all_correct)
        
        filtered_df <- filtered_df %>%
            semi_join(valid_trials, by = c("participant", "item_category", "item"))
    }
    
    return(filtered_df)
}