#!/bin/sh
csvlink ./lists/sources.tsv ./lists/targets.tsv \
  --field_names match \
  --output_file ./lists/matched_csvdedupe.tsv
