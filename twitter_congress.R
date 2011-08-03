# File-Name:       twitter_congress.R           
# Date:            2011-03-11                                
# Author:          Drew Conway
# Email:           drew.conway@nyu.edu                                      
# Purpose:         Get data on all members of Congress on Twitter
# Data Used:       Interact with the Sunlight Labs API
# Packages Used:   JSONIO, RCurl
# Output File:     twitter_congress.csv
# Machine:         Drew Conway's MacBook Pro

# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.                                                         

library(RJSONIO)
library(RCurl)

# Collect names, party ID, and Twitter name for all members of Congress

# Global values for performing API calls
sl.api<-"9dcc5820bd1648a08f8f300f86b5db70"
sl.base<-"http://services.sunlightlabs.com/api/"

# Get all Congressional data
raw.json<-getURL(paste(sl.base,"legislators.getList.json?apikey=",sl.api,sep=""))
parsed.data<-fromJSON(raw.json)

# Extract Name, Party ID, and Twitter ID for those that have twitter
legislators<-parsed.data$response$legislators

# A function that extracts Name, Party ID, State, gender, and Twitter ID for those 
# that have twitter, otherwise return NA vector
get.tweeters<-function(element) {
    if(element$legislator$twitter_id!="") {
        twitter_data<-c(element$legislator$lastname, element$legislator$firstname, element$legislator$middlename, 
            element$legislator$title, element$legislator$party, element$legislator$state, element$legislator$gender,
            element$legislator$twitter_id)
    }
    else {
        twitter_data<-rep(NA,6)
    }
    return(twitter_data)
}

# Create data frame from data
tweeter.list<-lapply(legislators, get.tweeters)
tweeter.matrix<-do.call(rbind, tweeter.list)
tweeter.df<-data.frame(tweeter.matrix, stringsAsFactors=FALSE)
tweeters.only<-subset(tweeter.df, !is.na(X1))

# Export data frame
names(tweeters.only)<-c("lastname","firstname","middlename","title","party","state","gender","twitter_id")
write.csv(tweeters.only, "twitter_congress.csv", row.names=FALSE)

