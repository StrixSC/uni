import numpy as np
class Graph:
    def __init__(self, list_vertex, list_arcs):
        self.list_vertex = list_vertex
        self.list_arcs   = list_arcs
        matrix_adjacence = [[0 for j in range(len(list_vertex))] for i in range(len(list_vertex))]
        self.matrix_adjacence = np.array(matrix_adjacence)

    def printGraph(self):
        print("\n")
        print("Voici l'information des noeuds dans ce graphe: ")
        for vertex in self.list_vertex:
            vertex.printVertex()

        print("\n")

    def get_number_objects(self):
        totalObjectA = 0
        totalObjectB = 0
        totalObjectC = 0
        for i in range(len(self.list_vertex)):
            totalObjectA += int(self.list_vertex[i].numberObjectsA)
            totalObjectB += int(self.list_vertex[i].numberObjectsB)
            totalObjectC += int(self.list_vertex[i].numberObjectsC)

        #total = totalObjectA + totalObjectB + totalObjectC
        return totalObjectA, totalObjectB, totalObjectC#, total
	    
        

