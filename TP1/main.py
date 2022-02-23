#!/usr/bin/python
import argparse
import sys
import os

from Building import Building
from CriticalPoint import CriticalPoint
from Skyline import Skyline

def parse_args():
    parser = argparse.ArgumentParser(description='TP1 INF8775')
    parser.add_argument('-a', '--algorithm', dest='algo', type=str, help="Algorithme à utiliser. Choix disponibles: 'brute', 'recursif', 'seuil'")
    parser.add_argument('-e', '--exemplaire', dest='input', type=str, help="Fichier contenant l'exemplaire à utiliser.")
    parser.add_argument('-p', action='store_true', dest='p', help="""
                        Afficher, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse
                    """)
    parser.add_argument('-t', action='store_true', dest='t', help="Affiche le temps d’exécution en millisecondes")

    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(0)

    return parser.parse_args()

def generate_buildings(file):
    buildings = []
    
    with open(file, mode='r') as f:
        for line in f.readlines()[1:]:
            split = line.strip().split(' ')
            buildings.append(Building(int(split[0]), int(split[1]), int(split[2])))
    return buildings

def main():
    args = parse_args()
    
    if(not (os.path.isfile(args.input))):
        print("Le fichier entré n'est pas valid ou n'existe pas...")
        sys.exit(-1)
    
    skyline = Skyline(generate_buildings(args.input))
    solved, time = skyline.solve(algorithm=args.algo, p=args.p, seuil=100)
    
    if args.p:
        for cp in solved:
            print(cp.x, cp.height)
    
    if args.t:
        print("Temps: ", time * 1000)
    
    exit(0)
    
if __name__ == "__main__":
    main()
