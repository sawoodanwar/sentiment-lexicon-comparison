# Sentiment Lexicon Comparison in R

[![Language: R](https://img.shields.io/badge/Language-R-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![Method: Lexicon-Based Sentiment](https://img.shields.io/badge/Method-Lexicon--Based%20Sentiment-green?style=flat)]()
[![Lexicons: AFINN Bing NRC](https://img.shields.io/badge/Lexicons-AFINN%20%7C%20Bing%20%7C%20NRC-orange?style=flat)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A reproducible R workflow for **comparing AFINN, Bing, and NRC lexicon-based sentiment analysis** on social media and news text. Designed for computational communication researchers who need to make an informed, justified choice of sentiment tool before committing to a full analysis pipeline.

This repo was developed as a companion to the doctoral thesis [facebook-reactions-covid19-india](https://github.com/sawoodanwar/facebook-reactions-covid19-india), where `sentimentr` (with valence shifting) was ultimately selected. The comparison here shows *why* that choice matters.

---

## 🔗 Related Projects

| Repository | Description |
|---|---|
| 🦠 [facebook-reactions-covid19-india](https://github.com/sawoodanwar/facebook-reactions-covid19-india) | PhD thesis — applied sentiment analysis on COVID-19 news |
| ⏱️ [timeseries-facebook-engagement-r](https://github.com/sawoodanwar/timeseries-facebook-engagement-r) | Time-series toolkit for engagement data |
| 🧠 [stm-social-media-r](https://github.com/sawoodanwar/stm-social-media-r) | STM topic modeling toolkit |

---

## 📌 Overview

Lexicon-based sentiment analysis assigns polarity or emotion scores to text by matching tokens against a reference dictionary. The choice of lexicon significantly affects results because each was built with different assumptions, domains, and granularities:

| Lexicon | Output Type | Score Range | Built From | Strength |
|---|---|---|---|---|
| **AFINN** (Nielsen, 2011) | Numeric polarity | −5 to +5 per word | Manual annotation by one author | Fine-grained polarity scores; fast |
| **Bing** (Hu & Liu, 2004) | Binary polarity | Positive / Negative | Product reviews | Large vocabulary; easy to interpret |
| **NRC** (Mohammad & Turney, 2013) | 10-category emotion + polarity | Binary per category | Crowdsourced annotation | Rich emotion dimensions (joy, fear, anger…) |
| **sentimentr** (Rinker, 2015–2024) | Sentence-level numeric | Continuous | Dictionary + valence shifters | Handles negation, amplifiers, de-amplifiers |

> `sentimentr` is **not** a lexicon itself but a valence-aware scoring engine that applies shifters ("not", "very", "barely") to any underlying dictionary. It is included here for comparison because it outperforms word-level approaches on short, colloquial text.

---

## 🔬 Methodology

### Step 1 — Text Preparation

Tokenize text at the word level using `tidytext::unnest_tokens()`. This converts each document into one row per token, ready for lexicon joining.

```r
library(tidyverse)
library(tidytext)

tokenized <- df |>
  unnest_tokens(word, text) |>
  anti_join(stop_words, by = "word")
```

### Step 2 — AFINN Scoring

Join tokens against the AFINN lexicon (values −5 to +5). Aggregate by document to get a per-post polarity score.

```r
afinn <- get_sentiments("afinn")

afinn_scores <- tokenized |>
  inner_join(afinn, by = "word") |>
  group_by(doc_id) |>
  summarise(afinn_score = sum(value, na.rm = TRUE))
```

### Step 3 — Bing Binary Classification

Join against the Bing lexicon (positive/negative labels). Compute net sentiment as count(positive) − count(negative).

```r
bing <- get_sentiments("bing")

bing_scores <- tokenized |>
  inner_join(bing, by = "word") |>
  count(doc_id, sentiment) |>
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) |>
  mutate(bing_net = positive - negative)
```

### Step 4 — NRC Emotion Profiling

Join against NRC to get 10 emotion/polarity categories per document. Useful for identifying dominant emotional tone beyond simple positive/negative.

```r
nrc <- get_sentiments("nrc")

nrc_scores <- tokenized |>
  inner_join(nrc, by = "word") |>
  count(doc_id, sentiment) |>
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)
# Columns: anger, anticipation, disgust, fear, joy, negative,
#          positive, sadness, surprise, trust
```

### Step 5 — sentimentr Sentence-Level Scoring

`sentimentr` operates on full sentences, not individual tokens. It applies valence shifters (negation, amplification) for more contextually accurate scores.

```r
library(sentimentr)

sentimentr_scores <- df |>
  mutate(sentences = get_sentences(text)) |>
  sentiment_by(by = "doc_id") |>
  select(doc_id, ave_sentiment)
```

### Step 6 — Comparison & Visualization

Join all four score sets by `doc_id` and examine:
- **Correlation matrix** between scoring methods
- **Disagreement cases**: documents where methods diverge significantly
- **Distribution plots**: histogram overlays per method
- **Coverage rate**: proportion of documents where each lexicon finds at least one matching word

```r
all_scores <- afinn_scores |>
  left_join(bing_scores, by = "doc_id") |>
  left_join(nrc_scores, by = "doc_id") |>
  left_join(sentimentr_scores, by = "doc_id")

cor(all_scores |> select(afinn_score, bing_net, ave_sentiment), use = "complete.obs")
```

---

## 📂 Repository Structure

```
sentiment-lexicon-comparison/
├── scripts/R/
│   ├── 01_afinn_scoring.R
│   ├── 02_bing_scoring.R
│   ├── 03_nrc_scoring.R
│   ├── 04_sentimentr_scoring.R
│   └── 05_comparison_visualization.R
├── data/sample/
├── results/figures/
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Usage

### Prerequisites

```r
install.packages(c("tidyverse", "tidytext", "textdata", "sentimentr", "ggplot2", "patchwork"))
```

> **Note:** `textdata` will prompt you to agree to lexicon licenses (AFINN, Bing, NRC) on first download. This is a one-time step.

### Run the Pipeline

```r
# Each script is self-contained and writes output to results/
source("scripts/R/01_afinn_scoring.R")
source("scripts/R/02_bing_scoring.R")
source("scripts/R/03_nrc_scoring.R")
source("scripts/R/04_sentimentr_scoring.R")
source("scripts/R/05_comparison_visualization.R")  # produces all comparison plots
```

### Input Format

```
doc_id, text, source, created_at
```

---

## 📊 Expected Outputs

| Output | Description |
|---|---|
| `results/all_scores.csv` | Merged scores from all four methods per document |
| `results/figures/correlation_heatmap.png` | Pearson correlations between methods |
| `results/figures/score_distributions.png` | Overlaid histograms per method |
| `results/figures/coverage_rates.png` | % of documents matched per lexicon |
| `results/figures/nrc_emotion_profile.png` | Emotion category breakdown (NRC) |

---

## 📖 Key References

- Nielsen, F. Å. (2011). A new ANEW: Evaluation of a word list for sentiment analysis in microblogs. *ESWC Workshop on Making Sense of Microposts*, 93–98.
- Hu, M., & Liu, B. (2004). Mining and summarizing customer reviews. *KDD ’04*, 168–177.
- Mohammad, S. M., & Turney, P. D. (2013). Crowdsourcing a word–emotion association lexicon. *Computational Intelligence*, 29(3), 436–465.
- Rinker, T. W. (2024). *sentimentr: Calculate Text Polarity Sentiment*. CRAN. https://cran.r-project.org/package=sentimentr

---

## 📬 Author

**Sawood Anwar** — PhD in Humanities (Text and Communication Sciences)
University of Urbino Carlo Bo, Italy | Defended: 22 September 2025

[![GitHub](https://img.shields.io/badge/GitHub-sawoodanwar-181717?style=flat&logo=github)](https://github.com/sawoodanwar)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-sawood--anwar-0A66C2?style=flat&logo=linkedin)](https://www.linkedin.com/in/sawood-anwar/)
[![Google Scholar](https://img.shields.io/badge/Google%20Scholar-Sawood%20Anwar-4285F4?style=flat&logo=googlescholar&logoColor=white)](https://scholar.google.com/citations?user=Z2kACpkAAAAJ&hl=en)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0000--2819--9179-A6CE39?style=flat&logo=orcid&logoColor=white)](https://orcid.org/0009-0000-2819-9179)

---

## 📝 License

MIT License. See [LICENSE](LICENSE).

---

*Keywords: Sentiment Analysis, AFINN, Bing, NRC, sentimentr, tidytext, lexicon comparison, social media, R, NLP, Computational Communication*
