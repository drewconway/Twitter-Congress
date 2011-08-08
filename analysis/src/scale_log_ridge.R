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

x <- as.matrix(dtm)
y <- ideal.points

# Use a scaling transform and a log transform on the counts.
x <- scale(log1p(x))

# Set up training set and test set.
source(file.path('src', 'set_up_regression.R'))

# Need to use cross-validation here to set lambda.
lambdas <- c(1, 0.5, 0.25, 0.1, 0.05, 0.01, 0.005, 0.001)
optimal.lambda <- tune.hyperparameters(training.x,
                                       training.y,
                                       lambdas,
                                       alpha = 0)

# Refit model to whole training set.
rmse <- fit.and.assess.model(training.x,
                             training.y,
                             test.x,
                             test.y,
                             alpha = 0,
                             lambda = optimal.lambda,
                             output = file.path('reports', 'scale_log_ridge.csv'))
print(paste('Scale Log Ridge RMSE:', rmse))
