#########################################################################################
#	fonction stringify_path: Construit le chemin le plus court recursivement.
#							 Cette fonction ne fait pas d'algorithme de Dijsktra, 
#						     Elle est utilisé dans compute_fastest_paths_dijstra()
#	params [self,node_id (Vertex), source_id, (Interger)]
# 	return path (String)
#########################################################################################
def stringify_path(computational_matrix_data, node_id, source_id ):
	
	vertex_index 			= 0
	visited_index 			= 1
	shortest_distance_index = 2
	previous_node_index 	= 3
	if str(node_id) == str(source_id):
		return str(source_id)

	if computational_matrix_data[node_id][previous_node_index] == str(source_id):
		return  str(source_id) + '->' + str(node_id)
	else:
		prev_node = computational_matrix_data[node_id][previous_node_index]	
		return stringify_path(computational_matrix_data, int(prev_node), source_id) + "->" + str(node_id)


#########################################################################################
#	fonction compute_fastest_paths_dijstra: On implémente l'algorithme de Dijsktra ici
#	params [self,departure_node (Vertex)]
# 	return fastest_paths_matrix (Voir au bas de la page.)
#########################################################################################
def compute_fastest_paths_dijstra(graph, departure_node):
	

	#[ VertexObject (Class:Vertex), Visited (Type:Boolean), shortest_distance (type:int), previous_node (type:string)  ]
	# computational_matrix_data is a 4x21 matrix, and it contains all the data necessary for computation of the algorithm.

	computational_matrix_data = [[graph.list_vertex[j], False, 1000000, ''] for j in range(len(graph.list_vertex))]

	# Index guide for the matrix list_nodes:
	vertex_index 			= 0
	visited_index 			= 1
	shortest_distance_index = 2
	previous_node_index 	= 3
	# computational_matrix_data[vertex_index][visited_index][shortest_distance_index][previous_node_index]


	# The shortest distance for the source node must be 0. Since, it's already there!
	computational_matrix_data[int(departure_node.id)][shortest_distance_index]  = 0
	computational_matrix_data[int(departure_node.id)][previous_node_index] 		= '0'


	shortest_dist_path = 1000000
	current_vertex 	   = departure_node


	for k in range(len(computational_matrix_data)):
		shortest_dist_path = 1000000
		for node in computational_matrix_data:
			if (node[shortest_distance_index] < shortest_dist_path) and (node[visited_index] == False):
				shortest_dist_path  = node[shortest_distance_index]
				path_vertex	    = node[vertex_index]
		
		computational_matrix_data[int(path_vertex.id)][visited_index] = True
		
	
		for neighbor in path_vertex.get_neighbors_distances():
			# neighbor[0] : returns an object Vertex. Returns a neighbor our current vertex. 
			# neighbor[1] : returns the distance of the arc between our current vertex and it's neighbor.
			# See Vertex class in Vertex.py for more info.
			neighbor_distance_from_source = shortest_dist_path + neighbor[1]
			current_distance_neighbor_source = computational_matrix_data[int(neighbor[0].id)][shortest_distance_index]
			
			# If the new distance calculated with our path is less than it's know distance, update the distance.
			if(neighbor_distance_from_source < current_distance_neighbor_source) and (computational_matrix_data[int(neighbor[0].id)][visited_index] == False):
				computational_matrix_data[int(neighbor[0].id)][shortest_distance_index] = neighbor_distance_from_source
				computational_matrix_data[int(neighbor[0].id)][previous_node_index]		= str(path_vertex.id)

	
	
	nodes 				 = [ computational_matrix_data[i][vertex_index] for i in range(len(computational_matrix_data))]
	shortest_distances   = [ computational_matrix_data[i][shortest_distance_index] for i in range(len(computational_matrix_data))]
	fastest_paths        = [ stringify_path(computational_matrix_data, i, int(departure_node.id)) for i in range(len(computational_matrix_data))]
	fastest_paths_matrix = [ [nodes[i], shortest_distances[i], fastest_paths[i]] for i in range(len(computational_matrix_data))]


	# fastest_paths_matrix is a 3x21 matrix in the scope of our assignment.
	# the first  column contains all the vertices. 									[Object type: Vertex. (See Vertex class in Vertex.py file)]
	# the second column contains all the shortest distances for the i-th vertex 	[Object type: integer]
	# the third  column contains the shortest path. From departure to destination.	[Object type: string]
	return fastest_paths_matrix



