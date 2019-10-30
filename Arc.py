class Arc: 
    def __init__(self, firstVertex, secondVertex, cost):
        self.firstVertex = firstVertex
        self.secondVertex = secondVertex
        self.cost = cost

    def printArc(self):
        print( "First Vertex: " + str(self.firstVertex) + " , Second vertex: " + str(self.secondVertex) + " , Cost = " + str(self.cost) ) 

