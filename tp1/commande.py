import Graph
#########################################################################################
#	Class CommandManager: C'est une classe gestionnaire. Elle est responsable des 
#					      commandes des utilisaters.
#########################################################################################
class CommandManager:
	def __init__(self, totalA=0, totalB=0, totalC=0, totalObjets=0, maxMass = 25, massA = 1, massB = 3, massC = 6):
		self.commandeObjetsA = 0
		self.commandeObjetsB = 0
		self.commandeObjetsC = 0

		self.maxMass = maxMass
		self.massA = massA
		self.massB = massB
		self.massC = massC
		
		self.totalA = totalA
		self.totalB = totalB
		self.totalC = totalC
		self.totalObjets = self.commandeObjetsA + self.commandeObjetsB + self.commandeObjetsC

	#########################################################################################
    #	methode afficherCommande: Affiche la commande
    #	params [self]
    #########################################################################################
	def afficherCommande(self):
		print("Voici votre commande: ")
		print("                 	 " , self.commandeObjetsA , " objets de type A")
		print("                 	 " , self.commandeObjetsB , " objets de type B")
		print("                 	 " , self.commandeObjetsC , " objets de type C")
		total = self.commandeObjetsA + self.commandeObjetsB + self.commandeObjetsC
		print("                          Total:" , total, "objets \n")

	#########################################################################################
    #	methode prendreCommande: Fait partie du composant 1. Cette methode prend une commande
	#							 de l'usager.
    #	params [self]
    #########################################################################################
	def prendreCommande(self):
		
		acceptable_input = [str(i) for i in range(26)]
		input_error = False
		objectsA = 0
		objectsB = 0
		objectsC = 0
		
		# S'il n'y a pas 0 objets A dans l'inventaire, on prend les inputs de l'usager de facon à ne pas avoir 
		# des erreurs.
		print("\nMasse disponible à charger: ",self.maxMass, "kg")
		if self.totalA == 0:
			print("Il n'y a plus d'objets de type A disponible!")
		else:
			objectsA = str(input("Entrez la quantite d'objets de type A ("+ str(self.totalA) +" disponibles, poids de 1kg chacun): "))
			if objectsA in acceptable_input:
				print("\nMasse disponible à charger: ",self.maxMass- int(objectsA)*self.massA, "kg")
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
		

		# S'il n'y a pas 0 objets B dans l'inventaire, on prend les inputs de l'usager de facon à ne pas avoir 
		# des erreurs.
		if self.totalB == 0:
			print("Il n'y a plus d'objets de type B disponible!")
		else:
			objectsB = str(input("Entrez la quantite d'objets de type B ("+ str(int(self.totalB)) +" disponibles, poids de 3kg chacun): "))
			if objectsB in acceptable_input:
				print("\nMasse disponible à charger: ",self.maxMass- int(objectsA)*self.massA - int(objectsB)*self.massB , "kg")
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


		# S'il n'y a pas 0 objets C dans l'inventaire, on prend les inputs de l'usager de facon à ne pas avoir 
		# des erreurs.
		if self.totalC == 0:
			print("Il n'y a plus d'objets de type C disponible!")
		else:
			objectsC = str(input("Entrez la quantite d'objets de type C ("+ str(int(self.totalC)) +" disponibles, poids de 6kg chacun): "))
			if objectsC in acceptable_input:
				print("\nMasse disponible à charger: ",self.maxMass- int(objectsA)*self.massA - int(objectsB)*self.massB - int(objectsC)*self.massC, "kg")
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
		


		# On update les commandes dans les attributs.
		self.commandeObjetsA = int(objectsA)
		self.commandeObjetsB = int(objectsB)
		self.commandeObjetsC = int(objectsC)
		

		# On affiche la commande pour indiquer à l'usager ce qui est enregistré afin qu'il puisse faire des changements
		# s'il veut.
		print("\nLa masse total est: ", int(objectsA)*self.massA + int(objectsB)*self.massB + int(objectsC)*self.massC, "kg")
		self.afficherCommande()
		
		# Si l'usager n'a pas tappé un entier entre 0 et 25, on lui demande de verifier la commande pour un correction.
		if input_error == True:
			answer = str(input("Vous avez fait une erreur en entré. Voulez-vous faire une correction de commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		
		
		# Confirmer la commande, si l'usager veut faire un changement, on recommence cette fonction.
		else:
			answer = str(input("Voulez-vous modifier votre commande? Tappez 1 pour oui, 0 pour non. Votre reponse: "))
		if(answer == '1'):
			self.prendreCommande()
		

