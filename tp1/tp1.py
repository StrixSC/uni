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

	source = list_vertices[10]
	destinaion = list_vertices[10]



	#path = PathFinder(graph, list_vertices[0])
	#fast = path.compute_fastest_paths_dijstra(graph, list_vertices[0])
	#graph.printGraph()

	
	



	fastest_paths = compute_fastest_paths_dijstra(graph, graph.list_vertex[10])
	

	droneX = Drone('X', mass = 5)
	#droneX.printDrone()

	commande = Commande(1,1,1)

	flight = FlightManager(commande, droneX, graph)
	#flight.flight_mission()


	x = flight.plusCourtChemin(source, destinaion)

	lol = [0 for i in range(len(x))]

	current_min = 1000
	new_mat = []
	visited = []
	node = 0

	copy = x[:]
	index = 0
	order_indexes = []

	for k in range(len(copy)):
		current_min = 10000
		for i in range(len(copy)):
		
			#if x[i][1] == 99.9129:
			#	print("skip")
			#print(x[i][1], '<', current_min, "   ", x[i][1] < current_min, "  ", lol[i])
			if (x[i][1] < current_min) and (lol[i] == 0):
				current_min = x[i][1]
				index = i
		lol[index] = 1
		order_indexes.append(index)
			

		print(current_min)
	print(copy)
	print(order_indexes)

	for i in order_indexes:
		new_mat.append(copy[i])
	new_mat = np.array(new_mat)

	for n in new_mat:
		print(n[0].id, n[1], n[2])

	#print(new_mat)


	print("===============")
	y = flight.sort_accending_distances(x)
	print(y)

main()





















