sen <- read.csv('supplemental/network_model/senate_est.csv')

ggplot(sen, aes(x = idealPoint, y = ideal_pointEst)) + geom_point()

sen <- transform(sen, scaledEstimate = as.numeric(scale(ideal_pointEst)))

ggplot(sen, aes(x = idealPoint, y = scaledEstimate)) + geom_point()

# network.rmse
with(sen, sqrt(mean((idealPoint - scaledEstimate) ^ 2)))
#baseline.rmse
with(sen, sqrt(mean(idealPoint ^ 2)))
