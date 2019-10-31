class Commande:
	def __init__(self, objetsA, objetsB, objetsC):
		self.commandeObjetsA = objetsA
		self.commandeObjetsB = objetsB
		self.commandeObjetsC = objetsC

	def afficherCommande(self):
		print("Voici votre commande: ")
		print("                 	 " , self.commandeObjetsA , " objets de type A")
		print("                 	 " , self.commandeObjetsB , " objets de type A")
		print("                 	 " , self.commandeObjetsC , " objets de type A")
		total = self.commandeObjetsA + self.commandeObjetsB + self.commandeObjetsC
		print("Total: " , total)

	def prendreCommande(self):
		objectsA = str(input("Entrez la quantite d'object de type A: "))
		objectsB = str(input("Entrez la quantite d'object de type B: "))
		objectsC = str(input("Entrez la quantite d'object de type C: "))
		if(objectsA == '' or objectsB == '' or objectsC == ''):
			print("Erreur, recommencez.")
			self.prendreCommande()
		self.commandeObjetsA = int(objectsA)
		self.commandeObjetsB = int(objectsB)
		self.commandeObjetsC = int(objectsC)
		
		print("Votre commande est: ")
		self.afficherCommande()
		answer = str(input("Voulez-vous faire une correction de commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		if(answer == '1'):
			self.prendreCommande()