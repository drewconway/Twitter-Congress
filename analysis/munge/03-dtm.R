documents <- data.frame(Text = ideal.pointilized.data$tweet)
row.names(documents) <- 1:nrow(documents)

corpus <- Corpus(DataframeSource(documents))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
# How to remove weird characters?
cache('corpus')

dtm <- DocumentTermMatrix(corpus)
cache('dtm')
