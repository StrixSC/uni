from pprint import pprint
import copy
class Node:
    def __init__(self, state: dict, site: int, type: int, is_root=False):
        self.site = site
        self.type = type
        self.state = state
        self.is_root = is_root
        if not self.is_root: 
            self.state[site] = type

    def compute_cost(self, cost_matrix, graph):
        self.total_cost = 0
        index = 0
        for vertex, edges in graph.items():
            if self.state[vertex] is None:
                continue
            
            for edge in edges:
                if edge <= index or self.state[edge] is None:
                    continue
                self.total_cost += cost_matrix[self.state[vertex]][self.state[edge]]
            index += 1

        # for site, type in self.state.items():
        #     if type is None:
        #         edges = graph[site]
        #         for edge in edges:
        #             if self.state[edge] is not None:
        #                 cost = min(cost_matrix[self.state[edge]])
        #                 print(f"min cost for site {site} with edge {edge} is {cost}")
        #                 self.total_cost += cost

    def check_validity(self, type_amounts, type_count):
        site_type_counts = [0 for _ in range(type_count)]
        for _, type in self.state.items():
            if type is not None:
                site_type_counts[type] += 1

        for i in range(len(site_type_counts)):
            if site_type_counts[i] > type_amounts[i]:
                self.valid = False
                return

        self.valid = True

    def create_neighbour(self, k: int, edges: list):
        nodes = []
        for edge in edges:
            if edge < k:
                continue

            node = Node(copy.deepcopy(self.state), 0, 0, is_root=True)
            tmp = node.state[k]
            node.state[k] = node.state[edge]
            node.state[edge] = tmp
            attempting_solution = node.get_solution()
            solution = self.get_solution()

            if attempting_solution != solution:
                nodes.append(node)

        return nodes
        
    def get_solution(self):
        return " ".join([str(type) for _, type in self.state.items()])
        
    def __lt__(self, other_node):
        return self.total_cost < other_node.total_cost
