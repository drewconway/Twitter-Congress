# File-Name:       tweet_cleaner.R           
# Date:            2011-05-12                                
# Author:          Drew Conway
# Email:           drew.conway@nyu.edu                                      
# Purpose:         Attempt to find and encode Tweets in a uniform way
# Data Used:       congress_tweets sqlite DB
# Packages Used:   RSQLite, tm
# Machine:         Drew Conway's MacBook Pro

# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.                                                         

library(RSQLite)
library(tm)
library(ggplot2)

# Create connection to db
conn <- dbConnect("SQLite", "congress_tweets")
tweet.table <- dbReadTable(conn, "tweets") 

# Get word list
# word.list <- readLines("../../tmp/word_list_moby_crossword.flat.txt")

# Convert 'created_at' column to POSIXlt type
tweet.table$created_at <- strptime(tweet.table$created_at, "%a %b %d %H:%M:%S +0000 %Y")

# Find subset that do not contain a link
with.url<-grepl("http://", tweet.table$tweet)
tweet.nolink<-tweet.table[!with.url,]


# Find the common denominator for time. We may not want to compare speech across. 
# Interesting problem re: left and right censoring.  There will be obs that could 
# be full left-censored, and likewise right-censored.  What to do?

tweet.daterange<-ddply(tweet.table,.(twitter_id), summarise, 
    Min.Date=min(as.Date(created_at)), 
    Max.Date=max(as.Date(created_at)),
    count=length(tweet),
    party=as.factor(unique(party)))
    
tweet.daterange<-tweet.daterange[with(tweet.daterange, order(Min.Date, Max.Date)),]
tweet.daterange$order<-1:nrow(tweet.daterange)

daterange.plot<-ggplot(tweet.daterange)+geom_segment(aes(x=Min.Date, y=order, xend=Max.Date, yend=order, color=party))+
    scale_color_manual(values=c("R"="red","D"="blue","I"="green"), name="Party")+
    geom_text(aes(x=max(tweet.daterange$Max.Date)+1, y=tweet.daterange$order, label=tweet.daterange$twitter_id,
        size=.2, hjust=0))+
    scale_size(to=c(.1,1), legend=FALSE)+scale_y_continuous(breaks=c(1,nrow(tweet.daterange)), labels=rep("",2))+
    xlab("Date")+ylab("")+opts(panel.grid.minor=theme_blank(), axis.ticks=theme_blank())+
        theme_bw()
ggsave(plot=daterange.plot, filename="images/daterange_plot.pdf", width=15, height=12)
ggsave(plot=daterange.plot, filename="images/daterange_plot.png", width=35, height=29)
    
