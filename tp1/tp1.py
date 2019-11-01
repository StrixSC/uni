#####################################################################################
##### 	STRUCTURES DISCRETES - LOG2810									        #####
#####	Travail réalisé par Ragib Ahashan, Pritam Patel, Nawras Mohammmed Amin	#####
#####	Travail Pratique 1												        #####
#####	Version de Python utilisé: 3.7.3								        #####
#####################################################################################


# Le format représenté dans le fichier externe entrepot.txt est le format d'un CSV file.

import csv
from Arc import Arc
from Vertex import Vertex
from commande import Commande
from Graph import Graph
import numpy as np


def read_file(file_name = 'entrepot.txt'):
	
	list_vertices 	= []
	list_arcs 		= []
	n_Attributes_Vertex = 4
	n_Attributes_Arc 	= 3

	with open('entrepot.txt') as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		line_count = 0
		for line in csv_reader:
			if(len(line) == n_Attributes_Vertex):
				vertex_id 		 = line[0]
				vertex_objects_A = line[1]
				vertex_objects_B = line[2]
				vertex_objects_C = line[3]
				v = Vertex(vertex_id,vertex_objects_A,vertex_objects_B,vertex_objects_C)
				list_vertices.append(v)
				
			elif (len(line) == n_Attributes_Arc):
				first_vertex_id  	= int(line[0])
				second_vertex_id 	= int(line[1])
				distance_arc  		= int(line[2])

				first_vertex 	= list_vertices[first_vertex_id]
				second_vertex 	= list_vertices[second_vertex_id]
				
				arc = Arc(first_vertex, second_vertex, distance_arc)
				list_arcs.append(arc)
	
	return list_vertices, list_arcs



def find_shortest_distance_unvisited(visited_vertex, shortest_distances_vertices):
	pass





def dijkstra_algorithm(graph, starting_node):
		amount_of_nodes = len(graph.list_vertex)
		shortest_distances_from_source_node = ['infinity' for i in range(21)]
		shortest_distances_from_source_node[int(starting_node.id)] = 0

		shortest_path_from_source_node = [ [int(starting_node.id)] for i in range(21)]
		#print(shortest_path_from_source_node)
		iteration = 0
		
		visited_vertex	 = ['unvisited' for i in range(21)]
		visited_vertex[int(starting_node.id)] = 'visited'

		current_vertex = starting_node

		string = ['1', "The shortest distance of this path is: " + str(1)]
		string[0] += " -> B"

		neighbors = current_vertex.get_neighbors_distances()

		for neighbor in neighbors:
			pass






		print(neighbors)
			




def dijkstra(graph, departure_node):
	list_nodes = []

	for node in graph.list_vertex[:]:
		list_nodes.append([node , 1000000])


	list_nodes[int(departure_node.id)][1] = 0


	list_nodes = np.array(list_nodes)
	#print(list_nodes)

	shortest_distances = [ 1000000 for i in range(len(graph.list_vertex))]
	shortest_distances[int(departure_node.id)] = 0
	previous_nodes 	   = [ 'unknown' for i in range(len(graph.list_vertex))]

	current_shortest = 1000000
	
	visiting_node = 0

	for i in range(25):

		visiting_node = departure_node

		for node in list_nodes:
			if node[1] < current_shortest and node[0] != 'visited':
				visiting_node = node[0]
				print(visiting_node.id)
				list_nodes[0][0] = 'visited'


		print("asdad: ", visiting_node.id)


		for neighbor in visiting_node.get_neighbors_distances():
			total_distance = list_nodes[int(visiting_node.id)][1] + neighbor[1]
			if( total_distance < list_nodes[int(neighbor[0].id)][1]):
				list_nodes[int(neighbor[0].id)][1] = total_distance



	print(list_nodes)






def main():
	list_vertices, list_arcs = read_file()

	graph = Graph(list_vertices, list_arcs)
	#graph.printGraph()


	#dijkstra_algorithm(graph, graph.list_vertex[0])
	dijkstra(graph, graph.list_vertex[0])

	

main()





















