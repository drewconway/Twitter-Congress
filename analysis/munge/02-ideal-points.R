ideal.pointilized.data <- merge(tweets, senators, by = 'label')

ideal.points <- ideal.pointilized.data$idealPoint

cache('ideal.points')
