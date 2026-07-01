packages <- c(
  "tidyverse",
  "tidytext",
  "readr",
  "ggplot2",
  "here"
)

installed <- rownames(installed.packages())
to_install <- setdiff(packages, installed)

if (length(to_install) > 0) {
  install.packages(to_install)
}
