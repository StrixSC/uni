########################################################################################################
############# 	LOG2810 - STRUCTURES DISCRETES								        		############
#############	Travail réalisé par Ragib Ahashan, Pritam Patel, Nawras Mohammmed Amin		############
#############	Travail Pratique 1															############
#############																				############
#############	Version de Python utilisé: 3.7.3								        	############
#############	La librairie NumPy de Python est *NECESSAIRE* pour exécuter ce programme! 	############
########################################################################################################


# Le format représenté dans le fichier externe entrepot.txt est le format d'un CSV file.
import csv
from Arc import Arc
from Vertex import Vertex
from commande import Commande
from Graph import Graph
from Dijkstra import printPaths, compute_fastest_paths_dijstra
from drone import Drone
from flightManager import FlightManager
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



def main():
	list_vertices, list_arcs = read_file()

	graph = Graph(list_vertices, list_arcs)

	id_source 		= 0
	id_destination  = 20

	source 		= list_vertices[id_source]
	destinaion  = list_vertices[id_destination]


	commande = Commande(1,2,3)
	droneX   = Drone('X', 3)
	flight   = FlightManager(commande, droneX, graph)

	fastest_paths = flight.plusCourtChemin(source, destinaion)


	print(fastest_paths)
	for node in fastest_paths:
		print(node[0].id, node[1], node[2])
	

	

main()





















