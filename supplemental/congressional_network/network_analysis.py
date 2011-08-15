#!/usr/bin/env python
# encoding: utf-8
"""
network_analysis.py

Description: A small script to clean and chop (and skew) the U.S. Congressional Twitter network

Created by Drew Conway (drew.conway@nyu.edu) on 2011-08-09 
# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.
"""

import sys
import os
import networkx as nx
from networkx import core
import csv

def congressSubgraph(base_graph, title='Rep'):
	"""Generate a subgraph from a Congerssional Twitter graph based on a member's title"""
	header = ['lastname','firstname','middlename','title','party','state','gender','twitter_id']
	congress_reader = csv.DictReader(open('../twitter_congress.csv', 'rU'), fieldnames=header)
	all_congress = map(lambda l: l, congress_reader)
	mem_list = [(a['twitter_id']) for (a) in all_congress if a['title']==title]
	return nx.subgraph(base_graph, mem_list)
	
	

def main():
	# Load graph
	twitter_graph = nx.read_edgelist('twitter_congress_graph.edgelist', delimiter="\t", nodetype=str, create_using=nx.DiGraph())
	twitter_graph.remove_edges_from(twitter_graph.selfloop_edges())
	
	# Find largest connected component
	twitter_mc = nx.weakly_connected_component_subgraphs(twitter_graph)[0]
	
	# Extract chamber-specific networks
	rep_network = congressSubgraph(twitter_graph, title='Rep')
	sen_network = congressSubgraph(twitter_graph, title='Sen')
	
	# Take 2-core of main component
	mc_core = core.k_core(twitter_mc, 2)
	
	# Output results
	nx.write_edgelist(twitter_graph, 'twitter_congress_clean.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(twitter_mc, 'twitter_congress_mc.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(mc_core, 'twitter_congress_mc_2core.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(rep_network, 'twitter_representative_mc.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(sen_network, 'twitter_senators_mc.edgelist', delimiter='\t', data=False)
	
if __name__ == '__main__':
	main()

