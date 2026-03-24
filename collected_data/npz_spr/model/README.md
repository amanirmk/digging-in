## Data collected from LLMs (SPR NP/Z)

CSV column descriptions:
- `item_category (str)`: The type of item. Either "critical" or "filler" for LLMs.
- `item (int)`: The integer id of the item (unique within same item category).
- `ambiguity (str)`: Either "ambiguous" or "unambiguous". NA if not a critical item.
- `length (str)`:  Either "short" or "long". NA if not a critical item.
- `resolution (str)`: The type of ambiguity resolution. Either "comma", "object". NA when the condition is ambiguous or if not a critical item.
- `finality (str)`: The location of the critical word. Either "final" or "nonfinal". NA if not a critical item.
- `critical_word_index (int)`: The index of the critical word in the sentence. Starts with zero. -1 if not a critical item.
- `word_index (int)`: The index of the word in the sentence. Starts with zero.
- `word (str)`: The actual word, including any attached punctuation.
- `surprisal (float)`: The word's surprisal estimate from the LLM in base 2 (bits).

Surprisal values were obtained using the `minicons` (Misra, 2022) interface to `transformers` library (Wolf et al., 2020). We prepend the stimuli with beginning-of-sentence tokens (unless the model automatically does so) to ensure the first token gets a surprisal value, and sum surprisals over subword tokens to get a single value per word---including any punctuation.

Filenames to transformer model names.
- `gpt2-small.csv`: "openai-community/gpt2",
- `gpt2-medium.csv`: "openai-community/gpt2-medium",
- `gpt2-large.csv`: "openai-community/gpt2-large",
- `pythia-70m.csv`: "EleutherAI/pythia-70m",
- `pythia-70m-deduped.csv`: "EleutherAI/pythia-70m-deduped",
- `pythia-160m.csv`: "EleutherAI/pythia-160m"
- `pythia-160m-deduped.csv`: "EleutherAI/pythia-160m-deduped"
- `pythia-1b.csv`: "EleutherAI/pythia-1b"
- `pythia-1b-deduped.csv`: ""EleutherAI/pythia-1b-deduped"
- `qwen-25-05b.csv`: "Qwen/Qwen2.5-0.5B"
- `qwen-25-15b.csv`: "Qwen/Qwen2.5-1.5B"
- `qwen-25-3b.csv`: "Qwen/Qwen2.5-3B"
- `qwen-25-7b.csv`: "Qwen/Qwen2.5-7B"
- `gemma-3-1b-pt.csv`: "google/gemma-3-1b-pt"
- `gemma-3-4b-pt.csv`: "google/gemma-3-4b-pt"
- `mistral-7b-v03.csv`: "mistralai/Mistral-7B-v0.3"