class Commande:
	def __init__(self, objetsA=0, objetsB=0, objetsC=0):
		self.commandeObjetsA = objetsA
		self.commandeObjetsB = objetsB
		self.commandeObjetsC = objetsC


	def afficherCommande(self):
		print("Voici la commande: ")
		print("                 	 " , self.commandeObjetsA , " objets de type A")
		print("                 	 " , self.commandeObjetsB , " objets de type B")
		print("                 	 " , self.commandeObjetsC , " objets de type C")
		total = self.commandeObjetsA + self.commandeObjetsB + self.commandeObjetsC
		print("Total: " , total, " objets \n")

	def prendreCommande(self):

		self.totalA = 17
		objectsA = str(input("Entrez la quantite d'objets de type A ("+ str(self.totalA) +" disponibles, poids de 1kg chacun): "))
		if(int(objectsA) > self.totalA):
			print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous "+ str(int(self.totalA)) +" à la place?")
			answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
			if(answer == '1'): 
				objectsA = self.totalA
			else:
				print("Erreur, recommencez.")
				self.prendreCommande()
				return True
		self.totalB = (25 - int(objectsA) * 1) / 3

		objectsB = str(input("Entrez la quantite d'objets de type B ("+ str(int(self.totalB)) +" disponibles, poids de 3kg chacun): "))
		if(int(objectsB) > self.totalB):
			print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous "+ str(int(self.totalB)) +" à la place?")
			answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
			if(answer == '1'): 
				objectsB = self.totalB
			else:
				print("Erreur, recommencez.")
				self.prendreCommande()
				return True
		self.totalC = (25 - int(objectsA) * 1 - int(objectsB) * 3) / 6

		objectsC = str(input("Entrez la quantite d'objets de type C ("+ str(int(self.totalC)) +" disponibles, poids de 6kg chacun): "))
		if(int(objectsC) > self.totalC):
			print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous "+ str(int(self.totalC)) +" à la place?")
			answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
			if(answer == '1'): 
				objectsC = self.totalC
			else:
				print("Erreur, recommencez.")
				self.prendreCommande()
				return True

		self.commandeObjetsA = int(objectsA)
		self.commandeObjetsB = int(objectsB)
		self.commandeObjetsC = int(objectsC)
		
		#print("Votre commande est: ")
		self.afficherCommande()
		answer = str(input("Voulez-vous faire une correction de commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		if(answer == '1'):
			self.prendreCommande()
		else:
			None

