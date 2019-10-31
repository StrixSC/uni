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
    		

#for arc in list_arcs:
#	print(arc.firstVertex.id, "  ", arc.secondVertex.id)

commandeObjectsA = 0
commandeObjectsB = 0
commandeObjectsC = 0

def afficherCommande():
	print("Voici votre commande: ")
	print("                 	 " , int(commandeObjectsA), " objets de type A")
	print("                 	 " , int(commandeObjectsB), " objets de type A")
	print("                 	 " , int(commandeObjectsC), " objets de type A")
	print("Total: " , int(commandeObjectsA + commandeObjectsB + commandeObjectsC))

def prendreCommande():

	commandeObjectsA = int(input("Entrez la quantite d'object de type A: "))
	commandeObjectsB = int(input("Entrez la quantite d'object de type B: "))
	commandeObjectsC = int(input("Entrez la quantite d'object de type C: "))

	while(True):
		#print("Vous avez choisi: ")
		#print("                  " + str(objectsA), " objets de type A")
		#print("                  " + str(objectsB), " objets de type A")
		#print("                  " + str(objectsC), " objets de type A")
		afficherCommande()

		answer = int(input("Voulez-vous faire une correction de commande? Tappez 1 pour oui, 0 pour non. Votre reponse:"))

		if(answer == 1):
			objectsA = int(input("Entrez la quantite d'object de type A: "))
			objectsB = int(input("Entrez la quantite d'object de type B: "))
			objectsC = int(input("Entrez la quantite d'object de type C: "))
		else:
			break



prendreCommande()


	































