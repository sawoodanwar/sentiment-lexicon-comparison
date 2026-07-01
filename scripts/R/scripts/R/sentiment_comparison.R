
library(tidyverse)
library(tidytext)
library(readr)
library(ggplot2)
library(here)

data_file <- here("data", "sample", "sample_texts.csv")
results_dir <- here("results")
dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(file.path(results_dir, "tables"), showWarnings = FALSE, recursive = TRUE)
dir.create(file.path(results_dir, "figures"), showWarnings = FALSE, recursive = TRUE)

df <- read_csv(data_file)

tidy_df <- df %>%
  unnest_tokens(word, text)

afinn_scores <- tidy_df %>%
  inner_join(get_sentiments("afinn"), by = "word") %>%
  group_by(id) %>%
  summarise(afinn_score = sum(value), .groups = "drop")

bing_scores <- tidy_df %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(score = ifelse(sentiment == "positive", 1, -1)) %>%
  group_by(id) %>%
  summarise(bing_score = sum(score), .groups = "drop")

nrc_scores <- tidy_df %>%
  inner_join(get_sentiments("nrc"), by = "word") %>%
  filter(sentiment %in% c("positive", "negative")) %>%
  mutate(score = ifelse(sentiment == "positive", 1, -1)) %>%
  group_by(id) %>%
  summarise(nrc_score = sum(score), .groups = "drop")

comparison <- df %>%
  left_join(afinn_scores, by = "id") %>%
  left_join(bing_scores, by = "id") %>%
  left_join(nrc_scores, by = "id") %>%
  mutate(across(c(afinn_score, bing_score, nrc_score), ~replace_na(., 0)))

write_csv(comparison, file.path(results_dir, "tables", "sentiment_comparison.csv"))

plot_data <- comparison %>%
  select(id, afinn_score, bing_score, nrc_score) %>%
  pivot_longer(cols = -id, names_to = "lexicon", values_to = "score")

p <- ggplot(plot_data, aes(x = factor(id), y = score, fill = lexicon)) +
  geom_col(position = "dodge") +
  theme_minimal() +
  labs(
    title = "Sentiment Scores by Lexicon",
    x = "Text ID",
    y = "Sentiment Score"
  )

ggsave(file.path(results_dir, "figures", "sentiment_comparison_plot.png"), p, width = 8, height = 5)

cat("Saved results to results/tables and results/figures\n")
