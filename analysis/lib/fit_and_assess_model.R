# Where is intercept winding up?
fit.and.assess.model <- function(training.x,
                                 training.y,
                                 test.x,
                                 test.y,
                                 alpha = 1,
                                 lambda = 1,
                                 output = 'results.csv')
{
  fit <- glmnet(training.x, training.y, alpha = alpha)
  
  predicted.y <- predict(fit, newx = test.x, s = lambda)
  predicted.y <- as.numeric(predicted.y[,1])
  
  rmse <- sqrt(mean((test.y - predicted.y) ^ 2))
  
  terms <- coef(fit, s = lambda)
  words <- colnames(x)[which(terms != 0)]
  weights <- terms[which(terms != 0)]
  results <- data.frame(Word = words, Weight = weights)
  write.csv(results, file = output, row.names = FALSE)
  
  return(rmse)
}
