# LOSING ROWS!
# Must find them.
# Are there labels in senate.tweets not in senators?
# Are there labels in house.tweets not in house?
# Yes. For the moment, just ditch all of that.

senate.data <- merge(senate.tweets, senators, by = 'label')
senate.tweets <- senate.data$tweet
senate.ideal.points <- senate.data$idealPoint

# Labels for House include District
# Drop the District before doing merge().
house <- transform(house,
                   label = paste(last.name,
                                 ' (',
                                 party,
                                 '-',
                                 state,
                                 ')',
                                 sep = ''))

house.data <- merge(house.tweets, house, by = 'label')
house.tweets <- house.data$tweet
house.ideal.points <- house.data$idealPoint
