library('ProjectTemplate')
load.project()

y <- ideal.points

rmse <- sqrt(mean((y - mean(y)) ^ 2))

print(paste('Baseline RMSE:', rmse))
