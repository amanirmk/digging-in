load_npz_data <- function(folder) {
    stopifnot(folder %in% c("npz_maze", "npz_spr"))

    # Load human data
    human <- read_csv(here("collected_data", folder, "human", "filtered.csv"), show_col_types = FALSE) %>%
      select(-any_of(c("alt", "word")))

    # Get list of LLM files
    model_dir <- here("collected_data", folder, "model")
    model_files <- list.files(model_dir, pattern = "\\.csv$", full.names = TRUE)

    # Load and combine all LLM data
    model_combined <- map_dfr(model_files, function(file) {
      model_name <- make.names(tools::file_path_sans_ext(basename(file)))
      read_csv(file, show_col_types = FALSE) %>%
        select(-word) %>%
        mutate(model = model_name)
    })

    # Get reference columns from human data (one row per item/word)
    human_ref <- human %>%
      filter(item_category != "practice") %>%
      distinct(item_category, item, ambiguity, length, resolution, finality, 
              critical_word_index, word_index, 
              .keep_all = TRUE) %>%
      select(item_category, item, ambiguity, length, resolution, finality,
            critical_word_index, final_word_index, region, word_index,
            word_log_freq, word_len)

    # Join LLM data with human reference columns
    model <- model_combined %>%
      left_join(human_ref, by = c("item_category", "item", "ambiguity", "length", 
                                  "resolution", "finality", "critical_word_index",
                                  "word_index"))

    return(list(human = human, model = model))
}