from email.policy import default
from time import time
import heapq
import sys
import copy
import os
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description="TP1 INF8775")
    parser.add_argument(
        "-e",
        "--exemplaire",
        dest="input",
        required=True,
        type=str,
        help="Fichier contenant l'exemplaire à utiliser.",
    )
    parser.add_argument(
        "-p",
        action="store_true",
        dest="p",
        help="""
                        Afficher, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse
                    """,
    )
    parser.add_argument(
        "-t",
        action="store_true",
        dest="t",
        help="Affiche le temps d’exécution en millisecondes",
    )
    parser.add_argument(
        "-b", action="store_true", dest="b", help="Print both energy and solution."
    )
    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(0)

    return parser.parse_args()

def parse_input(file):
    with open(file, "+r") as input_file:
        lines = [l for l in (line.strip() for line in input_file) if l]
        site_count, type_count, edge_count = map(lambda x: int(x), lines[0].split(" "))
        type_amounts = [int(x) for x in lines[1].split(" ")]

        cost_matrix = []
        link_graph = {}

        for i in range(site_count):
            link_graph[i] = []

        for i in range(type_count):
            cost_matrix.append([int(x) for x in lines[2 + i].split(" ")])

        for i in range(edge_count):
            edge = lines[type_count + i + 2].split(" ")
            first_vertex, second_vertex = int(edge[0]), int(edge[1])
            link_graph[first_vertex].append(second_vertex)
            link_graph[second_vertex].append(first_vertex)

        return site_count, type_count, type_amounts, cost_matrix, link_graph

class Node:
    def __init__(self, state: list[list[int]], parent_id: str, site: int, type: int, is_root=False):
        self.site = site
        self.type = type
        self.state = state
        self.id = parent_id + str(site) + str(type) if not is_root else ""
        self.is_root = is_root
        self.set_state()

    def set_state(self):
        if self.is_root: 
            return

        for i in range(len(self.state[self.site])):
            self.state[self.site][i] = 1 if i == self.type else 0

    def get_site_types(self):
        site_types = [None for _ in range(len(self.state))]
        for i, site in enumerate(self.state):
            for j, type in enumerate(site):
                if type is not None and type == 1:
                    site_types[i] = j
        return site_types

    def compute_cost(self, cost_matrix, graph: dict):
        self.total_cost = 0
        site_types = self.get_site_types()

        index = 0
        for vertex in graph:
            edges = graph[vertex]
            if site_types[vertex] is None:
                continue

            for edge in edges:
                if edge <= index or site_types[edge] is None:
                    continue
                self.total_cost += cost_matrix[site_types[vertex]][site_types[edge]]
            index += 1
        

    def check_validity(self, type_amounts, type_count):
        site_types = self.get_site_types()
        site_type_counts = [0 for _ in range(type_count)]
        for i in range(len(site_types)):
            if site_types[i] is not None:
                site_type_counts[site_types[i]] += 1

        for i in range(len(site_type_counts)):
            if site_type_counts[i] > type_amounts[i]:
                self.valid = False
                return

        self.valid = True

    def print(self):
        site_types = self.get_site_types()
        print("".join(str(type + 1) for type in site_types))

    # For minheap:
    def __lt__(self, other_node):
        return self.total_cost < other_node.total_cost


def print_solution(best, args, start_time):
    if args.b:
        print("Solution:")
        best.print()
        print(f"Total cost: {best.total_cost}\n")
    elif args.p:
        best.print()
    else:
        print(best.total_cost)

    if args.t:
        print("Time: ", (time() - start_time) * 1000, "ms\n")


def main():
    args = parse_args()

    if not (os.path.isfile(args.input)):
        print("Le fichier entré n'est pas valid ou n'existe pas...")
        sys.exit(-1)

    site_count, type_count, type_amounts, cost_matrix, link_graph = parse_input(
        args.input
    )
    default_state = [[None for _ in range(type_count)] for _ in range(site_count)]
    # Create the first set of state nodes, expanded for each type and check their validity and cost.
    # TODO FIX:

    visited_nodes = []
    start_time = time()
    # while True:
    next_node = Node(copy.deepcopy(default_state), "", 0, 0, is_root=True)
    next_node.compute_cost(cost_matrix, link_graph)
    next_node.check_validity(type_amounts, type_count)

    for site in range(site_count):
        nodes = []
        for type in range(type_count):
            node = Node(copy.deepcopy(next_node.state), next_node.id, site, type)
            node.check_validity(type_amounts, type_count)
            node.compute_cost(cost_matrix, link_graph)
            if node.valid: 
                heapq.heappush(nodes, node)
        next_node = heapq.heappop(nodes)
        while next_node.id in visited_nodes:
            if len(nodes) == 0:
                print("No more solutions")
                return
            next_node = heapq.heappop(nodes)
        visited_nodes.append(next_node.id)
    print_solution(next_node, args, start_time)

if __name__ == "__main__":
    main()
