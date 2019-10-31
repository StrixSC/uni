#############################################################################
##### 	STRUCTURES DISCRETES - LOG2810									#####
#####	Travail réalisé par Ragib Ahashan, Pritam Patel, Nawras Kader	#####
#####	Travail Pratique 1												#####
#####	Version de Python utilisé: 3.7.3								#####
#############################################################################


# Le format représenté dans le fichier externe entrepot.txt est le format d'un CSV file.

import csv
from Arc import Arc
from Vertex import Vertex
from commande import Commande

n_Attributes_Vertex = 4
n_Attributes_Arc 	= 3

list_vertices 	= []
list_arcs 		= []

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
    		v.printVertex()
    		
    	elif (len(line) == n_Attributes_Arc):
    		first_vertex_id  	= int(line[0])
    		second_vertex_id 	= int(line[1])
    		distance_arc  		= int(line[2])

    		first_vertex 	= list_vertices[first_vertex_id]
    		second_vertex 	= list_vertices[second_vertex_id]
    		
    		arc = Arc(first_vertex, second_vertex, distance_arc)
    		list_arcs.append(arc)
    		


	































