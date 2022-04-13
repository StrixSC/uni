from cmath import inf
from multiprocessing.spawn import get_preparation_data
from operator import ne
from random import randint
from time import time
import heapq
import sys
import copy
import os
import argparse

from Node import Node


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
        help="""Afficher, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse""",
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

def solve_bnb(site_count, cost_matrix, link_graph, type_amounts, type_count):
    default_state = {}
    for i in range(site_count):
        default_state[i] = None

    min = inf
    best = None

    next_node = Node(copy.deepcopy(default_state), 0, 0, is_root=True)
    next_node.compute_cost(cost_matrix, link_graph)
    next_node.check_validity(type_amounts, type_count)

    for site in range(site_count):
        nodes = []
        for type in range(type_count):
            node = Node(copy.deepcopy(next_node.state), site, type, is_root=False)
            node.check_validity(type_amounts, type_count)
            node.compute_cost(cost_matrix, link_graph)
            if node.valid:
                heapq.heappush(nodes, node)
        next_node = heapq.heappop(nodes)
    if next_node.total_cost < min:
        best = next_node
        min = best.total_cost
    
    return best

def main():
    args = parse_args()

    if not (os.path.isfile(args.input)):
        print("Le fichier entré n'est pas valid ou n'existe pas...")
        sys.exit(-1)

    site_count, type_count, type_amounts, cost_matrix, link_graph = parse_input(
        args.input
    )

    all_types = copy.deepcopy(type_amounts)
    print(all_types)
    random_solution = {}
    for i in range(site_count):
        random_solution[i] = -1

    for site in range(site_count):
        random_type = randint(0, type_count - 1)
        while(all_types[random_type] == 0):
            random_type = randint(0, type_count - 1)
        random_solution[site] = random_type
        all_types[random_type] -= 1

    best = Node(random_solution, 0, 0, is_root=True)
    best.compute_cost(cost_matrix, link_graph)
    best.check_validity(type_amounts, type_count)
    print(best.get_solution())
    print(best.total_cost)
    while True:
        for vertex, edges in link_graph.items():    
            neighbours = best.create_neighbour(vertex, edges)
            for n in neighbours:
                n.compute_cost(cost_matrix, link_graph)
                if n.total_cost < best.total_cost:
                    best = n
                    print(best.get_solution())
                    print(best.total_cost)

if __name__ == "__main__":
    main()
