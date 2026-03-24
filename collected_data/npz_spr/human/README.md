## Data collected from participants (SPR NP/Z)

CSV column descriptions:
- `participant (int)`: The integer id of the participant. These ids are by experiment; if you combine data across experiments, make sure to keep participants unique.
- `item_category (str)`: The type of item. Can be "critical", "filler", or "practice".
- `item (int)`: The integer id of the item (unique within same item category).
- `ambiguity (str)`: Either "ambiguous" or "unambiguous". NA if not a critical item.
- `length (str)`:  Either "short" or "long". NA if not a critical item.
- `resolution (str)`: The type of ambiguity resolution. Either "comma" or "object". NA when the condition is ambiguous or if not a critical item.
- `finality (str)`: The location of the critical word. Either "final" or "nonfinal". NA if not a critical item.
- `critical_word_index (int)`: The index of the critical word in the sentence. Starts with zero. -1 if not a critical item.
- `final_word_index (int)`: The index of the final word in the sentence. Starts with zero.
- `region (str)`: The sentence region for the current word. Can be "beginning" (anything before the noun phrase or disambiguation), "comma" (disambiguation via word with comma), "object" (disambiguation via another object), "would_be_comma" (word that would have had the comma attached if disambiguating) "art/pos" (article or possessive), "noun", "postmod" (postnominal modifier for long items), "critical", "ending" (anything after the critical word). NA when not a critical item.
- `word_index (int)`: The index of the word in the sentence. Starts with zero.
- `word (str)`: The actual word, including any attached punctuation.
- `RT (int)`: The time spent on the word before pressing space to progress the sentence, in milliseconds.
- `word_log_freq (float)`: The log-frequency of the word in base 2 (bits), from <tt>wordfreq</tt> (Speer, 2022). Lower-bounded at 1 per 100 million words.
- `word_len (int)`: The length of the word in characters, including any attached punctuation.
- `QRT (int)`: The time to select an answer to the comprehension question.
- `correct (int/bool)`: Whether the comprehension question was answered correctly (1 or 0).

The <tt>unfiltered.csv</tt> file contains the above data without any filtering for participant attention or extreme values.

The `filtered.csv` file is the result of filtering for:
1. Excluding participants with <80% accuracy on comprehension questions for filler items.
2. Excluding trials (a complete sentence/item) containing any RTs less than 100ms or above 5000ms, excluding the first word in the sentence.

Additional filtering is applied depending on the analysis conducted.