from cmath import inf
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


def main():
    args = parse_args()

    if not (os.path.isfile(args.input)):
        print("Le fichier entré n'est pas valid ou n'existe pas...")
        sys.exit(-1)

    site_count, type_count, type_amounts, cost_matrix, link_graph = parse_input(
        args.input
    )

    default_state = {}
    for i in range(site_count):
        default_state[i] = None

    # Create the first set of state nodes, expanded for each type and check their validity and cost.
    # TODO FIX:

    visited_nodes = []
    start_time = time()
    best = None
    min = inf
    while True:
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
            next_node = nodes[randint(0, len(nodes) - 1)]
            # while next_node.id in visited_nodes:
            # if len(nodes) == 0:
            # print("No more solutions")
            # return
            # next_node = heapq.heappop(nodes)
        if next_node.total_cost < min:
            best = next_node
            min = best.total_cost
            print_solution(best, args, start_time)


if __name__ == "__main__":
    main()
