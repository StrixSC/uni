import Graph
class CommandManager:
	def __init__(self, totalA=0, totalB=0, totalC=0, totalObjets=0):
		self.commandeObjetsA = 0
		self.commandeObjetsB = 0
		self.commandeObjetsC = 0

		self.totalA = totalA
		self.totalB = totalB
		self.totalC = totalC
		self.totalObjets = totalA + totalB + totalC


	def afficherCommande(self):
		print("Voici votre commande: ")
		print("                 	 " , self.commandeObjetsA , " objets de type A")
		print("                 	 " , self.commandeObjetsB , " objets de type B")
		print("                 	 " , self.commandeObjetsC , " objets de type C")
		total = self.commandeObjetsA + self.commandeObjetsB + self.commandeObjetsC
		print("                          Total:" , total, "objets \n")

	def prendreCommande(self):

		acceptable_input = [str(i) for i in range(26)]
		input_error = False
		objectsA = str(input("Entrez la quantite d'objets de type A ("+ str(self.totalA) +" disponibles, poids de 1kg chacun): "))
		if objectsA in acceptable_input:
			if(int(objectsA) > self.totalA):
				print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous " + str(int(self.totalA)) +" a la place?")
				answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
				if(answer == '1'): 
					objectsA = self.totalA
				else:
					print("Erreur, recommencez.")
					self.prendreCommande()
					return True
		else:
			objectsA = 0
			input_error = True

		objectsB = str(input("Entrez la quantite d'objets de type B ("+ str(int(self.totalB)) +" disponibles, poids de 3kg chacun): "))
		if objectsB in acceptable_input:
			if(int(objectsB) > self.totalB):
				print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous "+ str(int(self.totalB)) +" a la place?")
				answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
				if(answer == '1'): 
					objectsB = self.totalB
				else:
					print("Erreur, recommencez.")
					self.prendreCommande()
					return True
		else:
			objectsB = 0
			input_error = True

		objectsC = str(input("Entrez la quantite d'objets de type C ("+ str(int(self.totalC)) +" disponibles, poids de 6kg chacun): "))
		if objectsC in acceptable_input:
			if(int(objectsC) > self.totalC):
				print("Il n'y a pas assez de cette objet dans l'entrepot, voulez-vous "+ str(int(self.totalC)) +" a la place?")
				answer = str(input("Tappez 1 pour oui, 0 pour non. Votre reponse: "))
				if(answer == '1'): 
					objectsC = self.totalC
				else:
					print("Erreur, recommencez.")
					self.prendreCommande()
					return True
		else:
			objectsC = 0
			input_error = True
		
		self.commandeObjetsA = int(objectsA)
		self.commandeObjetsB = int(objectsB)
		self.commandeObjetsC = int(objectsC)
		
		self.afficherCommande()
		if input_error == True:
			answer = str(input("Vous avez fait une erreur en entré. Voulez-vous faire une correction de commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		else:
			answer = str(input("Voulez-vous modifier votre commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		if(answer == '1'):
			self.prendreCommande()
		

