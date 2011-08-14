library('ProjectTemplate')
load.project()

tweets$tweet[grep('#hayek', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#hcr', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#helpfindlauren', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#nih', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#hackgate', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#fortcollins', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#il,', tweets$tweet, ignore.case = TRUE)]

tweets$tweet[grep('#debt', tweets$tweet, ignore.case = TRUE)]

# Some terms have large weights in one direction, but are most frequently associated with opposing party.
tweets$party[grep('#gasprices', tweets$tweet, ignore.case = TRUE)]
