import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
import csv, sys
import numpy
import numpy as np
from shapely import wkt
from shapely.geometry import LineString, Point
import pandas as pd
import matplotlib.pyplot as plt

ox.config(use_cache=True, log_console=True)
ox.__version__

G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')

node_1 = ox.get_nearest_node(G, (37.244, -80.433)) #(37.2238, -80.4402)276308465
node_2 = ox.get_nearest_node(G, (37.2301, -80.4403)) #(37.2109, -80.43)5288322283

# print(node_3)
# print(node_4)
# ox.plot_graph(G)

node_3 = ox.get_nearest_node(G, (37.2461, -80.4312))
node_4 = ox.get_nearest_node(G, (37.229, -80.4408))
# route = nx.shortest_path(G, node_3, node_4, weight='length')
# print(nx.shortest_path_length(G, node_3, node_4, weight='length'))
# ox.plot_graph_route(G, route, node_size=0)


gdf_nodes, gdf_edges = ox.graph_to_gdfs(G)

# if 3586727938 in gdf_nodes['osmid']:
# 	print('NO')

#GPS of intermediate node, node_3: (37.2153, -80.4344)
# adding a node
# I find adding a record with .loc easiser and maintains the index of the dataframe
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

# if 3586727938 in gdf_nodes['osmid']:
# 	print('OK')

# print(gdf_nodes)

# creating the edge in the form of a dict.  The edge will be between p that I created above and your node_1
# change the length to the desired value
# here I'm doing an append because the index doesn't matter for the edge frame
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

# and convert back to a networkx graph for routing
graph = ox.gdfs_to_graph(gdf_nodes, gdf_edges)
ox.plot_graph(graph)

# node_p1 = ox.get_nearest_node(graph, (37.2199, -80.4382))
# node_p2 = ox.get_nearest_node(graph, (37.21655, -80.4354))
# node_p3 = ox.get_nearest_node(graph, (37.213805, -80.4325))
# node_3 = 1468455070

# route1 = nx.shortest_path(graph, node_2, node_1, weight='length')
# ox.plot_graph_route(graph, route1, node_size=0)
route2 = nx.shortest_path(graph, node_3, node_4, weight='length')
ox.plot_graph_route(graph, route2, node_size=0)

# ec = ['#191970' if (u==node_1 and v==node_2) or (u==node_1 and v==node_p1) 
# 					or (u==node_p1 and v==node_p2) or (u==node_p2 and v==node_p3)
# 					or (u==node_p3 and v==node_2)
# 				 else 'grey' for u, v, k in G.edges(keys=True)]
# fig, ax = ox.plot_graph(graph, edge_color=ec)

print(nx.shortest_path_length(graph, node_3, node_4, weight='length'))
# print(nx.shortest_path_length(graph, node_p1, node_p2, weight='length'))
# print(nx.shortest_path_length(graph, node_p2, node_p3, weight='length'))
# print(nx.shortest_path_length(graph, node_p3, node_2, weight='length'))
# print(nx.shortest_path_length(graph, node_1, node_2, weight='length'))