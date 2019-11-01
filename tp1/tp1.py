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




def printPaths(computational_matrix_data, node_id, source_id ):
	
	vertex_index 			= 0
	visited_index 			= 1
	shortest_distance_index = 2
	previous_node_index 	= 3
	if computational_matrix_data[node_id][previous_node_index] == str(source_id):
		return  str(source_id) + '->' + str(node_id)
	else:
		prev_node = computational_matrix_data[node_id][previous_node_index]	
		return printPaths(computational_matrix_data, int(prev_node), source_id) + "->" + str(node_id)


def compute_fastest_paths_dijstra(graph, departure_node):
	

	#[ VertexObject (Class:Vertex), Visited (Type:Boolean), shortest_distance (type:int), previous_node (type:string)  ]
	# computational_matrix_data is a 4x21 matrix, and it contains all the data necessary for computation of the algorithm.

	computational_matrix_data = [[graph.list_vertex[j], False, 1000000, ''] for j in range(len(graph.list_vertex))]

	# Index guide for the matrix list_nodes:
	vertex_index 			= 0
	visited_index 			= 1
	shortest_distance_index = 2
	previous_node_index 	= 3


	# Doesn't affect the inner logic, but beautifies the prints of the matrix. Which makes it more understandable.
	computational_matrix_data = np.array(computational_matrix_data)

	# The shortest distance for the source node must be 0. Since, it's already there!
	computational_matrix_data[int(departure_node.id)][shortest_distance_index]  = 0
	computational_matrix_data[int(departure_node.id)][previous_node_index] 		= '0'


	shortest_dist_path = 1000000
	current_vertex 	   = departure_node


	for k in range(len(computational_matrix_data)):
		shortest_dist_path = 1000000
		for node in computational_matrix_data:
			if (node[shortest_distance_index] < shortest_dist_path) and (node[visited_index] == False):
				shortest_dist_path  = node[shortest_distance_index]
				path_vertex	    = node[vertex_index]
		
		computational_matrix_data[int(path_vertex.id)][visited_index] = True
		
	#	print("\n shortest_dist_path chosen: ", shortest_dist_path, " ------  Visiting the vertex: ", path_vertex.id)

		for neighbor in path_vertex.get_neighbors_distances():
			# neighbor[0] : returns an object Vertex. Returns a neighbor our current vertex. See Vertex class in Vertex.py for more info.
			# neighbor[1] : returns the distance of the arc between our current vertex and it's neighbor. See Vertex class in Vertex.py for more info.
			neighbor_distance_from_source = shortest_dist_path + neighbor[1]
			current_distance_neighbor_source = computational_matrix_data[int(neighbor[0].id)][shortest_distance_index]
			
			# If the new distance calculated with our path is less than it's know distance, update the distance.
			if(neighbor_distance_from_source < current_distance_neighbor_source) and (computational_matrix_data[int(neighbor[0].id)][visited_index] == False):
				computational_matrix_data[int(neighbor[0].id)][shortest_distance_index] = neighbor_distance_from_source
				computational_matrix_data[int(neighbor[0].id)][previous_node_index]		= str(path_vertex.id)



	#	print("printing computational_matrix_data matrix: iteration ", k)
	#	for n in computational_matrix_data:
	#		print(n[0].id, n[1], n[2], n[3])
	#print("printing computational_matrix_data matrix: ", k , "\n", computational_matrix_data , "\n")

	# Reminder.
	# computational_matrix_data is a 4x21 matrix.
	# Each line contains:
	#[ VertexObject (Class:Vertex), Visited (Type:Boolean), shortest_distance (type:int), previous_node (type:string)  ]


	#fastest_routes_from_source = [[ computational_matrix_data[i][0].id , computational_matrix_data[i][2] , computational_matrix_data[i][3]] for i in range(len(graph.list_vertex))]
	
	nodes 				= np.array([ [computational_matrix_data[i][vertex_index]] for i in range(len(computational_matrix_data))])
	shortest_distances  = np.array([[computational_matrix_data[i][shortest_distance_index]] for i in range(len(computational_matrix_data))])
	fastest_paths       = np.array([[printPaths(computational_matrix_data, i, int(departure_node.id))] for i in range(len(computational_matrix_data))])
	


	return nodes, shortest_distances, fastest_paths










def main():
	list_vertices, list_arcs = read_file()

	graph = Graph(list_vertices, list_arcs)
	#graph.printGraph()

	
	



	nodes, shortest_distances, fastest_paths = compute_fastest_paths_dijstra(graph, graph.list_vertex[10])
	
	print(fastest_paths)


	

main()





















