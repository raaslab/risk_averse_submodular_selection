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
# ox.plot_graph(G)


node_1 = ox.get_nearest_node(G, (37.2238, -80.4402)); #276308465
node_2 = ox.get_nearest_node(G, (37.2109, -80.43)); #5288322283

#GPS of an intermediate node, node_3: (37.2153, -80.4344)

route = nx.shortest_path(G, node_1, node_2, weight='length')
ox.plot_graph_route(G, route, node_size=0)


gdf_nodes, gdf_edges = ox.graph_to_gdfs(G)
# gdf_nodes['geometry'] = gdf_nodes.apply(lambda row: Point(row['x'], row['y']), axis=1)
# gdf_edges['geometry'] = gdf_edges.apply(lambda x: redistribute_vertices(x.geometry, 0.04), axis=1)

# gdf_nodes.append({'highway':'circle','osmid':'3586727936','ref':'a','x':'-80.4402','y':'37.2238','geometry':'Point(-80.4402,37.2238)'}, ignore_index=True)
# graph = ox.gdfs_to_graph(gdf_nodes, gdf_edges)