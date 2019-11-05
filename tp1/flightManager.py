from commande import Commande
from drone import Drone
import numpy as np
import math
from Dijkstra import printPaths, compute_fastest_paths_dijstra

class FlightManager:
	def __init__(self, graph):
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



	def plusCourtChemin(self, depart, arrive = 0):
		fastest_paths = compute_fastest_paths_dijstra(self.graph, depart)
		return self.sort_accending_distances(fastest_paths)

	def getShortestPath(self, source, destination):
		fastest_paths_home = compute_fastest_paths_dijstra(self.graph, source)
		
		distance = int(fastest_paths_home[int(destination.id)][1])
		path = str(fastest_paths_home[int(destination.id)][2])
		return path, distance
	

	def flight_mission(self):
		
		# Prendre la commande
		totalA, totalB, totalC, totalObjets = self.graph.get_number_objects()
		commande = Commande(totalA, totalB, totalC, totalObjets)
		commande.prendreCommande()

		mass_A = commande.commandeObjetsA * 1
		mass_B = commande.commandeObjetsB * 3
		mass_C = commande.commandeObjetsC * 6

		total_mass = mass_A + mass_B + mass_C
			
		print("La mission du robot..")
		commande.afficherCommande()

		print("La masse total est: ", total_mass, "kg \n")

		# Choose the right robots according to maximum weight
		if(total_mass <= 5):
			droneX = Drone('X')
			droneY = Drone('Y')
			droneZ = Drone('Z')
		
		elif(total_mass > 5) and (total_mass <= 10):
			droneX = Drone('X')
			droneX.correct_drone_choice = False
			droneY = Drone('Y')
			droneZ = Drone('Z')
		
		elif(total_mass > 10) and (total_mass <= 25):
			droneX = Drone('X')
			droneX.correct_drone_choice = False
			droneY = Drone('Y')
			droneY.correct_drone_choice = False
			droneZ = Drone('Z')
	
		else:
			print("ERREUR! VOUS AVEZ MIS UNE MASSE TROP GRANDE!")
			# Recommencer a
			self.flight_mission()
			
		# Start from vertex 0
		current_vertex = self.graph.list_vertex[0]

		# Calculate shortest time for drones
		while(commande.commandeObjetsA != 0) or (commande.commandeObjetsB != 0) or (commande.commandeObjetsC != 0):

			# fastest paths from current vertex in ascending order
			fastest_path = self.plusCourtChemin(current_vertex)

			if(commande.commandeObjetsA > 0):
				for i in range(21):
					# if closest vertex has object A
					if(int(fastest_path[i][0].numberObjectsA) > 0):
						number_of_objectsA = int(fastest_path[i][0].numberObjectsA)
						number_of_objectsB = int(fastest_path[i][0].numberObjectsB)
						number_of_objectsC = int(fastest_path[i][0].numberObjectsC)

						current_vertex = fastest_path[i][0]

						# update time if you stop and save path
						if(droneX.correct_drone_choice):
							droneX.chemin.append(fastest_path[i])
							droneX.distance_from_previous = fastest_path[i][1]
							droneX.time += droneX.constant_K * droneX.distance_from_previous
					
						elif(droneY.correct_drone_choice):
							droneY.chemin.append(fastest_path[i])
							droneY.distance_from_previous = fastest_path[i][1]
							droneY.time += droneY.constant_K * droneY.distance_from_previous
							
						elif(droneZ.correct_drone_choice):
							droneZ.chemin.append(fastest_path[i])
							droneZ.distance_from_previous = fastest_path[i][1]
							droneZ.time += droneZ.constant_K * droneZ.distance_from_previous
						
						# take as many as objects A necessary
						while(number_of_objectsA != 0):
							if(droneX.correct_drone_choice):
								droneX.change_mass(number_of_objectsA/number_of_objectsA)
								droneX.chemin.append('collecting item A')
								
							elif(droneY.correct_drone_choice):
								droneY.change_mass(number_of_objectsA/number_of_objectsA)
								droneY.chemin.append('collecting item A')
							
							elif(droneZ.correct_drone_choice):
								droneZ.change_mass(number_of_objectsA/number_of_objectsA)
								droneZ.chemin.append('collecting item A')
								
							commande.commandeObjetsA -= 1
							number_of_objectsA -= 1
							fastest_path[i][0].numberObjectsA = str(number_of_objectsA)

							if(commande.commandeObjetsA == 0): 
								break


							# look if you need objects B and if there are any on current vertex to save time
							if(commande.commandeObjetsB > 0):
								while(number_of_objectsB != 0):
									if(droneX.correct_drone_choice):
										droneX.change_mass(number_of_objectsB/number_of_objectsB)
										droneZ.chemin.append('collecting item B')
										
									elif(droneY.correct_drone_choice):
										droneY.change_mass(number_of_objectsB/number_of_objectsB)
										droneZ.chemin.append('collecting item B')
									
									elif(droneZ.correct_drone_choice):
										droneZ.change_mass(number_of_objectsB/number_of_objectsB)
										droneZ.chemin.append('collecting item B')
									
									commande.commandeObjetsB -= 1
									number_of_objectsB -= 1
									fastest_path[i][0].numberObjectsB = str(number_of_objectsB)

									if(commande.commandeObjetsB == 0): 
										break
							
							# look if you need objects C and if there are any on current vertex to save time
							if(commande.commandeObjetsC > 0):
								while(number_of_objectsC != 0):
									if(droneX.correct_drone_choice):
										droneX.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
										
									elif(droneY.correct_drone_choice):
										droneY.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
									
									elif(droneZ.correct_drone_choice):
										droneZ.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
									
									commande.commandeObjetsC -= 1
									number_of_objectsC -= 1	
									fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

									if(commande.commandeObjetsC == 0): 
										break
						break


			elif(commande.commandeObjetsB > 0):
				for i in range(21):
					# if closest vertex has object A
					if(int(fastest_path[i][0].numberObjectsB) > 0):
						number_of_objectsB = int(fastest_path[i][0].numberObjectsB)
						number_of_objectsC = int(fastest_path[i][0].numberObjectsC)

						current_vertex = fastest_path[i][0]

						# update time if you stop and save path
						if(droneX.correct_drone_choice):
							droneX.chemin.append(fastest_path[i])
							droneX.distance_from_previous = fastest_path[i][1]
							droneX.time += droneX.constant_K * droneX.distance_from_previous
					
						elif(droneY.correct_drone_choice):
							droneY.chemin.append(fastest_path[i])
							droneY.distance_from_previous = fastest_path[i][1]
							droneY.time += droneY.constant_K * droneY.distance_from_previous
							
						elif(droneZ.correct_drone_choice):
							droneZ.chemin.append(fastest_path[i])
							droneZ.distance_from_previous = fastest_path[i][1]
							droneZ.time += droneZ.constant_K * droneZ.distance_from_previous
						
						# take as many as objects A necessary
						while(number_of_objectsB != 0):
							if(droneX.correct_drone_choice):
								droneX.change_mass(number_of_objectsB/number_of_objectsB)
								droneX.chemin.append('collecting item B')
								
							elif(droneY.correct_drone_choice):
								droneY.change_mass(number_of_objectsB/number_of_objectsB)
								droneY.chemin.append('collecting item B')
							
							elif(droneZ.correct_drone_choice):
								droneZ.change_mass(number_of_objectsB/number_of_objectsB)
								droneZ.chemin.append('collecting item B')
								
							commande.commandeObjetsB -= 1
							number_of_objectsB -= 1
							fastest_path[i][0].numberObjectsB = str(number_of_objectsB)

							if(commande.commandeObjetsB == 0): 
								break
							
							# look if you need objects C and if there are any on current vertex to save time
							if(commande.commandeObjetsC > 0):
								while(number_of_objectsC != 0):
									if(droneX.correct_drone_choice):
										droneX.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
										
									elif(droneY.correct_drone_choice):
										droneY.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
									
									elif(droneZ.correct_drone_choice):
										droneZ.change_mass(number_of_objectsC/number_of_objectsC)
										droneZ.chemin.append('collecting item C')
									
									commande.commandeObjetsC -= 1
									number_of_objectsC -= 1	
									fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

									if(commande.commandeObjetsC == 0): 
										break
						break
				
			elif(commande.commandeObjetsC > 0):
				for i in range(21):
					# if closest vertex has object A
					if(int(fastest_path[i][0].numberObjectsC) > 0):
						number_of_objectsC = int(fastest_path[i][0].numberObjectsC)

						current_vertex = fastest_path[i][0]

						# update time if you stop and save path
						if(droneY.correct_drone_choice):
							droneY.chemin.append(fastest_path[i])
							droneY.distance_from_previous = fastest_path[i][1]
							droneY.time += droneY.constant_K * droneY.distance_from_previous
							
						elif(droneZ.correct_drone_choice):
							droneZ.chemin.append(fastest_path[i])
							droneZ.distance_from_previous = fastest_path[i][1]
							droneZ.time += droneZ.constant_K * droneZ.distance_from_previous
						
						# take as many as objects A necessary
						while(number_of_objectsC != 0):
								
							if(droneY.correct_drone_choice):
								droneY.change_mass(number_of_objectsC/number_of_objectsC)
								droneY.chemin.append('collecting C')
							
							elif(droneZ.correct_drone_choice):
								droneZ.change_mass(number_of_objectsC/number_of_objectsC)
								droneZ.chemin.append('collecting C')
								
							commande.commandeObjetsC -= 1
							number_of_objectsC -= 1
							fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

							if(commande.commandeObjetsC == 0): 
								break
							
						break
		
		#return to vertex 0  with shortest path from current vertex    
		                                              
		path, distance =  self.getShortestPath(current_vertex, self.graph.list_vertex[0])
		

		# sort and output the fastest according to which robots were used
		if(droneX.correct_drone_choice):
			droneX.distance_from_previous = distance
			droneX.time += droneX.constant_K * droneX.distance_from_previous
			droneX.chemin.append(path)

			droneY.distance_from_previous = distance
			droneY.time += droneX.constant_K * droneX.distance_from_previous
			droneY.chemin.append(path)

			droneZ.distance_from_previous = distance
			droneZ.time += droneX.constant_K * droneX.distance_from_previous
			droneZ.chemin.append(path)
			
			fastestDrone = [droneX.time, droneY.time, droneZ.time]
			fastestDrone.sort()
			if(droneX.time == fastestDrone[2]):
				return droneX
			elif(droneY.time == fastestDrone[2]):
				return droneY
			else:
				return droneZ

		elif(not droneX.correct_drone_choice) and (not droneY.correct_drone_choice):
			droneZ.distance_from_previous = distance
			droneZ.time += droneX.constant_K * droneX.distance_from_previous
			droneZ.chemin.append(path)
			return droneZ			
		
		else:
			droneY.distance_from_previous = distance
			droneY.time += droneX.constant_K * droneX.distance_from_previous
			droneY.chemin.append(path)

			droneZ.distance_from_previous = distance
			droneZ.time += droneX.constant_K * droneX.distance_from_previous
			droneZ.chemin.append(path)

			fastestDrone = [droneY.time, droneZ.time]
			fastestDrone.sort()

			if(droneY.time == fastestDrone[1]):
				return droneY
			else:
				return droneZ
	
	def print_optimal(self):
		fastestDrone = self.flight_mission()
		#print(fastestDrone)

		typeDrone, mass, chemin, time = fastestDrone.printDroneMission()

		print("typeDrone", typeDrone)
		travel_plan = np.array(chemin)
		i = 0
		
		print("Flight mission plan: \n")

		for i in range(len(travel_plan)-1):

			string = str(travel_plan[i])
			if string.find("collecting") != 0:
				print("\n 	Flying to the next station. Flight Path: ", travel_plan[i][2])
				id_vertex = travel_plan[i][0].id
			else:
				print("		Stopping at the station " + str(id_vertex) +". " , travel_plan[i])


		
		print("The drone has finished loading all items. Now returning home to station 0. \n flight path: ")
		print("			", travel_plan[len(travel_plan)-1])
		
		print("Total mission time: " , str(math.floor(int(time)/60)) + ":" + str(int(time)%60) , " min.")

