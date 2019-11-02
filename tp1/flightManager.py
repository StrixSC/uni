from commande import Commande
from drone import Drone
import numpy as np
from Dijkstra import printPaths, compute_fastest_paths_dijstra

class FlightManager:
	def __init__(self, commande, drone, graph):
		self.commande = commande
		self.drone    = drone
		self.graph 	  = graph 

	def sort_accending_distances(self, fastest_paths):
		
		current_min = 10000
		new_mat = []
		copy = fastest_paths[:]
		index = 0
		ordered_indexes = []
		tag = [0 for i in range(len(copy))]

		for k in range(len(copy)):
			current_min = 10000
			for i in range(len(copy)):
				if (copy[i][1] < current_min) and (tag[i] == 0):
					current_min = copy[i][1]
					index = i
			tag[index] = 1
			ordered_indexes.append(index)

		for i in ordered_indexes:
			new_mat.append(copy[i])
		new_mat = np.array(new_mat)

		return new_mat



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
