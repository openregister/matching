# Matching

Demo ways to match datasets.

1. [`fuzzyjoin`](https://cran.r-project.org/web/packages/fuzzyjoin/index.html) (R)
2. [`recordLinkage`](https://cran.r-project.org/web/packages/RecordLinkage/index.html) (R)
3. [`csvdedupe`](https://github.com/dedupeio/csvdedupe) (Python)
4. [`fastLink`](https://cran.r-project.org/web/packages/fastLink/index.html) (R)

## Source data

`lists/sources.tsv` is the list of wild government entities to be matched to
ones in registers. It is a list from JISC, the source for the
`government-domain` register.

One transformation is applied at this pre-matching stage: conversion to
lowercase.

## Matching data

`lists/target.tsv` is the dataset to be matched to.  It is a combination of
registers:

* `government-organisation`
* `local-authority-eng`
* `local-authority-sct`
* `local-authority-wls`
* `local-authority-nir`

## fuzzyjoin (R)

The [`fuzzyjoin`](https://cran.r-project.org/web/packages/fuzzyjoin/index.html)
package wraps the [`stringdist`](https://github.com/markvanderloo/stringdist)
package (among others) in a dplyr-like interface, so instead of `left_join()` it
provides `stringdist_left_join()`, etc.  It only matches one column at a time.

Various matching algorithms are available, e.g. Jaro-Winkler, which are
specified and parameterised in the call to `stringdist_left_join()`.

See `R/fuzzyjoin.R` for a working example.

```
# A tibble: 672 x 3
                            match.x                          match.y     score
                              <chr>                            <chr>     <dbl>
 1            adur district council            adur district council 0.0000000
 2        allerdale borough council        allerdale borough council 0.0000000
 3     amber valley borough council     amber valley borough council 0.0000000
 4           antrim borough council           antrim borough council 0.0000000
 5         wroughton parish council           antrim borough council 0.1775253
 6 armagh city and district council armagh city and district council 0.0000000
 7             arts council england             arts council england 0.0000000
 8            arclid parish council            arun district council 0.1760037
 9            arun district council            arun district council 0.0000000
10        ashfield district council        ashfield district council 0.0000000
# ... with 662 more rows
```

## recordLinkage (R)

The
[`recordLinkage`](https://cran.r-project.org/web/packages/RecordLinkage/index.html)
package matches several columns at once, and weights the scores to determine
likely matches.  The interface isn't as friendly, so `fuzzyjoin` is recommended
unless multiple-column matching is really beneficial.

There is no working example here.

## csvdedupe (Python)

The [`csvdedupe`](https://github.com/dedupeio/csvdedupe) package is part of the
`dedupe.io` ecosystem.  A web interface is available for money, as long as you
are willing to upload your data to their servers.  The web interface doesn't do
anything that isn't already pretty easy with `csvdedupe`, and the command-line
version remembers what it learned between sessions.

There's a [simple
explanation](https://dedupe.io/documentation/how-it-works.html#matching-records)
of how it works.

To install, `pip install git+https://github.com/nacnudus/csvdedupe`, which is a
version patched to accept tsv until [this
issue](https://github.com/dedupeio/csvdedupe/issues/56) is closed (the patch
doesn't meet the author's requirements).

To run the example: `./python/dedupe.sh` and answer 'y' or 'n' to the suggested
matches until you run out of patience.  Ten each of 'y' and 'n' are recommended
-- hence the visual feedback in the terminal showing how many responses out of
10 you have provided.  Then answer 'f' and it will use your responses to
complete the matches for the whole file, writing them to
`lists/matched_csvdedupe.tsv`.

```
> ./python/dedupe.sh
Got dialect
INFO:root:imported 2911 rows from file 1
INFO:root:imported 1424 rows from file 2
INFO:root:using fields: ['match']
INFO:root:taking a sample of 1500 possible pairs
/home/nacnudus/miniconda3/envs/dedupe/lib/python3.6/site-packages/dedupe/sampling.py:39: UserWarning: 750 blocked samples were requested, but only able to sample 749
  % (sample_size, len(blocked_sample)))
INFO:root:starting active labeling...
match : her majesty's inspectorate of constabulary

match : hm inspectorate of constabulary

0/10 positive, 0/10 negative
Do these records refer to the same thing?
(y)es / (n)o / (u)nsure / (f)inished
```

```
match,match
home office,home office
mole valley district council,mole valley district council
northern ireland office,northern ireland office
food standards agency,food standards agency
adur district council,adur district council
department for business, energy & industrial strategy,department for business, energy & industrial strategy
department of agriculture, environment and rural affairs,department of agriculture, environment and rural affairs (northern ireland)
department for work and pensions,department for work and pensions
ministry of justice,ministry of justice
stratford-on-avon district council,stratford-on-avon district council
allerdale borough council,allerdale borough council
amber valley borough council,amber valley borough council
```

## fastLink

The [`fastLink`](https://cran.r-project.org/web/packages/fastLink/index.html)
package is similar to `recordLinkage` in that it uses multiple columns to decide
a match.  Under the hood it uses the `stringdist` package to match string
columns.  It is a newer package (circa July 2017) and has friendlier
documentation.  Wikipedia has a [useful
page](https://en.wikipedia.org/wiki/Record_linkage#Probabilistic_record_linkage)
on probabalistic weighting, otherwise defaults are available.
