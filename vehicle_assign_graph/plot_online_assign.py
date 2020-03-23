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
import argparse
from shapely import wkt
from shapely.geometry import LineString, Point
import matplotlib.pyplot as plt

ox.config(use_cache=True, log_console=True)
ox.__version__

G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')

node_1 = ox.get_nearest_node(G, (37.244, -80.433)) #(37.2238, -80.4402)276308465
node_2 = ox.get_nearest_node(G, (37.2301, -80.4403)) #(37.2109, -80.43)5288322283
node_3 = ox.get_nearest_node(G, (37.2461, -80.4312))
node_4 = ox.get_nearest_node(G, (37.229, -80.4408))
 # ox.plot_graph(G)

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

#### inputs to the script
parser = argparse.ArgumentParser()
parser.add_argument('-r1','--route1', type=str, required=True)
parser.add_argument('-r2','--route2', type=str, required=True)
parser.add_argument('-r3','--route3', type=str, required=True)
# parser.add_argument('-r4','--route4', type=str, required=True)
# parser.add_argument('-r5','--route5', type=str, required=True)
# parser.add_argument('-r6','--route6', type=str, required=True)
# parser.add_argument('-r7','--route7', type=str, required=True)
# parser.add_argument('-r8','--route8', type=str, required=True)
# parser.add_argument('-r9','--route9', type=str, required=True)
# parser.add_argument('-r10','--route10', type=str, required=True)
# parser.add_argument('-r11','--route11', type=str, required=True)
# parser.add_argument('-r12','--route12', type=str, required=True)
args = parser.parse_args()

routes=[]
route1 = np.asarray(args.route1.split(','),dtype=np.int)
routes.append(route1)
route2 = np.asarray(args.route2.split(','),dtype=np.int)
routes.append(route2)
route3 = np.asarray(args.route3.split(','),dtype=np.int)
routes.append(route3)
# route4 = np.asarray(args.route4.split(','),dtype=np.int)
# routes.append(route4)
# route5 = np.asarray(args.route5.split(','),dtype=np.int)
# routes.append(route5)
# route6 = np.asarray(args.route6.split(','),dtype=np.int)
# routes.append(route6)
# route7 = np.asarray(args.route7.split(','),dtype=np.int)
# routes.append(route7)
# route8 = np.asarray(args.route8.split(','),dtype=np.int)
# routes.append(route8)
# route9 = np.asarray(args.route9.split(','),dtype=np.int)
# routes.append(route9)
# route10 = np.asarray(args.route10.split(','),dtype=np.int)
# routes.append(route10)
# route11 = np.asarray(args.route11.split(','),dtype=np.int)
# routes.append(route11)
# route12 = np.asarray(args.route12.split(','),dtype=np.int)
# routes.append(route12)

ox.plot_graph_routes(G, routes, node_size=0)