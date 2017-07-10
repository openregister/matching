library(here)
library(tidyverse)
library(fuzzyjoin)

# Load the source and target lists.
sources <- read_tsv(file.path(here(), "lists", "sources.tsv"))
targets <- read_tsv(file.path(here(), "lists", "targets.tsv"))

# Do the fuzzy match -- returns multiple matches per source record
fuzzy_match <- stringdist_inner_join(sources,
                                      targets,
                                      by = "match",
                                      method = "jw", # Jaro-Winkler, other available
                                      max_dist = .18, # lower is stricter
                                      distance_col = "score")

# Select only the best (lowest) match per source record
fuzzy_match %>%
  group_by(match.x) %>%
    arrange(match.x, score) %>%
    slice(1) %>%
    ungroup() %>%
    arrange(match.y, match.x) # Nicer to read
