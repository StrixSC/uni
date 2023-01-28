#########################################################################################
#	Class Arc: Contient les arcs
#########################################################################################
class Arc: 
    def __init__(self, firstVertex, secondVertex, distance):
        self.firstVertex    = firstVertex
        self.secondVertex   = secondVertex
        self.distance       = distance

        # Adding eachother as neighbors.
        self.firstVertex.add_neighbor(self.secondVertex, distance)
        self.secondVertex.add_neighbor(self.firstVertex, distance)


    #########################################################################################
    #	methode printArc: Affiche un arc
    #########################################################################################
    def printArc(self):
        print("First Vertex: " + str(self.firstVertex) + " , Second vertex: " + str(self.secondVertex) + " , Cost = " + str(self.distance)) 