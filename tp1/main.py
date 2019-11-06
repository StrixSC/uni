########################################################################################################
############# 	LOG2810 - STRUCTURES DISCRETES								        		############
#############	Travail réalisé par Ragib Ahashan, Pritam Patel, Nawras Mohammmed Amin		############
#############	Travail Pratique 1															############
#############																				############
#############	Version de Python utilisé: 3.7.3								        	############
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
		print("Le ficher est lu!")
	except Exception as e:
		print("Erreur de lecture du fichier! Le fichier '" + file_name + "' ne peut pas être lu.")
		return False, False


	return list_vertices, list_arcs


#########################################################################################
#	menu_principal affiche le menu. Le menu est dynamiquement changé selon l'ordre 
#	des opérations fait par l'usager.
#	Il fait partie du composant 4 qui est à implémenter.
#	params afficher_graph (bool), afficher_commande (bool)
#########################################################################################
def menu_principal(afficher_graph,afficher_commande):
	# Creer le graphe: 
	# Afficher le graphe:
	# Prendre une commande:
	# Afficher la commande:
	# Trouver le plus court chemin:
	# Quitter

	# Si les valeurs à l'interieur de cet liste n'est pas un input de l'usager, on refuse la reponse.
	reponses_possibles = ['1','2','3','4','5','6']
	reponse_acceptable = False


	# On change le menu dépendement des actions des usagers.
	if afficher_graph == False:
		msg_interface_aff_graphe 	  = "Pour afficher le graphe:            Tappez [2]		[accès restreint]"
		msg_interface_commander       = "Pour faire une commande:            Tappez [3]		[accès restreint]"
	else:
		msg_interface_aff_graphe 	  = "Pour afficher le graphe:            Tappez [2]"
		msg_interface_commander       = "Pour faire une commande:            Tappez [3]"

	if afficher_commande == False:
		msg_interface_aff_commande 	  = "Pour afficher la derniere commande: Tappez [4]		[accès restreint]"
		msg_interface_chemins 		  = "Pour afficher le plus court chemin: Tappez [5]		[accès restreint]"
	else:
		msg_interface_aff_commande 	  = "Pour afficher la derniere commande: Tappez [4]"
		msg_interface_chemins 		  = "Pour afficher le plus court chemin: Tappez [5]"
	
	
	# Tant qu'on ne recoit pas une bonne reponse de l'usager, on lui demande la meme question.
	while(True):
		print("\n		MENU PRINCIPAL		")
		print("\nPour creer un nouveau graphe:       Tappez [1]")
		print(msg_interface_aff_graphe)
		print(msg_interface_commander)
		print(msg_interface_aff_commande)
		print(msg_interface_chemins)
		print("Pour quitter le programme:          Tappez [6]\n")

		reponse_output = str(input("Entrez votre choix: "))
		if reponse_output in reponses_possibles:
			return int(reponse_output)
		print("\n '", str(reponse_output), "' n'est pas une option. Recommencez. \n")





#########################################################################################
#	main(). C'est la classe main, qui execute notre programme. 
#	Il fait partie du composant 4 qui est à implémenter.
#	params aucun
#########################################################################################
def main():

	CHOIX_CREER_GRAPHE 		= 1
	CHOIX_AFFICHER_GRAPHE   = 2
	CHOIX_PRENDRE_COMMANDE  = 3
	CHOIX_AFFICHER_COMMANDE = 4
	CHOIX_PLUS_COURT_CHEMIN = 5
	CHOIX_QUITTER_PROGRAMME = 6

	graph_exist				   = False
	flight_module_permission   = False
	commande_existe            = False
	afficher_chemin_permission = False

	while(True):

		user_action = menu_principal(graph_exist,commande_existe)

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
					graph_exist = True
				else:
					print("\n RECOMMENCEZ AVEC UN FICHIER .txt LISIBLE. \n")
					print("*** Le fichier 'entrepot.txt' est le nom du fichier qui contient les informations sur le graphe de ce TP.")
			else:
				graph = Graph(list_vertices, list_arcs)
				flight_manager   = FlightManager(graph)
				totalA, totalB, totalC = graph.get_number_objects()
				commande = CommandManager(totalA, totalB, totalC)
				graph_exist = True
				print("\nLe graphe est crée. Vous pouvez maintenant accéder aux autres fonctionnalités du programme. \n")
			input("\nAppuyez sur 'Enter' pour retourner au menu.\n")
		
		if user_action == CHOIX_AFFICHER_GRAPHE:
			print("\n Vous avez choisi d'afficher le graphe.\n")
			if(graph_exist == False):
				print("Le graphe n'existe pas. Créez le graphe pour l'afficher!\n")
			else:
				graph.printGraph()
			input("\nAppuyez sur 'Enter' pour retourner au menu.\n")
				

		
		if user_action == CHOIX_PRENDRE_COMMANDE:
			print("\n Vous avez choisi de faire une commande.\n")
			if(graph_exist == False):
				print("Aucun graphe est choisi. Créez un graphe pour faire une commande.")
			else:
				commande.prendreCommande()
				flight_manager.commande = commande
				best_drone_choice = flight_manager.plusCourtChemin()
				commande_existe = True
				print("\n          Votre commande est enregistré.")
			input("\n          Appuyez sur 'Enter' pour retourner au menu.\n")
		
		if user_action == CHOIX_AFFICHER_COMMANDE:
			print("\n Vous avez choisi de faire une commande.\n")
			if commande_existe == False:
				print("Aucune commande n'existe. Faites une commande pour afficher la commande.")
			else:
				flight_manager.commande.afficherCommande()
			input("\nAppuyez sur 'Enter' pour retourner au menu.\n")
		
		
		if user_action == CHOIX_PLUS_COURT_CHEMIN:
			if commande_existe == True:
				#best_drone_choice = flight_manager.plusCourtChemin()
				if best_drone_choice == False:
					print("ERREUR, MASSE SUPÉRIEUR À 25kg!")
				else:
					flight_manager.print_drone_mission(best_drone_choice)
			else:
				print("Vous n'avez pas fait de commande.")
			input("\nAppuyez sur 'Enter' pour retourner au menu.\n")
		
		
		
		if user_action == CHOIX_QUITTER_PROGRAMME:
			print("Exiting program.")
			break
	

main()


