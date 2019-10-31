import numpy

class Graph:
    def __init__(self, list_vertex, list_arcs):
        self.list_vertex = list_vertex
        self.list_arcs   = list_arcs
        self.graph = [[0 for c in range(len(list_vertex))]
                      for r in range(len(list_vertex))]
                      
        #on parcours la liste d'arcs.
        #pour chaque arcs, On pose le graph a la position du premier vertex and du second vertex a 1.
        #On repete en inversant la position dans notre graph, de sorte a ce qu'on ait une concordance dans les valeurs.
        
        #Exemple: Si on a un lien entre les vertex 18 et 20: on pose le graph a la position[18][20] a 1;
        #il faut aussi poser le graph a la position [20][18] a 1. 
        for i in range(len(list_arcs)):
            self.graph[int(list_arcs[i].firstVertex.id)][int(list_arcs[i].secondVertex.id)] = 1;
            self.graph[int(list_arcs[i].secondVertex.id)][int(list_arcs[i].firstVertex.id)] = 1;
    
    def printGraph(self):
        print("Matrice d'adjacence du graphique:\n")
        for i in range(len(self.graph)):
            print(i)
            for j in range(len(self.graph[i])):
                
                print(self.graph[i][j], end='')

            print("\n")

