import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
import csv, sys
import random
import numpy
import numpy as np
import itertools


ox.config(use_cache=True, log_console=True)
ox.__version__


# store some pick_up and dropoff locations 
# we will use these locations later
pickup_locas = []
dropoffs_locas = []

#random select some pick_up and drop_off locations from the taxi_cab dataset
rand_inx = random.sample(range(1, 10000), 100);

print('The random chosen index vector from the rows of dataset (1,10000) is',rand_inx)
# open the taxicab data csv file 
filename = 'yellow_tripdata_2016-06.csv'
with open(filename, newline='', encoding='utf-8') as f:
	reader  = csv.reader(f)
	header_row_index = dict((h, i) for i, h in enumerate(next(reader)))
	interest_rows=[row for idx, row in enumerate(reader) if idx in rand_inx]
	for row in interest_rows:
		pickup_lat_long = (float(row[header_row_index['pickup_latitude']]), float(row[header_row_index['pickup_longitude']]))
		dropoff_lat_long = (float(row[header_row_index['dropoff_latitude']]), float(row[header_row_index['dropoff_longitude']]))
		pickup_locas.append(pickup_lat_long)  
		dropoffs_locas.append(dropoff_lat_long)		

# get a graph for some city, new york
G = ox.graph_from_place('Manhattan, New York, USA', network_type='drive')
# # fig, ax = ox.plot_graph(G)

# # we have the graph for the city, we also know the pick_up locations and the drop_off locations
# # then we are going to create a shortest path from each pick_up to each drop_off and store the
# # lengths of the shortest paths.  
# # In order to do a N to 1 assignment, we only use 1/3 of the drop_off locations. 
# # create a N*M matrix to store the length of the shorest paths 


# # if the node has been used, ignore it
pick_up_node = []
drop_off_node =[]

# find unique pick_up and drop_off
for pick, drop in zip(pickup_locas, dropoffs_locas):
	orig_node = ox.get_nearest_node(G, (pick[0], pick[1]))
	dest_node = ox.get_nearest_node(G, (drop[0], drop[1]))
	if orig_node not in pick_up_node and orig_node not in drop_off_node:
		pick_up_node.append(orig_node)
	else:
		pass				
	if dest_node not in pick_up_node and dest_node not in drop_off_node:
		drop_off_node.append(dest_node)				
	else:
		pass	

# # find unique pick_up and drop_off
# for pick in pickup_locas:
# 	orig_node = ox.get_nearest_node(G, (pick[0], pick[1]))
# 	if orig_node not in pick_up_node and orig_node not in drop_off_node:
# 		pick_up_node.append(orig_node)	
# 		for drop in dropoffs_locas:
# 			dest_node = ox.get_nearest_node(G, (drop[0], drop[1]))
# 			if dest_node not in pick_up_node and dest_node not in drop_off_node:
# 				drop_off_node.append(dest_node)
# 			else:
# 				pass					
# 	else:
# 		pass
		

print('The selected pick_up_node vector is', pick_up_node)
print('The selected drop_off_node vector is', drop_off_node)
print('The length of pick_up_node vector is', len(pick_up_node))
print('The length of drop_off_node vector is',len(drop_off_node))

shortest_paths_len = [[0 for x in range(len(pick_up_node))] for y in range(len(drop_off_node))] 

shortest_paths_len = numpy.zeros((len(pick_up_node), len(drop_off_node)))
# calculate the shorest path between each pick_up and each drop_off
for i in range(len(pick_up_node)):
	for j in range(len(drop_off_node)):
		route_length = nx.shortest_path_length(G, pick_up_node[i], drop_off_node[j], weight='length')
		shortest_paths_len[i][j] = route_length

print('The shorest_path_length matrix is', shortest_paths_len)
print('Save the shortest_path_length matrix in the txt file')
np.savetxt('shortest_path_len.txt',shortest_paths_len,fmt='%.2f')


# # get the nearest network node to each point of the two or more lat_long
# # orig_node = ox.get_nearest_node(G, (40.706967, -74.025242))
# # dest_node = ox.get_nearest_node(G, (40.808687, -73.927236))
# orig_node = ox.get_nearest_node(G, (pickup_locas[0][0], pickup_locas[0][1]))
# dest_node = ox.get_nearest_node(G, (dropoffs_locas[0][0], dropoffs_locas[0][1]))

# print(orig_node)

# #find the route between these nodes then plot it
# route = nx.shortest_path(G, orig_node, dest_node, weight='length')
# fig, ax = ox.plot_graph_route(G, route, node_size=0)

# # how long is our route in meters?
# print(nx.shortest_path_length(G, orig_node, dest_node, weight='length'))