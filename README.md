# Sentiment Lexicon Comparison in R

[![Language: R](https://img.shields.io/badge/Language-R-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![Method: Lexicon-Based](https://img.shields.io/badge/Method-Lexicon--Based%20Sentiment-green?style=flat)]()
[![Lexicons: AFINN Bing NRC](https://img.shields.io/badge/Lexicons-AFINN%20%7C%20Bing%20%7C%20NRC-orange?style=flat)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This repository provides a **reproducible R workflow** for comparing three major lexicon-based sentiment analysis approaches — **AFINN**, **Bing**, and **NRC** — applied to short social media-style texts. It is designed to help researchers understand how the choice of lexicon significantly affects sentiment scores and classifications on the same dataset.

This project is part of a broader research toolkit developed by **Sawood Anwar** (PhD, University of Urbino Carlo Bo), complementing multi-method sentiment workflows used in computational communication research.

> **Related Projects:**
> - 🦠 [facebook-reactions-covid19-india](https://github.com/sawoodanwar/facebook-reactions-covid19-india) — PhD thesis project using sentimentr
> - 🧠 [stm-social-media-r](https://github.com/sawoodanwar/stm-social-media-r) — STM topic modeling toolkit
> - 📊 [meta-content-analysis](https://github.com/sawoodanwar/meta-content-analysis) — Meta platform content analysis
> - 🗳️ [reddit-political-misinfo-coding](https://github.com/sawoodanwar/reddit-political-misinfo-coding) — Reddit manual coding project

---

## Research Objectives

- Preprocess and tokenize short social media texts
- Apply AFINN, Bing, and NRC lexicons to the same dataset
- Compare sentiment scores and polarity classifications across lexicons
- Visualize sentiment distributions and lexicon divergence
- Produce interpretable summary statistics for academic reporting

---

## Lexicons Compared

| Lexicon | Type | Output | Notes |
|---|---|---|---|
| **AFINN** | Numeric scores | -5 to +5 per word | Useful for intensity measurement |
| **Bing** | Binary polarity | Positive / Negative | Simple and interpretable |
| **NRC** | Emotion categories | 10 emotions + polarity | Rich affective dimension |

---

## Methodology

| Step | Tool/Package | Description |
|---|---|---|
| Text cleaning | `tidyverse`, `stringr` | Lowercasing, punctuation removal |
| Tokenization | `tidytext` | Word tokenization and stopword removal |
| Lexicon join | `tidytext::get_sentiments()` | Join tokens with each lexicon |
| Scoring | `dplyr` | Aggregate sentiment per document |
| Visualization | `ggplot2` | Bar charts and distribution plots |

---

## Repository Structure

```
sentiment-lexicon-comparison/
├── data/
│   └── sample/                    # Synthetic sample texts
├── scripts/
│   └── R/
│       └── sentiment_comparison.R    # Main analysis script
├── notebooks/                     # R Markdown workflow
├── output/
│   ├── figures/                   # Sentiment plots
│   └── tables/                    # Lexicon comparison tables
├── environment/
│   └── install_packages.R         # Package installation script
├── .gitignore
├── README.md
└── LICENSE
```

---

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/sawoodanwar/sentiment-lexicon-comparison.git
cd sentiment-lexicon-comparison
```

### 2. Install required packages
```r
source("environment/install_packages.R")
# Or manually:
install.packages(c("tidyverse", "tidytext", "ggplot2", "textdata"))
```

### 3. Run the analysis
```r
source("scripts/R/sentiment_comparison.R")
```

---

## Expected Outputs

- A table of per-document sentiment scores for each lexicon
- Side-by-side lexicon comparison summaries
- Bar plots and distribution charts of sentiment results
- Divergence analysis between lexicon outputs

---

## Key Insight

Lexicon choice can meaningfully alter research findings. For example, a text labelled **positive** by AFINN may be labelled **neutral or mixed** by NRC, and vice versa. This repository helps researchers make informed, justified decisions about which lexicon best fits their data and research questions.

---

## Future Extensions

- Add `sentimentr` (valence-aware, sentence-level) for comparison
- Extend to multi-language datasets
- Integrate with STM workflow to compare topic-level sentiment across lexicons
- Add inter-lexicon agreement metrics

---

## Author

**Sawood Anwar**
PhD in Humanities (Text and Communication Sciences) — defended 22 September 2025
University of Urbino Carlo Bo, Italy
Supervisor: Prof. Fabio Giglietto | Co-Supervisor: Prof. Giovanni Boccia Artieri

- 🔗 [GitHub](https://github.com/sawoodanwar)
- 💼 [LinkedIn](https://www.linkedin.com/in/sawood-anwar/)
- 🎓 [Google Scholar](https://scholar.google.com/citations?hl=en&user=GgsMu3sAAAAJ)

---

## License

This project is licensed under the [MIT License](LICENSE).

---

*Keywords: Sentiment Analysis, Lexicon-Based NLP, AFINN, Bing, NRC, tidytext, R, Computational Communication, Social Media Text Analysis*
