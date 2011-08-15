#!/usr/bin/env python
# encoding: utf-8
"""
network_analysis.py

Description: A brief analysis of the U.S. Congressional Twitter network

Created by Drew Conway (drew.conway@nyu.edu) on 2011-08-09 
# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.
"""

import sys
import os
import networkx as nx
from networkx import core

def main():
	# Load graph
	twitter_graph = nx.read_edgelist('twitter_congress_graph.edgelist', delimiter="\t", nodetype=str, create_using=nx.DiGraph())
	twitter_graph.remove_edges_from(twitter_graph.selfloop_edges())
	
	# Find largest connected component
	twitter_mc = nx.weakly_connected_component_subgraphs(twitter_graph)[0]
	
	# Take 2-core of main component
	mc_core = core.k_core(twitter_mc, 2)
	
	# Output results
	nx.write_edgelist(twitter_graph, 'twitter_congress_clean.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(twitter_mc, 'twitter_congress_mc.edgelist', delimiter='\t', data=False)
	nx.write_edgelist(mc_core, 'twitter_congress_mc_2core.edgelist', delimiter='\t', data=False)

if __name__ == '__main__':
	main()

