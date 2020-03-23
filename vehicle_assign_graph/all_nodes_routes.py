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
from shapely import wkt
from shapely.geometry import LineString, Point
import matplotlib.pyplot as plt

ox.config(use_cache=True, log_console=True)
ox.__version__

# the original graph
G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')
# ox.plot_graph(G)

node_1 = ox.get_nearest_node(G, (37.244, -80.433)) #(37.2238, -80.4402)276308465
node_2 = ox.get_nearest_node(G, (37.2301, -80.4403)) #(37.2109, -80.43)5288322283
node_3 = ox.get_nearest_node(G, (37.2461, -80.4312))
node_4 = ox.get_nearest_node(G, (37.229, -80.4408))

# transfer to gdfs
gdf_nodes, gdf_edges = ox.graph_to_gdfs(G)
# add three more nodes
p1 = Point(-80.43625,37.2398) #-80.43805,37.2197
# gdf_nodes.loc[3586727936] = ['circle', 3586727936, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727936] = ['NaN', 3586727936, 'NaN', p1.x, p1.y, p1]

p2 = Point(-80.4386,37.23515) #-80.4354,37.21655
# gdf_nodes.loc[3586727937] = ['circle', 3586727937, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727937] = ['NaN', 3586727937, 'NaN', p2.x, p2.y, p2]
# p3 = Point(-80.43245,37.2134)
# # gdf_nodes.loc[3586727938] = ['circle', 3586727938, 'a', p.x, p.y, p]
# gdf_nodes.loc[3586727938] = ['NaN', 3586727938, 'NaN', p3.x, p3.y, p3]
p3 = Point(-80.4346,37.24272) #-80.4354,37.21655
# gdf_nodes.loc[3586727938] = ['circle', 3586727938, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727938] = ['NaN', 3586727938, 'NaN', p3.x, p3.y, p3]

p4 = Point(-80.43705,37.2388) #-80.4354,37.21655
# gdf_nodes.loc[3586727939] = ['circle', 3586727939, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727939] = ['NaN', 3586727939, 'NaN', p4.x, p4.y, p4]

p5 = Point(-80.4388,37.23522) #-80.4354,37.21655
# gdf_nodes.loc[3586727939] = ['circle', 3586727939, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727940] = ['NaN', 3586727940, 'NaN', p5.x, p5.y, p5]

p6 = Point(-80.4405,37.231) #-80.4354,37.21655
# gdf_nodes.loc[3586727939] = ['circle', 3586727939, 'a', p.x, p.y, p]
gdf_nodes.loc[3586727941] = ['NaN', 3586727941, 'NaN', p6.x, p6.y, p6]


# add edges
d1 = {'geometry': LineString((p1, Point(G.node[node_1]['x'], G.node[node_1]['y']))), 
       'u': 3586727936, 'v': node_1, 'length': 570}
gdf_edges = gdf_edges.append(d1, ignore_index=True)

d2 = {'geometry': LineString((p2, p1)), 
       'u': 3586727937, 'v': 3586727936, 'length': 570}
gdf_edges = gdf_edges.append(d2, ignore_index=True)

# d3 = {'geometry': LineString((p2, p3)), 
#        'u': 3586727937, 'v': 3586727938, 'length': 430}
# gdf_edges = gdf_edges.append(d3, ignore_index=True)

d3 = {'geometry': LineString((Point(G.node[node_2]['x'], G.node[node_2]['y']), p2)),
	   'u': node_2, 'v': 3586727937, 'length': 478.76}
gdf_edges = gdf_edges.append(d3, ignore_index=True)

d4 = {'geometry': LineString((Point(G.node[node_3]['x'], G.node[node_3]['y']), p3)),
	   'u': node_3, 'v': 3586727938, 'length': 450}
gdf_edges = gdf_edges.append(d4, ignore_index=True)

d5 = {'geometry': LineString((p3, p4)), 
       'u': 3586727938, 'v': 3586727939, 'length': 450}
gdf_edges = gdf_edges.append(d5, ignore_index=True)

d6 = {'geometry': LineString((p4, p5)), 
       'u': 3586727939, 'v': 3586727940, 'length': 450}
gdf_edges = gdf_edges.append(d6, ignore_index=True)

d7 = {'geometry': LineString((p5, p6)), 
       'u': 3586727940, 'v': 3586727941, 'length': 450}
gdf_edges = gdf_edges.append(d7, ignore_index=True)

d8 = {'geometry': LineString((p6, Point(G.node[node_4]['x'], G.node[node_4]['y']))), 
       'u': 3586727941, 'v': node_4, 'length': 300.9}
gdf_edges = gdf_edges.append(d8, ignore_index=True)


G = ox.gdfs_to_graph(gdf_nodes, gdf_edges)
# ox.plot_graph(G)

## give some demand locations
D = 5
# r_node =[]
d_node =[0 for y in range(D)]
# r_node =[0 for x in range(R)]

d_node[0] = ox.get_nearest_node(G, (37.2525, -80.4199))
print(d_node[0])
# nodes_gps.append((37.2525, -80.4199))
# pos_node.append(d_node[0])
d_node[1] = ox.get_nearest_node(G, (37.229, -80.439))
# nodes_gps.append((37.229, -80.439))
# pos_node.append(d_node[1])
print(d_node[1])
d_node[2] = ox.get_nearest_node(G, (37.2243, -80.4091))
print(d_node[2])
d_node[3] = ox.get_nearest_node(G, (37.1978, -80.4038))
print(d_node[3])
d_node[4] = ox.get_nearest_node(G, (37.2165, -80.4239))
print(d_node[4])
# d_node[5] = ox.get_nearest_node(G, (37.2389, -80.4125))


avg_weighted_neighbor_degree = nx.average_neighbor_degree(G, weight='length')
# print(G.nodes)
# print(len(G.nodes))
# print(min(G.nodes))
# print(max(G.nodes))

allnodes = list(G.nodes)
# print(allnodes)
allnodes.remove(558699270)
allnodes.remove(651838448)
allnodes.remove(726672949)
allnodes.remove(654203558)

# # fig, ax = ox.plot_graph(G)

goalroutes = [[0 for x in range(len(allnodes))] for y in range(D)]
goalroutes_degree = [[0 for x in range(len(allnodes))] for y in range(D)]
goalroutes_length = [[0 for x in range(len(allnodes))] for y in range(D)]

for i in range(D):
	for j in range(len(allnodes)):
		goalroutes[i][j] = nx.shortest_path(G, d_node[i], allnodes[j], weight='length')
		goalroutes_degree[i][j] = \
		sum([avg_weighted_neighbor_degree[node] for node in goalroutes[i][j]])
		goalroutes_length[i][j] = \
		nx.shortest_path_length(G, d_node[i], allnodes[j], weight='length')/1000

edges_length_degree = []
for u, v, d in G.edges(data=True):
	degree = (avg_weighted_neighbor_degree[u] + avg_weighted_neighbor_degree[v])
	edges_length_degree.append([u, v, d['length']/1000, degree])

filename = 'allnodes_array.mat' 
scipy.io.savemat(filename, {'allnodes': allnodes})

filename = 'edges_length_degree.mat' 
scipy.io.savemat(filename, {'edges_length_degree': edges_length_degree})

filename = 'goalroutes_cell.mat' 
scipy.io.savemat(filename, {'goalroutes': goalroutes})

filename = 'goalroutes_length_array.mat' 
scipy.io.savemat(filename, {'goalroutes_length': goalroutes_length})

filename = 'goalroutes_degree_array.mat' 
scipy.io.savemat(filename, {'goalroutes_degree': goalroutes_degree})