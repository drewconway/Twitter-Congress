#!/usr/bin/env python
# encoding: utf-8
"""
congress_tweets.py

Purpose:  Collects tweets from U.S. members of Congress and sticks them in a SQLite database

Author:   Drew Conway
Email:    drew.conway@nyu.edu
Date:     2011-04-25

Copyright (c) 2011, under the Simplified BSD License.  
For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
All rights reserved.
"""

import sys
import os
import csv
import sqlite3
import twitter
import copy
import time
from numpy import random

def parse_congress(path, headers):
    """Returns a parsed csv as list of dicts"""
    reader = csv.DictReader(open(path, "rU"), fieldnames=headers)
    reader.next() # Pop headers
    return map(lambda row: row, reader)
    
def parse_timeline(api, user_data, count=200, rt=False):
    """Returns a tuple of dictionaries with keys: 'twitter_id', 'tweet' and 'datetime'
    for the Twitter status updates of a given user"""
    user_tweets = api.GetUserTimeline(user_data["twitter_id"], count=count, include_rts=rt)
    tweet_data = map(lambda t: {"tweet":t.text, "datetime":t.created_at, "tweet_id":t.id}, user_tweets)

    # Add all the data from Twitter to table of MOC
    all_tweets = list()
    for d in tweet_data:
        data_copy = copy.deepcopy(user_data)
        data_copy.update(d)
        all_tweets.append(data_copy)
    return all_tweets
    
def get_timeline(api, user_data, count=200, rt=False, start=time.localtime()):
    """
    Function a wrapper for many tests around parse_timeline function
    """
    try:
        if api.MaximumHitFrequency() < 1:
            cur_time = time.localtime()
            wait_mins = 60 - (cur_time.tm_min - start.tm_min)   
            print "You have reached the API limit, holding until "+str(start.tm_hour + 1)+":"+str(60 - wait_mins).zfill(2)
            time.sleep(wait_mins * 60.)
        all_tweets=parse_timeline(api, user_data, count, rt)
        return all_tweets
    except twitter.TwitterError:
        print "There was an error accessing "+user_data["twitter_id"]+", be sure the user exists."
        pass
    except ValueError:
        print "Could not parse data for "+user_data["twitter_id"]
        pass
        
def insert_tweet(cursor, row, all_ids):
    """Inserts a row into the tweets table in congress_tweets.db"""
    if all_ids.count(int(row["tweet_id"])) < 1:
        first = row["firstname"]
        last = row["lastname"]
        title = row["title"]
        party = row["party"]
        state = row["state"]
        gender = row["gender"]
        twitter_id = row["twitter_id"]
        tweet = row["tweet"]
        datetime = row["datetime"]
        tweet_id = row["tweet_id"]
        # Insert row in table
        datum = [first, last, title, party, state, gender, twitter_id, tweet, datetime, tweet_id]
        cursor.execute("insert into tweets values(?,?,?,?,?,?,?,?,?,?)", datum)
    else:
        pass

def main():
    
    # Twitter API
    api = twitter.Api()
    starttime = time.localtime()
    
    # Open connection to SQLite data base
    conn = sqlite3.connect("congress_tweets")
    c = conn.cursor()
    
    # Get all of the tweet IDs currently in the DB
    tweet_cursor = c.execute("select tweet_id from tweets")
    all_tweet_ids = map(lambda i: int(i[0]), tweet_cursor.fetchall())
     
    # Get a list of U.S. members of congress on Twitter
    congress_headers = ["lastname","firstname","middlename","title","party","state","gender","twitter_id"]
    congress_data = parse_congress("twitter_congress.csv", congress_headers)
    
    # Set throttling time, assuming fresh hour
    throttle_time = 3600. / 150
    
    # Scrape data from Twitter
    for m in congress_data:
        print "Parsing "+m["firstname"]+" "+m["lastname"]+", "+m["twitter_id"]
        # Throttle back API calls as needed
        time.sleep(throttle_time + random.uniform())    # Add noise to wait time
        # First get all data for some member
        member_data = get_timeline(api, m, start=starttime)
        # Insert that data in the data base
        if member_data is not None:
            for d in member_data:
                insert_tweet(c, d, all_tweet_ids)
                
    # Close all connections and exit
    print "Scrape complete, closing DB connection"
    c.close()
    conn.commit()
    conn.close()


if __name__ == '__main__':
	main()

