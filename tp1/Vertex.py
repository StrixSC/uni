import numpy as np
class Vertex:
    def __init__(self, Vertex_id, objectsA, objectsB, objectsC):
        self.id = Vertex_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC
        self.neighbors      = []
        self.distances      = []

    def printVertex(self):
    	print("Printing Vertex: [ID, A, B, C] = [" + str(self.id) +", "+ str(self.numberObjectsA)+ ", "+ str(self.numberObjectsB) + ", "+ str(self.numberObjectsC)+"]")

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