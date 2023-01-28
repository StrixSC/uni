#########################################################################################
#	Class Vertex. Cette classe est utilié pour créer les objets noeuds.
#########################################################################################
class Vertex:
    def __init__(self, Vertex_id = 0, objectsA = 0, objectsB = 0, objectsC = 0):
        self.id = Vertex_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC
        self.neighbors      = []
        self.distances      = []

    #########################################################################################
    #	methode printVertex: affiche un neoud
    #	params [self]
    #########################################################################################
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

    #########################################################################################
    #	methode add_neighbor: Ajoute un voisin du noeud
    #	params [self, vertex (Vertex), distance (int)]
    #########################################################################################
    def add_neighbor(self, vertex, distance):
        self.neighbors.append(vertex)
        self.distances.append(distance)

    #########################################################################################
    #	methode get_neighbors_distances: Retourne la liste des voisins 
    #	params [self, vertex (Vertex), distance (int)]
    #   return neighbors_distances: list [Noeud (Vertex), distance (int)]
    #########################################################################################
    def get_neighbors_distances(self):
        neighbors_distances = []
        for i in range(len(self.neighbors)):
            neighbors_distances.append([self.neighbors[i], self.distances[i]])
        return neighbors_distances