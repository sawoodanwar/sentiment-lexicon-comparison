# Sentiment Lexicon Comparison in R

A reproducible R project comparing multiple lexicon-based sentiment analysis approaches on short social media-style texts.

## Overview
This repository demonstrates how different sentiment lexicons can produce different classifications on the same text data. It is designed as a public-safe portfolio project for text analysis, computational social science, and NLP workflows in R.

## Objectives
- Preprocess short texts
- Apply multiple sentiment lexicons
- Compare sentiment scores across methods
- Summarize differences in output
- Visualize sentiment distributions

## Lexicons Used
- AFINN
- Bing
- NRC

## Tools
- R
- tidyverse
- tidytext
- ggplot2

## Repository Structure
- `data/sample/` - synthetic sample texts
- `scripts/R/` - reusable R scripts
- `notebooks/` - R Markdown workflow
- `environment/` - package installation script

## Quick Start

### 1. Install packages
```r
source("environment/install_packages.R")
```

### 2. Run the script
```r
source("scripts/R/sentiment_comparison.R")
```

## Outputs
Expected outputs include:
- A table of sentiment scores by text
- Lexicon comparison summaries
- A bar plot of sentiment results

## Reproducibility
This repository contains only sample texts and code. It does not include private or restricted research data.

## Author
Sawood Anwar

## License
MIT License
