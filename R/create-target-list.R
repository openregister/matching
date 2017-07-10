# Create the list to be matched to, by combining certain registers:
# * `government-organisation`
# * `local-authority-eng`
# * `local-authority-sct`
# * `local-authority-wls`
# * `local-authority-nir`

library(here)
library(tidyverse)

government_organisation <-
  "https://government-organisation.register.gov.uk/records.tsv?page-size=5000" %>%
  read_tsv() %>%
  rename(match = name) %>%
  select(match)
local_authority_eng <-
  "https://local-authority-eng.register.gov.uk/records.tsv?page-size=5000" %>%
  read_tsv() %>%
  rename(match = `official-name`) %>%
  select(match)
local_authority_sct <-
  "https://local-authority-sct.register.gov.uk/records.tsv?page-size=5000" %>%
  read_tsv() %>%
  rename(match = `official-name`) %>%
  select(match)
principal_local_authority <-
  "https://principal-local-authority.register.gov.uk/records.tsv?page-size=5000" %>%
  read_tsv() %>%
  rename(match = `official-name`) %>%
  select(match)
local_authority_nir <-
  "https://local-authority-nir.discovery.openregister.org/records.tsv?page-size=5000" %>%
  read_tsv() %>%
  rename(match = `official-name`) %>%
  select(match)
bind_rows(government_organisation,
                    local_authority_eng,
                    local_authority_sct,
                    principal_local_authority,
                    local_authority_nir) %>%
  mutate(match = tolower(match)) %>%
  write_tsv(file.path(here(), "lists", "targets.tsv"))
