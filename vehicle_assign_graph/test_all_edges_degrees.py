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

ox.config(use_cache=True, log_console=True)
ox.__version__

G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')
avg_weighted_neighbor_degree = nx.average_neighbor_degree(G, weight='length')

edges_length_degree = []
for u, v, d in G.edges(data=True):
	degree = (avg_weighted_neighbor_degree[u] + avg_weighted_neighbor_degree[v])
	edges_length_degree.append([u, v, d['length'], degree])


# demand_nodes
D = 2
d_node =[0 for y in range(D)]
d_node[0] = ox.get_nearest_node(G, (37.2525, -80.4199))
d_node[1] = ox.get_nearest_node(G, (37.229, -80.439))

route = nx.shortest_path(G, d_node[0], d_node[1], weight='length')

ox.plot_graph_routes(G, route, node_size=0)


# # print(len(G.nodes))
# # print(min(G.nodes))
# # print(max(G.nodes))

# allnodes = list(G.nodes)
# # print(allnodes)
# allnodes.remove(558699270)
# allnodes.remove(651838448)
# allnodes.remove(726672949)
# allnodes.remove(654203558)
# allnodes.remove(726781952)
# allnodes.remove(5959688198)
# allnodes.remove(3586727943)

# allroutes = [[0 for x in range(len(allnodes))] for y in range(len(allnodes))]
# allroutes_degree = [[0 for x in range(len(allnodes))] for y in range(len(allnodes))]
# allroutes_length = [[0 for x in range(len(allnodes))] for y in range(len(allnodes))]

# for i in range(len(allnodes)):
# 	for j in range(len(allnodes)):
# 		allroutes[i][j] = nx.shortest_path(G, allnodes[i], allnodes[j], weight='length')
# 		allroutes_degree[i][j] = \
# 		sum([avg_weighted_neighbor_degree[node] for node in allroutes[i][j]])
# 		allroutes_length[i][j] = \
# 		nx.shortest_path_length(G, allnodes[i], allnodes[j], weight='length')/1000
