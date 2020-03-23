import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
import csv, sys
import numpy
import numpy as np
from shapely import wkt
from shapely.geometry import LineString
import pandas as pd

def redistribute_vertices(geom, distance):
    if geom.geom_type == 'LineString':
        num_vert = int(round(geom.length / distance))
        if num_vert == 0:
            num_vert = 1
        return LineString(
            [geom.interpolate(float(n) / num_vert, normalized=True)
             for n in range(num_vert + 1)])
    elif geom.geom_type == 'MultiLineString':
        parts = [redistribute_vertices(part, distance)
                 for part in geom]
        return type(geom)([p for p in parts if not p.is_empty])
    else:
        raise ValueError('unhandled geometry %s', (geom.geom_type,))

ox.config(use_cache=True, log_console=True)
ox.__version__

G = ox.graph_from_place('Blacksburg, Virginia, USA', network_type='drive')
nodes, edges = ox.graph_to_gdfs(G, nodes=True, edges=True, node_geometry=True, fill_edge_geometry=True)

node_1 = ox.get_nearest_node(G, (37.2238, -80.4402)); #276308465
node_2 = ox.get_nearest_node(G, (37.2109, -80.43)); #5288322283

#route = nx.shortest_path(G, node_1, node_2, weight='length')
#route_length = nx.shortest_path_length(G, node_1, node_2, weight='length')
#print(route_length)
#ox.plot_graph_route(G, route, node_size=0)

u = list(edges.u)
v = list(edges.v)

#find index of node_1
node_1_inx = [] 
for i in range(0, len(u)) : 
    if u[i] == node_1 : 
        node_1_inx.append(i) 

#find index of node_2
node_2_inx = [] 
for i in range(0, len(v)) : 
    if v[i] == node_2 : 
        node_2_inx.append(i) 

#find the row index of node_1 & node 2
inx = list(set(node_1_inx) & set(node_2_inx))

edge_string = edges.geometry[inx[0]]
print(edge_string)

# edge_sep = redistribute_vertices(edge_string, 0.004)
# print(edge_sep)

#transform edges into evenly spaced points
edges['points'] = edges.apply(lambda edge_string: redistribute_vertices(edge_string.geometry, 0.004), axis=1)
print(edges['points'])

#develop edges data for each created points
extended = edges['points'].apply([pd.Series]).stack().reset_index(level=1, drop=True).join(edges).reset_index()

graph = ox.gdfs_to_graph(nodes, edges)

ox.plot_graph(graph) 