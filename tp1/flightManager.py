from commande import CommandManager
from drone import Drone
import math
from Dijkstra import stringify_path, compute_fastest_paths_dijstra

#########################################################################################
#	Class FlightManager: C'est une classe gestionnaire. Elle est responsable des gestions
#						 concernant les robots. Cette classe choisi le meilleur robot
#						 pour la tâche.
#########################################################################################
class FlightManager:
	def __init__(self, graph):
		self.graph 	  = graph 
		totalA, totalB, totalC= self.graph.get_number_objects()
		self.totalA = totalA
		self.totalB = totalB
		self.totalC = totalC
		self.commande = CommandManager(totalA, totalB, totalC)

	#############################################################################################
    #	methode sort_accending_distances: Cette methode utilise la foncion 
	#									  compute_fastest_paths_dijstra() et retourne les 
	#									  sommets avant leurs distances respectives par rapport
	#									  à la souce 'depart'. Elle retourne dans un ordre
	#									  croissant.
    #	params [self, depart (Object Vertex)]
	#	return list. Chaque élément de la liste est: [Vertex Object, Distance de la source, path]
    ##############################################################################################
	def sort_accending_distances(self, depart):
		fastest_paths = compute_fastest_paths_dijstra(self.graph, depart)
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
		

		return new_mat

	#############################################################################################
    #	methode getShortestPath: Cette methode retource le chemin le plus court entre 2 sommets.
    #	params [self, source (Object Vertex), destination (Object Vertex)]
	#	return path (String), distance (Integer)
    ##############################################################################################
	def getShortestPath(self, source, destination):
		fastest_paths_home = compute_fastest_paths_dijstra(self.graph, source)
		
		distance = int(fastest_paths_home[int(destination.id)][1])
		path = str(fastest_paths_home[int(destination.id)][2])
		return path, distance
	
	#############################################################################################
    #	methode plusCourtChemin: Cette methode le drone approprié pour la commande de l'usager.
	#							 Elle fait partie du composant 3 à implémenter. 
	#							 L'algorithme de Dijsktra est utilisé ici, mais il vien indirectement
	#							 l'une autre fonction.
    #	params [self]
	#	return drone (Drone object)
    ##############################################################################################
	def plusCourtChemin(self):
		
		# Initialiser un drone. Le drone drone pour le travail sera choisi.
		droneX = Drone('X')
		droneY = Drone('Y')
		droneZ = Drone('Z')
		
		if (self.totalA + self.totalB + self.totalC) == 0:
			return 
		
		commande = self.commande

		objets_commande_A = self.commande.commandeObjetsA
		objets_commande_B = self.commande.commandeObjetsB
		objets_commande_C = self.commande.commandeObjetsC


		if self.commande.totalA == 0 and objets_commande_A > 0:
			print("Il n'y a plus d'objets de type A")
			self.commande.commandeObjetsA = 0

		if self.commande.totalB == 0 and objets_commande_B > 0:
			print("Il n'y a plus d'objets de type B")
			self.commande.commandeObjetsB = 0

		if self.commande.totalC == 0 and objets_commande_C > 0:
			print("Il n'y a plus d'objets de type C")
			self.commande.commandeObjetsC = 0
			

		mass_A = objets_commande_A * 1
		mass_B = objets_commande_B * 3
		mass_C = objets_commande_C * 6

		total_mass = mass_A + mass_B + mass_C

		#print("La mission du robot..")
		#commande.afficherCommande()

		#print("La masse total est: ", total_mass, "kg \n")

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
			

		
		
			
		# Start from vertex 0
		current_vertex = self.graph.list_vertex[0]
		if total_mass <= 25 and total_mass >= 0:
			# Updating total objects in inventory
			self.commande.totalA -= objets_commande_A
			self.commande.totalB -= objets_commande_B
			self.commande.totalC -= objets_commande_C

			# Calculate shortest time for drones
			while(objets_commande_A != 0) or (objets_commande_B != 0) or (objets_commande_C != 0):

				# fastest paths from current vertex in ascending order
				fastest_path = self.sort_accending_distances(current_vertex)

				if(objets_commande_A > 0):
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
									
								objets_commande_A -= 1
								number_of_objectsA -= 1
								fastest_path[i][0].numberObjectsA = str(number_of_objectsA)

								if(objets_commande_A == 0): 
									break


								# look if you need objects B and if there are any on current vertex to save time
								if(objets_commande_B > 0):
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
										
										objets_commande_B -= 1
										number_of_objectsB -= 1
										fastest_path[i][0].numberObjectsB = str(number_of_objectsB)

										if(commande.commandeObjetsB == 0): 
											break
								
								# look if you need objects C and if there are any on current vertex to save time
								if(objets_commande_C > 0):
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
										
										objets_commande_C -= 1
										number_of_objectsC -= 1	
										fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

										if(objets_commande_C == 0): 
											break
							break


				elif(objets_commande_B > 0):
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
									
								objets_commande_B -= 1
								number_of_objectsB -= 1
								fastest_path[i][0].numberObjectsB = str(number_of_objectsB)

								if(objets_commande_B == 0): 
									break
								
								# look if you need objects C and if there are any on current vertex to save time
								if(objets_commande_C > 0):
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
										
										objets_commande_C -= 1
										number_of_objectsC -= 1	
										fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

										if(objets_commande_C == 0): 
											break
							break
					
				elif(objets_commande_C > 0):
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
									droneY.chemin.append('collecting item C')
								
								elif(droneZ.correct_drone_choice):
									droneZ.change_mass(number_of_objectsC/number_of_objectsC)
									droneZ.chemin.append('collecting item C')
									
								objets_commande_C -= 1
								number_of_objectsC -= 1
								fastest_path[i][0].numberObjectsC = str(number_of_objectsC)

								if(objets_commande_C == 0): 
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
		else:
			return False
	
	###################################################################################################
    #	methode print_drone_mission: Affiche les résultats obtenus dans la méthode plusCourtDistance()
    #	params [self, fastestDrone (Drone object)]
    ###################################################################################################
	def print_drone_mission(self, fastestDrone):
		
		typeDrone, mass, travel_plan, time = fastestDrone.printDroneMission()
		print("\n \n Best drone: ", typeDrone)
		i = 0
		print("Flight mission plan: \n")
	
		for i in range(len(travel_plan)-1):

			string = str(travel_plan[i])
			if string.find("collecting") != 0:
				print("\n 	Flying to the next station. Flight Path: ", travel_plan[i][2])
				print("        Stopping at the station ", travel_plan[i][0].id)
				id_vertex = travel_plan[i][0].id
			else:
				print("		                        " , travel_plan[i])
		
		
		print("\nThe drone has finished loading all items. Now returning home to station 0. \nFlight path back home:", travel_plan[len(travel_plan)-1])
		print("Total mission time: (" + str(math.floor(int(time))) + "seconds) or (" +  str(math.floor(int(time)/60)) + "min" + str(int(time)%60) + "s).\n")

