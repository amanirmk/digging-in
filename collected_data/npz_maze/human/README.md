## Data collected from participants (Maze NP/Z)

CSV column descriptions:
- `participant (int)`: The integer id of the participant.
- `item_category (str)`: The type of item. Can be "critical", "filler", or "practice".
- `item (int)`: The integer id of the item (unique within same item category).
- `ambiguity (str)`: Either "ambiguous" or "unambiguous". NA if not a critical item.
- `length (str)`:  Either "short" or "long". NA if not a critical item.
- `resolution (str)`: The type of ambiguity resolution. Either "comma" or "object". NA if not a critical item.
- `finality (str)`: The location of the critical word. Either "final" or "nonfinal". NA if not a critical item.
- `critical_word_index (int)`: The index of the critical word in the sentence. Starts with zero. -1 if not a critical item.
- `final_word_index (int)`: The index of the final word in the sentence. Starts with zero.
- `region (str)`: The sentence region for the current word. Can be "beginning" (anything before the noun phrase or disambiguation), "comma" (disambiguation via word with comma), "object" (disambiguation via another object), "would_be_comma" (word that would have had the comma attached if disambiguating) "art/pos" (article or possessive), "noun", "postmod" (postnominal modifier for long items), "critical", "ending" (anything after the critical word). NA when not a critical item.
- `word_index (int)`: The index of the word in the sentence. Starts with zero.
- `word (str)`: The actual word, including any attached punctuation.
- `alt (str)`: The alternative choice for the word in the Maze task, including any attached punctuation.
- `RT (int)`: The initial time to select a word (whether correct or incorrect), in milliseconds.
- `correct (int/bool)`: Whether the initial word selection was correct (1 or 0).
- `word_log_freq (float)`: The log-frequency of the word in base 2 (bits), from <tt>wordfreq</tt> (Speer, 2022). Lower-bounded at 1 per 100 million words.
- `word_len (int)`: The length of the word in characters, including any attached punctuation.

The <tt>unfiltered.csv</tt> file contains the above data without any filtering for participant attention or extreme values.

The <tt>filtered.csv</tt> file is the result of filtering for:
1. Excluding participants with <80% accuracy on words in filler items, excluding the first word in the sentence.
2. Excluding trials (a complete sentence/item) containing any RTs less than 100ms or above 5000ms, excluding the first word in the sentence.

Additional filtering is applied depending on the analysis conducted.