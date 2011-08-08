library('ProjectTemplate')
load.project()

# We want the same splits every time.
set.seed(1234)

# Only use hashtags.
dtm <- dtm[, grep('^http', colnames(dtm), perl = TRUE)]

# Still need to enforce less sparsity.
dtm <- removeSparseTerms(dtm, 0.9999)

x <- as.matrix(dtm)
y <- ideal.points

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
                             output = file.path('reports', 'urls_lasso.csv'))
print(paste('URLs Lasso RMSE:', rmse))
