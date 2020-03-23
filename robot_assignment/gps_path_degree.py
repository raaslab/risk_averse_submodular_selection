import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
import csv, sys
import random
import numpy
import numpy as np
import scipy.io

R = 3
D = 2

ox.config(use_cache=True, log_console=True)
ox.__version__


# get a graph for some city
# G = ox.graph_from_place('Los Angeles, California, USA', network_type='drive')
G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')
# fig, ax = ox.plot_graph(G)

# edge closeness centrality: convert graph to line graph so edges become nodes and vice versa
# edge_centrality = nx.closeness_centrality(nx.line_graph(G))

# average weighted degree of the neighborhood of each node, and average for the graph
avg_weighted_neighbor_degree = nx.average_neighbor_degree(G, weight='length')

# define the gps locations of R vehicles and N demand locations
nodes_gps = []

# define the nearest network node to each gps
pos_node = [0 for x in range(R+D)]

r_node =[]
d_node =[]

i = 0
while i < R + D:
	pos_gps = (37+ random.randint(1850,2764)/10000, -80-random.randint(3846,4746)/10000)
	pos_node_temp = ox.get_nearest_node(G, pos_gps)
	if pos_node_temp not in pos_node:
		pos_node[i] = pos_node_temp
		nodes_gps.append(pos_gps)
		i = i + 1

r_node = pos_node[0:R]
d_node = pos_node[R:R+D]
print(r_node)
print(d_node)
# # get the nearest network node to each point of the two or more lat_long
# orig_node = ox.get_nearest_node(G, (37.2151, -80.4393))
# dest_node = ox.get_nearest_node(G, (37.2438, -80.4181))
# # orig_node = ox.get_nearest_node(G, (pickup_locas[0][0], pickup_locas[0][1]))
# # dest_node = ox.get_nearest_node(G, (dropoffs_locas[0][0], dropoffs_locas[0][1]))

# print(orig_node)
# print(dest_node)

routes_length = [[0 for x in range(R)] for y in range(D)]
routes_degree = [[0 for x in range(R)] for y in range(D)]

i = 0;
j = 0; 

routes = []

for i in range(R):
	for j in range(D):
	#find the route between these nodes then plot it
		route = nx.shortest_path(G, r_node[i], d_node[j], weight='length')
		# route_degree
		routes_degree[j][i] = sum([avg_weighted_neighbor_degree[node] for node in route])
		routes.append(route)
		# print(route)
		# how long is our route in kiometers?
		routes_length[j][i] = nx.shortest_path_length(G, r_node[i], d_node[j], weight='length')/1000
		print(routes_length)
		print(routes_degree)

filename = 'nodes_gps_cell.mat' 
scipy.io.savemat(filename, {'nodes_gps': nodes_gps})

filename = 'routes_length_cell.mat' 
scipy.io.savemat(filename, {'routes_length': routes_length})

filename = 'routes_degree_cell.mat' 
scipy.io.savemat(filename, {'routes_degree': routes_degree})

ox.plot_graph_routes(G, routes, node_size=0

# # how long is our route in meters?
# print(nx.shortest_path_length(G, orig_node, dest_node, weight='length'))