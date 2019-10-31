import numpy as np
class Graph:
    def __init__(self, list_vertex, list_arcs):
        self.list_vertex = list_vertex
        self.list_arcs   = list_arcs
        matrix_adjacence = [[0 for j in range(len(list_vertex))] for i in range(len(list_vertex))]
        self.matrix_adjacence = np.array(matrix_adjacence)

        #self.graph = [[0 for c in range(len(list_vertex))]
        #              for r in range(len(list_vertex))]
                      
        #on parcours la liste d'arcs.
        #pour chaque arcs, On pose le graph a la position du premier vertex and du second vertex a 1.
        #On repete en inversant la position dans notre graph, de sorte a ce qu'on ait une concordance dans les valeurs.
        
        #Exemple: Si on a un lien entre les vertex 18 et 20: on pose le graph a la position[18][20] a 1;
        #il faut aussi poser le graph a la position [20][18] a 1. 
        #for i in range(len(list_arcs)):
        #    self.graph[int(list_arcs[i].firstVertex.id)][int(list_arcs[i].secondVertex.id)] = 1;
        #    self.graph[int(list_arcs[i].secondVertex.id)][int(list_arcs[i].firstVertex.id)] = 1;
    
    def printGraph(self):
        print("\n")
        print("Matrice d'adjacence du graphique:\n")
        for node in self.list_vertex:
            for neighbor in node.get_neighbors():
                self.matrix_adjacence[int(node.id)][int(neighbor.id)] = 1
        
        print(self.matrix_adjacence)
        print("\n")
	    
        

