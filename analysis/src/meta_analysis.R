library('ProjectTemplate')
load.project()

files <- dir('reports')
files <- files[grep('csv', files)]

terms <- data.frame()

for (file in files)
{
  df <- read.csv(file.path('reports', file))
  df <- transform(df, Source = file)
  terms <- rbind(terms, df)
}

recurrences <- ddply(terms, 'Word', nrow)
recurring.terms <- with(subset(recurrences, V1 == 8), Word)

mean.weights <- ddply(subset(terms, Word %in% recurring.terms),
                      'Word',
                      function (df) {with(df, mean(Weight))})

mean.weights <- mean.weights[order(mean.weights$V1), ]

write.csv(mean.weights, file = file.path('reports', 'mean_weights.csv'), row.names = FALSE)

median.weights <- ddply(subset(terms, Word %in% recurring.terms),
                        'Word',
                        function (df) {with(df, median(Weight))})

median.weights <- median.weights[order(median.weights$V1), ]

write.csv(median.weights, file = file.path('reports', 'median_weights.csv'), row.names = FALSE)

terms <- cast(terms, Word ~ Source, value = 'Weight')

p <- ggplot(terms, aes(x = `lasso.csv`, y = `ridge.csv`)) +
  geom_point()
ggsave(file.path('graphs', 'lasso_vs_ridge.pdf'))

p <- ggplot(terms, aes(y = `lasso.csv`, x = `ridge.csv`)) +
  geom_point()
ggsave(file.path('graphs', 'ridge_vs_lasso.pdf'))
