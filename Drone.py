from graph import Graph

class Drone:
    
    #Les variables necessaires pour le calcul de distance du robot
    typeRobot = ''
    k = 0
    m = 0
    graph = Graph(#parametres a specifie)

    __init__(self, typeRobot):
        self.typeRobot = typeRobot
        
    def prendreCommande:
        
        if typeRobot == X:
            k = (1 + m)
        elif typeRobot == Y:
            k = (1.5 + (0.6*m))
        elif typeRobot == Z: 
            k = (2.5 + (0.2*m))
            
        
