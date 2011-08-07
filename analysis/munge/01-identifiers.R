tweets <- subset(tweets, title == 'Sen')

tweets <- transform(tweets, label = paste(last, ' (', party, '-', state, ')', sep = ''))
