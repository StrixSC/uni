class Arc: 
    def __init__(self, firstVertex, secondVertex, cost):
        self.firstVertex    = firstVertex
        self.secondVertex   = secondVertex
        self.cost           = cost

        # Adding eachother as neighbors.
        self.firstVertex.add_neighbor(self.secondVertex)
        self.secondVertex.add_neighbor(self.firstVertex)


    def printArc(self):
        print("First Vertex: " + str(self.firstVertex) + " , Second vertex: " + str(self.secondVertex) + " , Cost = " + str(self.cost)) 