tune.hyperparameters <- function(x, y, lambdas = c(0.01, 0.1, 1, 10), iterations = 3, training.size = 2 / 3)
{
  performance <- data.frame()

  for (iteration in 1:iterations)
  {
    split.size <- round(length(y) * training.size)
    split.indices <- sample(1:length(y), split.size)
    remaining.indices <- (1:length(y))[! (1:length(y) %in% split.indices)]
    
    split.x <- x[split.indices, ]
    split.y <- y[split.indices]
    remaining.x <- x[remaining.indices, ]
    remaining.y <- y[remaining.indices]
    
    fit <- glmnet(split.x, split.y)
    
    for (lambda in lambdas)
    {
      predicted.y <- predict(fit, newx = remaining.x, s = lambda)
      predicted.y <- as.numeric(predicted.y[, 1])
      rmse <- sqrt(mean((remaining.y - predicted.y) ^ 2))
      performance <- rbind(performance,
                           data.frame(Lambda = lambda,
                                      Iteration = iteration,
                                      RMSE = rmse))
    }
  }
  
  mean.rmse <- ddply(performance, 'Lambda', mean)
  optimal.lambda <- with(subset(mean.rmse,
                                RMSE == with(mean.rmse, min(RMSE))),
                         Lambda)
  
  return(optimal.lambda)
}
