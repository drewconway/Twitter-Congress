library('ProjectTemplate')
load.project()

# We want the same splits every time.
set.seed(1234)

# Experiment with removing excessively sparse terms.
# 0.99 => 87 terms
# 0.999 => 1455 terms
# 0.9995 => 2728 terms
# 0.9999 => 13022 terms
dtm <- removeSparseTerms(dtm, 0.9995)

# Subsample data?
#n <- 500
#indices <- sort(sample(1:nrow(dtm), n))
#dtm <- dtm[indices, ]

x <- as.matrix(dtm)
# Many columns are zero everywhere. What to do?
y <- ideal.points

# Random split into training and test.
training.size <- round(length(y) * (2 / 3))
test.size <- round(length(y) * (1 / 3))

training.indices <- sort(sample(1:length(y), training.size))
test.indices <- (1:length(y))[! (1:length(y) %in% training.indices)]

training.x <- x[training.indices, ]
training.y <- y[training.indices]
test.x <- x[test.indices, ]
test.y <- y[test.indices]

# Need to use cross-validation here to set lambda.
lambdas <- c(1, 0.5, 0.25, 0.1, 0.05, 0.01, 0.005, 0.001)
optimal.lambda <- tune.hyperparameters(training.x, training.y, lambdas)

# Refit model to whole training set.
fit <- glmnet(training.x, training.y)

predicted.y <- predict(fit, newx = test.x, s = optimal.lambda)
predicted.y <- as.numeric(predicted.y[,1])

rmse <- sqrt(mean((test.y - predicted.y) ^ 2))

terms <- coef(fit, s = optimal.lambda)
words <- colnames(x)[which(terms != 0)]
weights <- terms[which(terms != 0)]
results <- data.frame(Word = words, Weight = weights)
write.csv(results, file = 'results.csv', row.names = FALSE)
# Intercept is probably first term.
