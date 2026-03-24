library(tidyverse)
library(here)

# Load data
df <- read_csv(here("collected_data", "npz_spr", "human", "unfiltered.csv"))

# Filter for participant accuracy on fillers (one row per item)
filler_accuracy <- df %>%
  filter(item_category == "filler") %>%
  distinct(participant, item_category, item, .keep_all = TRUE) %>%
  group_by(participant) %>%
  summarise(accuracy = mean(correct)) %>%
  filter(accuracy >= 0.8)

# Exclude trials with extreme RTs (excluding first word)
valid_trials <- df %>%
  filter(word_index > 0) %>%
  group_by(participant, item_category, item) %>%
  summarise(has_extreme = any(RT < 100 | RT > 5000), .groups = "drop") %>%
  filter(!has_extreme)

# Apply filters and save
filtered <- df %>%
  semi_join(filler_accuracy, by = "participant") %>%
  semi_join(valid_trials, by = c("participant", "item_category", "item"))

write_csv(filtered, here("collected_data", "npz_spr", "human", "filtered.csv"))