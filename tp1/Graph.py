#########################################################################################
#	Class Graph. Cette classe contient la liste des arcs et sommets
#########################################################################################
class Graph:
    def __init__(self, list_vertex, list_arcs):
        self.list_vertex = list_vertex
        self.list_arcs   = list_arcs

    #########################################################################################
    #	methode printGraph: Affiche le graphe. Fait partie du Composant 1
    #	params [self]
    #########################################################################################
    def printGraph(self):
        print("\n")
        print("Voici l'information des noeuds dans ce graphe: ")
        for vertex in self.list_vertex:
            vertex.printVertex()

        print("\n")

    #########################################################################################
    #	methode get_number_objects: indique le nombre d'objets disponible dans l'entrepot,
    #                               pour chaque type d'objets.
    #	params [self]
    #########################################################################################
    def get_number_objects(self):
        totalObjectA = 0
        totalObjectB = 0
        totalObjectC = 0
        for i in range(len(self.list_vertex)):
            totalObjectA += int(self.list_vertex[i].numberObjectsA)
            totalObjectB += int(self.list_vertex[i].numberObjectsB)
            totalObjectC += int(self.list_vertex[i].numberObjectsC)

        return totalObjectA, totalObjectB, totalObjectC
	    
        

