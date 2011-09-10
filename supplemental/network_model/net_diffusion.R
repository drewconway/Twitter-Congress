# File-Name:       net_diffusion.R
# Date:            2011-09-09
# Author:          Drew Conway
# Email:           drew.conway@nyu.edu                                      
# Purpose:         
# Data Used:       
# Packages Used:   
# Output File:     
# Data Output:     
# Machine:         Drew Conway's MacBook Pro

# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.

library(igraph)

twitter.el <- read.table('../congressional_network/twitter_congress_mc_2core.edgelist', sep='\t')
twitter.tc <- graph.data.frame(twitter.el, directed=FALSE)

senate.ideal <- read.csv('senate_merge.csv', as.is=TRUE)
senate.ideal$twitter_id <- tolower(senate.ideal$twitter_id)
house.ideal <- read.csv('house_merge.csv', as.is=TRUE)
house.ideal$twitter_id <- tolower(house.ideal$twitter_id)

linear.decay <- function(i, k) i/(k+1)

# Calculate for senate first
sens.est <- c()
for(x in 1:nrow(senate.ideal)) {
	for(y in 1:nrow(house.ideal)) {
		print(senate.ideal$twitter_id[x])
		print(house.ideal$twitter_id[y])
		k <- length(get.shortest.paths(twitter.tc, senate.ideal$twitter_id[x], house.ideal$twitter_id[y])[[1]])
		i <- house.ideal$idealPoint[y]
	}
	print(linear.decay(k, i))
	sens.est <- append(sens.est, linear.decay(k, i))
}