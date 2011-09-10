# File-Name:       net_data_merge.R
# Date:            2011-09-09
# Author:          Drew Conway
# Email:           drew.conway@nyu.edu                                      
# Purpose:         Merges Jackman's ideal point data with Twitter ID for 112th Senate and House. Actual estimation done in Python (easier)
# Data Used:       twitter_congress.csv, house.csv, seante.csv
# Packages Used:   
# Output File:     
# Data Output:     
# Machine:         Drew Conway's MacBook Pro

# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.

# Load in supplemental data, and split Houses
twitter.congress <- read.csv('../twitter_congress.csv', stringsAsFactors=FALSE)
twitter.senate <- subset(twitter.congress, title=='Sen')
twitter.house <- subset(twitter.congress, title=='Rep')

# Merge Senate
jackman.senate <- read.csv('senate.csv', as.is=TRUE)
jackman.senate$last.name[which(jackman.senate$last.name == 'Manchin III')] <- 'Manchin' # One problematic Jackman entry
senate.ideal <- merge(twitter.senate, jackman.senate, by.x=c('lastname', 'state'), by.y=c('last.name', 'state'), all.x=TRUE)

# Merge House
jackman.house <- read.csv('house.csv', as.is=TRUE)
# Lots of annoying mismatches to fix so the data merge correctly
jackman.house$last.name<-sub(' Jr.', '', jackman.house$last.name)
jackman.house$last.name<-sub(' II', '', jackman.house$last.name)
jackman.house$last.name[which(jackman.house$last.name == 'Herrera Beutler')] <- 'Herrera'
jackman.house$last.name[which(jackman.house$last.name == 'Jackson-Lee')] <- 'Jackson Lee'
jackman.house$last.name[which(jackman.house$last.name == 'McMorris Rodgers')] <- 'McMorris-Rodgers'
house.ideal <- merge(twitter.house, jackman.house, by.x=c('lastname', 'state'), by.y=c('last.name', 'state'), all.x=TRUE)

# Save results
write.csv(senate.ideal, 'senate_merge.csv', row.names=FALSE)
write.csv(house.ideal, 'house_merge.csv', row.names=FALSE)