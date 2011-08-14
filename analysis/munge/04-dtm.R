documents <- data.frame(Text = c(house.tweets, senate.tweets))
row.names(documents) <- 1:nrow(documents)
cache('documents')

ideal.points <- c(house.ideal.points, senate.ideal.points)
cache('ideal.points')

sources <- c(rep('House', length(house.tweets)), rep('Senate', length(senate.tweets)))
cache('sources')

corpus <- Corpus(DataframeSource(documents))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
# How to remove weird characters?

# Remove terms without sufficient repetition to make problem tractable.
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.9995)
cache('dtm')
