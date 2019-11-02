class Drone:
	def __init__(self, typeDrone, mass = 0):
		# Error handling.
		self.correct_drone_choice = True
		self.typeDrone  = typeDrone			
		
		# 
		if typeDrone == 'X':
			if(mass > 5):
				self.correct_drone_choice = False
				print("ERROR: Drone X cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge  = 5
				self.constant_K = 1 + mass
				self.carry_mass = mass

		elif typeDrone == 'Y':
			if(mass > 10):
				self.correct_drone_choice = False
				print("ERROR: Drone Y cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge = 10
				self.constant_K = 1.5 + 0.6*mass
				self.carry_mass = mass

		elif typeDrone == 'Z':
			if(mass > 25):
				self.correct_drone_choice = False
				print("ERROR: Drone Z cannot hold a mass of ", mass, "kg! Please change drone type. \n ")
			else:
				self.maxCharge = 25
				self.constant_K = 2.5 + 0.2*mass
				self.carry_mass = mass
		else:
			self.correct_drone_choice = False
			print("\n ERROR: TYPE OF DRONE ", typeDrone, "DOES NOT EXIST! \n")

		#if self.correct_drone_choice == True:
		#	print("Drone Type: ", self.typeDrone, "   maxCharge: ", self.maxCharge, "   Constant K: ", self.constant_K)


	def change_mass(self, mass):
		self.carry_mass = mass

	def printDrone(self):
		if self.correct_drone_choice == True:
			print("Drone Type: ", self.typeDrone, "   maximum load capacity: ", self.maxCharge, "   Constant K: ", self.constant_K, ". It's currently carrying", self.carry_mass, "kg.")
		else:
			print("----- ERROR: THIS DRONE CANNOT BE USED OR DOESN'T EXIST! ----")