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
from commande import CommandManager
from Graph import Graph
#from Dijkstra import printPaths, compute_fastest_paths_dijstra
from drone import Drone
from flightManager import FlightManager
import numpy as np


def read_file(file_name = 'entrepot.txt'):
	
	list_vertices 	= []
	list_arcs 		= []
	n_Attributes_Vertex = 4
	n_Attributes_Arc 	= 3

	try:
		with open(file_name) as csv_file:
			csv_reader = csv.reader(csv_file, delimiter=',')
			#line_count = 0
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
	except Exception as e:
		print("Erreur de lecture du fichier! Le fichier '" + file_name + "' ne peut pas être lu.")
		return False, False


	return list_vertices, list_arcs



def interface_graphique_C4():
	# Creer le graphe: 
	# Afficher le graphe:
	# Prendre une commande:
	# Afficher la commande:
	# Trouver le plus court chemin:
	# Quitter
	reponses_possibles = ['1','2','3','4','5','6']
	reponse_acceptable = False

	while(True):
		print("\n		MENU PRINCIPAL		")
		print("\nPour creer un nouveau graphe:       Tappez [1]")
		print("Pour afficher le graphe:            Tappez [2]")
		print("Pour faire une commande:            Tappez [3]")
		print("Pour afficher la derniere commande: Tappez [4]")
		print("Pour afficher le plus court chemin: Tappez [5]")
		print("Pour quitter le programme:          Tappez [6]\n")

		reponse_output = str(input("Entrez votre choix: "))
		if reponse_output in reponses_possibles:
			return int(reponse_output)
		print("\n", str(reponse_output), " n'est pas une option. Recommencez. \n")




def main():

	CHOIX_CREER_GRAPHE 		= 1
	CHOIX_AFFICHER_GRAPHE   = 2
	CHOIX_PRENDRE_COMMANDE  = 3
	CHOIX_AFFICHER_COMMANDE = 4
	CHOIX_PLUS_COURT_CHEMIN = 5
	CHOIX_QUITTER_PROGRAMME = 6

	graph  = 'invalid'
	flight = 'invalid'

	while(True):

		user_action = interface_graphique_C4()

		if user_action == CHOIX_CREER_GRAPHE:
			print("\nVous avez choisi de créer un nouvel graphe.")
			file_name = str(input("Entrez le nom du fichier .txt à lire pour créer le graphe: "))
			if(file_name.find(".txt") == -1):
				file_name += ".txt"
			list_vertices, list_arcs = read_file(file_name)
			if(list_vertices == False and list_arcs == False):
				reponse = str(input("Vouliez vous lire le fichier 'entrepot.txt'? Tappez [1] pour 'OUI' ou [0] pour 'NON': "))
				if(reponse == '1'):
					list_vertices, list_arcs = read_file('entrepot.txt')
					graph = Graph(list_vertices, list_arcs)
					flight_manager   = FlightManager(graph)
					totalA, totalB, totalC = graph.get_number_objects()
					commande = CommandManager(totalA, totalB, totalC)
				else:
					print("\n RECOMMENCEZ AVEC UN FICHIER .txt LISIBLE. \n")
					print("*** Le fichier 'entrepot.txt' est le nom du fichier qui contient les informations sur le graphe de ce TP.")
		
		
		if user_action == CHOIX_AFFICHER_GRAPHE:
			print("\n Vous avez choisi d'afficher le graphe.\n")
			if(graph == 'invalid'):
				print("Le graphe n'existe pas. Créez le graphe pour l'afficher!\n")
			else:
				graph.printGraph()

				#Initialiser CommandManager avec les objets disponibles dans le graphe
				

		
		if user_action == CHOIX_PRENDRE_COMMANDE:
			print("\n Vous avez choisi de faire une commande.\n")
			commande.prendreCommande()
			flight_manager.commande = commande
		
		if user_action == 4:
			print("\n Vous avez choisi de faire une commande.\n")
			flight_manager.commande.afficherCommande()
		
		
		if user_action == CHOIX_PLUS_COURT_CHEMIN:
			best_drone_choice = flight_manager.plusCourtChemin()
			flight_manager.print_optimal(best_drone_choice)
		
		
		
		if user_action == CHOIX_QUITTER_PROGRAMME:
			print("Exiting program.")
			break
	

main()





















