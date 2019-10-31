class Vertex:
    def __init__(self, Vertex_id, objectsA, objectsB, objectsC):
        self.id = Vertex_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC

    def printVertex(self):
    	print("(ID,A,B,C) =(" + str(self.id) +","+ str(self.numberObjectsA)+ ","+ str(self.numberObjectsB) + ","+ str(self.numberObjectsC)+")")

    