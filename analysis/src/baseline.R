library('ProjectTemplate')
load.project()

house.ideal.points <- ideal.points[1:max(which(sources == 'House'))]
senate.ideal.points <- ideal.points[min(which(sources == 'Senate')):length(sources)]

rmse <- sqrt(mean((senate.ideal.points - mean(house.ideal.points)) ^ 2))

unlink(file.path('reports', 'rmse'))
cat(paste('Baseline RMSE:', rmse, '\n'), file = file.path('reports', 'rmse'), append = TRUE)
