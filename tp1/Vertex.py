import numpy as np
class Vertex:
    def __init__(self, Vertex_id = 0, objectsA = 0, objectsB = 0, objectsC = 0):
        self.id = Vertex_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC
        self.neighbors      = []
        self.distances      = []

    def printVertex(self):
        print_message = "L'inventaire du Noeud #" + self.id + ": [A, B, C] = "
        print_message += "["+self.numberObjectsA + ", "+ self.numberObjectsA + ", " + self.numberObjectsA+"]"
        voisins_array = self.get_neighbors_distances()
        print_message += ".\nLes voisins de ce Noeud sont: \n"
        
        for i in range(len(voisins_array)):
            print_message += "                              Voisin #" + str(i+1)
            print_message += ": [ Noeud #" + str(voisins_array[i][0].id)
            print_message += ", la distance de ce voisin est " + str(voisins_array[i][1]) + "m ]" + "\n"
        print(print_message)


    def add_neighbor(self, vertex, distance):
        self.neighbors.append(vertex)
        self.distances.append(distance)

    def get_neighbors(self):
        return self.neighbors

    def get_distances(self):
        return self.distances

    def get_neighbors_distances(self):
        neighbors_distances = []
        for i in range(len(self.neighbors)):
            neighbors_distances.append( [self.neighbors[i], self.distances[i]] )
        neighbors_distances = np.array(neighbors_distances)
        return neighbors_distances