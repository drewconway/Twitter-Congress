library('ProjectTemplate')
load.project()

# Train on House; test on Senate
house.dtm <- dtm[1:max(which(sources == 'House')), ]
senate.dtm <- dtm[min(which(sources == 'Senate')):length(sources), ]
house.ideal.points <- ideal.points[1:max(which(sources == 'House'))]
senate.ideal.points <- ideal.points[min(which(sources == 'Senate')):length(sources)]

training.x <- as.matrix(house.dtm)
training.y <- house.ideal.points

test.x <- as.matrix(senate.dtm)
test.y <- senate.ideal.points

training.x <- scale(training.x)
test.x <- scale(test.x)

indices <- union(which(apply(training.x, 2, sd) != 1), which(apply(test.x, 2, sd) != 1))
training.x <- training.x[, -indices]
test.x <- training.x[, -indices]

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
                             output = file.path('reports', 'scale_lasso.csv'))
cat(paste('Scale Lasso RMSE:', rmse, '\n'), file = file.path('reports', 'rmse'), append = TRUE)
