import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
import csv, sys
import random
from random import randint
import numpy
import numpy as np
import scipy.io

D = 2
R = 3

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
pos_node = []

# r_node =[]
d_node =[0 for x in range(D)]
# r_node =[0 for x in range(R)]

d_node[0] = ox.get_nearest_node(G, (37.2525, -80.4199))
nodes_gps.append((37.2525, -80.4199))
pos_node.append(d_node[0])

d_node[1] = ox.get_nearest_node(G, (37.229, -80.439))
nodes_gps.append((37.229, -80.439))
pos_node.append(d_node[1])

# d_node[2] = ox.get_nearest_node(G, (37.2268, -80.4121))
# nodes_gps.append((37.2268, -80.4121))
# pos_node.append(d_node[2])

# d_node[3] = ox.get_nearest_node(G, (37.2137, -80.4002))
# nodes_gps.append((37.2137, -80.4002))
# pos_node.append(d_node[3])

i = 0
while i < R:
	pos_gps = (37 + randint(1935,2474)/10000, -80-randint(3956,4411)/10000)
	pos_node_temp = ox.get_nearest_node(G, pos_gps)
	if pos_node_temp not in pos_node:
		pos_node.append(pos_node_temp)
		nodes_gps.append(pos_gps)
		i = i + 1

r_node = pos_node[D:R+D]
# print(d_node)
# print(r_node)

# r_node[0] = ox.get_nearest_node(G, (37.2197, -80.4261))
# nodes_gps.append((37.2335, -80.4015))

# r_node[1] = ox.get_nearest_node(G, (37.2241, -80.4015))
# nodes_gps.append((37.2207, -80.4057))

# r_node[2] = ox.get_nearest_node(G, (37.2002, -80.3988))
# nodes_gps.append((37.2043, -80.3925))

# r_node[0] = ox.get_nearest_node(G, (37.2317, -80.4213))
# nodes_gps.append((37.2182, -80.4408))

# r_node[1] = ox.get_nearest_node(G, (37.2407, -80.4272))
# nodes_gps.append((37.2431, -80.4288))

# r_node[2] = ox.get_nearest_node(G, (37.2535, -80.4103))
# nodes_gps.append((37.2557, -80.4106))

# print(d_node)
# print(r_node)

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

for i in range(D):
	for j in range(R):
	#find the route between these nodes then plot it
		route = nx.shortest_path(G, d_node[i], r_node[j], weight='length')
		# route_degree
		routes_degree[i][j] = sum([avg_weighted_neighbor_degree[node] for node in route])
		routes.append(route)
		# print(route)
		# how long is our route in kiometers?
		routes_length[i][j] = nx.shortest_path_length(G, d_node[i], r_node[j], weight='length')/1000

print(routes_length)
print(routes_degree)
filename = 'gps_cell.mat' 
scipy.io.savemat(filename, {'nodes_gps': nodes_gps})

filename = 'routes_cell.mat' 
scipy.io.savemat(filename, {'routes': routes})

filename = 'routes_length_cell.mat' 
scipy.io.savemat(filename, {'routes_length': routes_length})

filename = 'routes_degree_cell.mat' 
scipy.io.savemat(filename, {'routes_degree': routes_degree})
 
ox.plot_graph_routes(G, routes, node_size=0)

# # how long is our route in meters?
# print(nx.shortest_path_length(G, orig_node, dest_node, weight='length'))