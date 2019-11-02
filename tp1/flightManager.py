from commande import Commande
from drone import Drone
import numpy as np
from Dijkstra import printPaths, compute_fastest_paths_dijstra

class FlightManager:
	def __init__(self, commande, drone, graph):
		self.commande = commande
		self.drone    = drone
		self.graph 	  = graph

	def plusCourtChemin(self, depart, arrivee):
		fastest_paths = compute_fastest_paths_dijstra(self.graph, depart)
		return fastest_paths

	def flight_mission(self):
		mass_A = 1
		mass_B = 3
		mass_C = 6
		
		list_objects  = [self.commande.commandeObjetsA, self.commande.commandeObjetsB, self.commande.commandeObjetsC]
		total_mass	  = np.dot(list_objects,[mass_A,mass_B,mass_C])

		print("La mission du robot..")
		self.commande.afficherCommande()
		print("La masse total est: ", total_mass, "kg \n")
