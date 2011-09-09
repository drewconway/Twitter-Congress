#!/usr/bin/env python
# encoding: utf-8
"""
net_diffusion.py

Description: Used to estiame a simple diffusion model of politcal ideal points through the Twitter network

Created by Drew Conway (drew.conway@nyu.edu) on 2011-09-09 
# Copyright (c) 2011, under the Simplified BSD License.  
# For more information on FreeBSD see: http://www.opensource.org/licenses/bsd-license.php
# All rights reserved.
"""

import sys
import os
import networkx as nx
import csv
import copy

diffusion=lambda k, i: i/(k+1)

def net_ideal(node, broadcasts, G, diffusion=lambda i, k: i/(k+1)):
	"""
	Calculate an estimated ideal point for a given member of the network using a 
	simple linear decay diffusion model (by default). 
	"""
	all_length =  nx.single_source_shortest_path_length(G, node.lower())
	diff_calc = list()
	for n in broadcasts:
		try:
			diff_calc.append(diffusion(float(n['idealPoint']), all_length[n['twitter_id'].lower()]))
		except KeyError:
			# Somehow nodes not in the graph are in the ideal point est
			diff_calc.append(0)
	return sum(diff_calc)
		

def main():
	# Load in network and make copies
	twitter_mc = nx.read_edgelist('../congressional_network/twitter_congress_mc_2core.edgelist', create_using=nx.Graph(), nodetype=str)

	# Load ideal point data
	senate_reader = csv.DictReader(open('senate_merge.csv', 'r'))
	senate_ideal = map(lambda l: l, senate_reader)
	house_reader = csv.DictReader(open('house_merge.csv', 'r'))
	house_ideal = map(lambda l: l, house_reader)
	
	# Add ideal point scores for Sens and Reps to their respective networks
	# for sen in senate_ideal:
	# 		twitter_mc.add_node(sen['twitter_id'], ideal_point=sen['idealPoint'])
	# 	
	# 	for rep in house_ideal:
	# 		twitter_mc.add_node(rep['twitter_id'], ideal_point=rep['idealPoint'])
		
	# Calculate estimated ideal points for opposite house in each network
	for i in xrange(len(house_ideal)):
		try:
			house_ideal[i]['ideal_pointEst'] = net_ideal(house_ideal[i]['twitter_id'], senate_ideal, twitter_mc)
		except KeyError:
			house_ideal[i]['ideal_pointEst'] = 'NA'
		
	for i in xrange(len(senate_ideal)):
		try:
			senate_ideal[i]['ideal_pointEst'] = net_ideal(senate_ideal[i]['twitter_id'], house_ideal, twitter_mc)
		except KeyError:
			senate_ideal[i]['ideal_pointEst'] = 'NA'
		
	# Output estimated ideal points in new CSVs
	senate_header = senate_ideal[0].keys()
	house_header = house_ideal[0].keys()
	
	house_writer = csv.DictWriter(open('house_est.csv', 'w'), fieldnames=house_header)
	house_writer.writeheader()
	for r in house_ideal:
		house_writer.writerow(r)
		
	senate_writer = csv.DictWriter(open('senate_est.csv', 'w'), fieldnames=senate_header)
	senate_writer.writeheader()
	for r in senate_ideal:
		senate_writer.writerow(r)
		
	# print 'CSVs written'
	# 	
	# 	# Output graph files with estimates
	# 	nx.write_graphml(twitter_mc, 'twitter_ests.graphml')

if __name__ == '__main__':
	main()

