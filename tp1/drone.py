class Drone:
	def __init__(self, typeDrone, mass=0, time=0, distance_from_previous=0):
		# Error handling.
		self.correct_drone_choice = True
		self.typeDrone  = typeDrone
		self.mass = mass
		self.chemin = []
		self.time = time
		self.distance_from_previous = distance_from_previous			
		
		# 
		if typeDrone == 'X':
			if(mass > 5):
				self.correct_drone_choice = False
				print("ERROR: Drone X cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge  = 5
				self.constant_K = 1 + mass
				self.mass = mass

		elif typeDrone == 'Y':
			if(mass > 10):
				self.correct_drone_choice = False
				print("ERROR: Drone Y cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge = 10
				self.constant_K = 1.5 + 0.6*mass
				self.mass = mass

		elif typeDrone == 'Z':
			if(mass > 25):
				self.correct_drone_choice = False
				print("ERROR: Drone Z cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge = 25
				self.constant_K = 2.5 + 0.2*mass
				self.mass = mass
		else:
			self.correct_drone_choice = False
			print("\n ERROR: TYPE OF DRONE ", typeDrone, "DOES NOT EXIST! \n")

		#if self.correct_drone_choice == True:
		#	print("Drone Type: ", self.typeDrone, "   maxCharge: ", self.maxCharge, "   Constant K: ", self.constant_K)


	def change_mass(self, mass):
		self.mass += mass
		#print("MASS:",self.mass)
		self.time += 10
		#print("TIME:", self.time)
		if self.typeDrone == 'X':
			self.constant_K = 1 + self.mass
			#print("MASS:", mass, "K:",self.constant_K)
				
		elif self.typeDrone == 'Y':
			self.constant_K = 1.5 + 0.6*self.mass

		elif self.typeDrone == 'Z':
			self.constant_K = 2.5 + 0.2*self.mass


	def printDrone(self):
		if self.correct_drone_choice == True:
			print("Drone Type: ", self.typeDrone, "   maximum load capacity: ", self.maxCharge, "   Constant K: ", self.constant_K, ". It's currently carrying", self.mass, "kg.")
		else:
			print("----- ERROR: THIS DRONE CANNOT BE USED OR DOESN'T EXIST! ----")
