training.size <- round(length(y) * (2 / 3))
test.size <- round(length(y) * (1 / 3))

training.indices <- sort(sample(1:length(y), training.size))
test.indices <- (1:length(y))[! (1:length(y) %in% training.indices)]

training.x <- x[training.indices, ]
training.y <- y[training.indices]
test.x <- x[test.indices, ]
test.y <- y[test.indices]
