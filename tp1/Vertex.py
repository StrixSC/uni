class Vertex:
    def __init__(self, Vertex_id, objectsA, objectsB, objectsC):
        self.id = Vertex_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC
        self.neighbors      = []

    def printVertex(self):
    	print("Printing Vertex: [ID, A, B, C] = [" + str(self.id) +", "+ str(self.numberObjectsA)+ ", "+ str(self.numberObjectsB) + ", "+ str(self.numberObjectsC)+"]")

    def add_neighbor(self, vertex):
        self.neighbors.append(vertex)

    def get_neighbors(self):
        return self.neighbors