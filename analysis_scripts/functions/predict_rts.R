predict_rts <- function(human_data, model_data, make_figure = FALSE, figure_path = NULL) {
  # average RT per word, only fully correct trials, excluding first and last words
  human_avg <- human_data %>%
    filter(item_category == "filler") %>%
    group_by(participant, item_category, item) %>%
    filter(all(correct == 1)) %>%
    ungroup() %>%
    filter(word_index > 0, word_index < final_word_index) %>%
    group_by(item_category, item, word_index) %>%
    summarise(RT = mean(RT), .groups = "drop")
  
  # Prepare model data for predictors
  model_predictors <- model_data %>%
    group_by(model, item_category, item) %>%
    arrange(word_index) %>%
    mutate(
      surp_lag0 = surprisal,
      surp_lag1 = lag(surprisal, 1),
      surp_lag2 = lag(surprisal, 2),
      freq_lag0 = word_log_freq,
      freq_lag1 = lag(word_log_freq, 1),
      freq_lag2 = lag(word_log_freq, 2),
      len_lag0 = word_len,
      len_lag1 = lag(word_len, 1),
      len_lag2 = lag(word_len, 2)
    ) %>%
    ungroup() %>%
    # exclude terms with NA lags
    filter(word_index >= 2)
  
  # Join human RT with model predictors
  train_data <- model_predictors %>%
    filter(item_category == "filler") %>%
    inner_join(human_avg, by = c("item_category", "item", "word_index"))
  
  # Collect coefficients if making figure
  if (make_figure) {
    all_coefs <- list()
    all_sigs <- list()
  }
  
  # Fit separate models for each LLM and predict on all items
  predicted_rt_data <- model_predictors %>%
    group_by(model) %>%
    group_modify(~{
      train <- train_data %>% filter(model == .y$model)
      fit <- lm(RT ~ surp_lag0 + freq_lag0 + len_lag0 + 
                      surp_lag1 + freq_lag1 + len_lag1 +
                      surp_lag2 + freq_lag2 + len_lag2, 
                data = train)
      
      if (make_figure) {
        all_coefs[[.y$model]] <<- fit$coefficients
        all_sigs[[.y$model]] <<- summary(fit)$coefficients[, "Pr(>|t|)"]
      }
      
      .x %>% mutate(RT = predict(fit, newdata = .x))
    }) %>%
    ungroup() %>%
    select(-surp_lag0, -surp_lag1, -surp_lag2, 
            -freq_lag0, -freq_lag1, -freq_lag2, 
            -len_lag0, -len_lag1, -len_lag2)
  
  # Make figure if requested
  if (make_figure) {
    stopifnot(!is.null(figure_path))
    
    coef_df <- as.data.frame(all_coefs) %>%
      rownames_to_column(var = "Predictor") %>%
      pivot_longer(-Predictor, names_to = "model", values_to = "coefficient") %>%
      mutate(significant = unlist(all_sigs)[paste0(model, ".", Predictor)] < 0.05) %>%
      filter(Predictor != "(Intercept)") %>%
      separate(Predictor, into = c("Predictor", "lag"), sep = "_lag")
    # rename predictors and make into ordered factor
    coef_df$Predictor <- recode(coef_df$Predictor,
      "surp" = "Surprisal (bits)",
      "freq" = "Log-Frequency (bits)",
      "len" = "Word Length (chars)"
    )
    coef_df$Predictor <- factor(coef_df$Predictor, 
      levels = c("Surprisal (bits)", "Log-Frequency (bits)", "Word Length (chars)")
    )

    # annotate pct significant
    sig_labels <- coef_df %>%
      group_by(Predictor) %>%
      mutate(range = max(coefficient) - min(coefficient)) %>%
      ungroup() %>%
      group_by(Predictor, lag) %>%
      reframe(sig_p = mean(significant) * 100, 
              height = max(coefficient) + 0.025 * range)

    plot <- ggplot(coef_df, aes(x = lag, y = coefficient, fill = Predictor)) +
      facet_wrap(~ Predictor, scales = 'free_y') +
      geom_hline(yintercept = 0, linetype = 'dashed') +
      geom_violin() +
      geom_text(data = sig_labels,
        aes(x = lag, y = height, 
            label = paste0(round(sig_p), "%")),
        vjust = 0
      ) +
      labs(
        x = 'Word Lag',
        y = 'Estimate (ms/unit)',
        title = 'Regression Coefficient Densities'
      ) +
      scale_fill_brewer(palette = "Pastel1")

    ggsave(figure_path, plot = plot, width = 8, height = 5)
  }
  
  return(predicted_rt_data)
}