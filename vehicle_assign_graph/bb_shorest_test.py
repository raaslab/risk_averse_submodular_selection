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

r_node = ox.get_nearest_node(G, (37.229, -80.4275))

d_node = ox.get_nearest_node(G, (37.2525, -80.4199))

route = nx.shortest_path(G, r_node, d_node, weight='length')
fig = ox.plot_graph_route(G, route, node_size=0)