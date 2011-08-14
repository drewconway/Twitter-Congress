library('ProjectTemplate')
load.project()

# We want the same splits every time.
set.seed(1234)

# Only use hashtags.
dtm <- dtm[, grep('^#', colnames(dtm), perl = TRUE)]

x <- as.matrix(dtm)
y <- ideal.points

# Drop hashtags that occur only once.
occurrences <- apply(x, 2, sum)
x <- x[, which(occurrences > 1)]

# Set up training set and test set.
source(file.path('src', 'set_up_regression.R'))

# Need to use cross-validation here to set lambda.
lambdas <- c(1, 0.5, 0.25, 0.1, 0.05, 0.01, 0.005, 0.001)
optimal.lambda <- tune.hyperparameters(training.x,
                                       training.y,
                                       lambdas,
                                       alpha = 1)

# Refit model to whole training set.
rmse <- fit.and.assess.model(training.x,
                             training.y,
                             test.x,
                             test.y,
                             alpha = 1,
                             lambda = optimal.lambda,
                             output = file.path('reports', 'hashtags_lasso.csv'))
print(paste('Hashtag Lasso RMSE:', rmse))

# Correlate weights with party of those using term.
terms <- read.csv(file.path('reports', 'hashtags_lasso.csv'))

party.association <- ddply(terms,
                           'Word',
                           function (df)
                           {
                             parties <- tweets$party[grep(with(df, unique(Word)), tweets$tweet, ignore.case = TRUE)]
                             data.frame(Weight = with(df, unique(Weight)),
                                        D = mean(parties == 'D'),
                                        R = mean(parties == 'R'),
                                        I = mean(parties == 'I'))
                            })

p <- ggplot(party.association, aes(x = Weight, y = R)) +
  geom_point() +
  geom_smooth() +
  xlab('Weight from Lasso Text Regression') +
  ylab('Frequency of Usage by Republican Senators') +
  opts(title = 'Pure Party Affiliation vs. Ideal Point Estimation')
ggsave(file.path('graphs', 'classification_vs_regression.pdf'))
# How to explain terms with large weights in the wrong direction?

subset(party.association, Weight > 0 & R < 0.5)
subset(party.association, Weight < 0 & R > 0.5)
