#!/usr/bin/env python
# encoding: utf-8
"""
congressional_network.py

Description: Build the Twitter social graph of members of Congress

Created by Drew Conway (drew.conway@nyu.edu) on 2011-08-09 
# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.
"""

import sys
import os
import json
import urllib2
import re
import csv

sys.path.append("../")
import supplemental

def userGraph(twitter_user):
	"""Builds the diretional star graph for a given Twitter user.
	Returns a list of dicts of the form {'source' : twitter_id, 'target' : twitter_id}
	"""
	# Parse raw JSON and extract in- and out-bound links
	base_url = 'https://socialgraph.googleapis.com/lookup?q=http://twitter.com/'+twitter_user+'&edo=1&edi=1'
	raw_text = urllib2.urlopen(base_url)
	nodes_parsed = json.loads(raw_text.read())
	incoming = nodes_parsed['nodes']['http://twitter.com/'+twitter_user]['nodes_referenced_by']
	outgoing = nodes_parsed['nodes']['http://twitter.com/'+twitter_user]['nodes_referenced']
	
	# Many links returned by Google SG API are not to proper Twitter users, must test
	incoming_test = zip(incoming.keys(), map(isTwitter, incoming.keys()))
	good_incoming = [(a) for (a,b) in incoming_test if b]
	outgoing_test = zip(outgoing.keys(), map(isTwitter, outgoing.keys()))
	good_outgoing = [(a) for (a,b) in outgoing_test if b]
	
	# Strip out just the Twitter usernames from the good URLS
	good_incoming = map(lambda u: u.split('/')[-1], good_incoming)
	good_outgoing = map(lambda u: u.split('/')[-1], good_outgoing)
	
	# Finally, create dictionaries and return
	links = map(lambda u: {'source' : u, 'target' : twitter_user}, good_incoming)
	links.extend(map(lambda u: {'source' : twitter_user, 'target' : u}, good_outgoing))
	return links	
	
def isTwitter(url):
	"""Tests whether a URL returned by the Google SG API is a proper Twitter user's"""
	if url.count('/') > 3:
		return False
	else:
		return True
		
def twitterCSV(csv_dict, filepath):
	"""Writes a CSV from the dict returned by userGraph to filename"""
	twitter_writer = csv.DictWriter(open(filepath, 'w'), fieldnames=['source', 'target'])
	twitter_writer.writeheader()
	for u in csv_dict:
		for e in u:
			twitter_writer.writerow(e)
			
def twitterTSV(csv_dict, filepath):
	"""Writes a TSV from the dict returned by userGraph to filename. More convienient to use
	in NetworkX as edgelist format"""
	twitter_conn = open(filepath, 'w')
	twitter_conn.write('#source\ttarget\n')
	for u in csv_dict:
		for e in u:
			twitter_conn.write(e['source']+'\t'+e['target']+'\n')
	twitter_conn.close()

def main():
	
	# Get a list of U.S. members of congress on Twitter
	congress_headers = ["lastname","firstname","middlename","title","party","state","gender","twitter_id"]
	congress_data = supplemental.parse_congress("../twitter_congress.csv", congress_headers)
	twitter_ids = [a['twitter_id'].lower() for a in congress_data]
	# Create list of all links in the data base	
	all_links = map(userGraph, twitter_ids)
	
	# Create a csv using a DictWriter
	twitterCSV(all_links, 'twitter_congress_graph.csv')
	twitterTSV(all_links, 'twitter_congress_graph.edgelist')


if __name__ == '__main__':
	main()

