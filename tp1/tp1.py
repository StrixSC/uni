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
	

	#[ VertexObject (Class:Vertex), Visited (Type:Boolean), shortest_distance (type:int), previous_node (type:string)  ]
	# computational_matrix_data is a 4x21 matrix, and it contains all the data necessary for computation of the algorithm.

	computational_matrix_data = [[graph.list_vertex[j], False, 1000000, 'unknown'] for j in range(21)]

	# Index guide for the matrix list_nodes:
	vertex_index 			= 0
	visited_index 			= 1
	shortest_distance_index = 2
	previous_node_index 	= 3


	# Doesn't affect the inner logic, but beautifies the prints of the matrix. Which makes it more understandable.
	computational_matrix_data = np.array(computational_matrix_data)

	# The shortest distance for the source node must be 0. Since, it's already there!
	computational_matrix_data[int(departure_node.id)][shortest_distance_index]  = 0
	computational_matrix_data[int(departure_node.id)][previous_node_index] 		= 'none'


	#print("printing computational_matrix_data matrix: \n ", computational_matrix_data , "\n")
	shortest_dist_path = 1000000
	current_vertex 	   = departure_node


	for k in range(7):
		shortest_dist_path = 1000000
		for node in computational_matrix_data:
			if (node[shortest_distance_index] < shortest_dist_path) and (node[visited_index] == False):
				shortest_dist_path  = node[shortest_distance_index]
				path_vertex	    = node[vertex_index]
				node[visited_index] = True
		
		print("\n shortest_dist_path chosen: ", shortest_dist_path)
		print("Visiting the vertex: ", path_vertex.id)

		for neighbor in path_vertex.get_neighbors_distances():
			# neighbor[0] : returns an object Vertex. Returns a neighbor our current vertex 
			# neighbor[1] : returns the distance of the arc between our current vertex and it's neighbor
			neighbor_distance_from_source = shortest_dist_path + neighbor[1]
			current_distance_neighbor_source = computational_matrix_data[int(neighbor[0].id)][shortest_distance_index]
			
			# If the new distance calculated with our path is less than it's know distance, update the distance.
			if(neighbor_distance_from_source < current_distance_neighbor_source) and (computational_matrix_data[int(neighbor[0].id)][visited_index] == False):
				computational_matrix_data[int(neighbor[0].id)][shortest_distance_index] = neighbor_distance_from_source
				computational_matrix_data[int(neighbor[0].id)][previous_node_index]		= str(path_vertex.id)

		



		print("printing computational_matrix_data matrix: ", k , "\n", computational_matrix_data , "\n")





def main():
	list_vertices, list_arcs = read_file()

	graph = Graph(list_vertices, list_arcs)
	#graph.printGraph()

	list_mat = [[list_vertices[j], False, 1000000, 'unknown'] for j in range(21)]
	list_mat = np.array(list_mat)
	



	#dijkstra_algorithm(graph, graph.list_vertex[0])
	dijkstra(graph, graph.list_vertex[0])

	

main()





















