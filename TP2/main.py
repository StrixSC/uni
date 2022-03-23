#!/usr/bin/python
import argparse
import sys
import os

from Tower import Tower
from Block import Block

def parse_args():
    parser = argparse.ArgumentParser(description='TP2 INF8775')
    parser.add_argument('-a', '--algorithm', dest='algo', required=True, type=str, help="Algorithme à utiliser. Choix disponibles: 'glouton', 'progdyn', 'tabou'")
    parser.add_argument('-e', '--exemplaire', dest='input', required=True, type=str, help="Fichier contenant l'exemplaire à utiliser.")
    parser.add_argument('-p', action='store_true', dest='p', help="""
                        Afficher, sur chaque ligne, les couples définissant la silhouette de bâtiments, triés selon l’abscisse
                    """)
    parser.add_argument('-t', action='store_true', dest='t', help="Affiche le temps d’exécution en millisecondes")
    parser.add_argument('-H', '--height', action='store_true', dest='height', help="Affiche la taille total de la tour finale")
    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(0)

    return parser.parse_args()

"""_summary_
Retourne une liste de Blocks contenant les valeurs de longueur, profondeur et hauteur pour chaque donnée obtenu par l'exemplaire.
"""
def generate_blocks(file):
    blocks = []
    
    with open(file, mode='r') as f:
        for line in f.readlines():
            split = line.strip().split(' ')
            blocks.append(Block(int(split[0]), int(split[1]), int(split[2])))
    return blocks

def main():
    args = parse_args()

    if not (os.path.isfile(args.input)):
        print("Le fichier entré n'est pas valid ou n'existe pas...")
        sys.exit(-1)

    tower = Tower()
    solved, height, time = tower.solve(blocks=generate_blocks(args.input), algorithm=args.algo)
    
    if args.height:
        print("Total Height:", height)
    
    if args.t:
        print(time * 1000)
    
    if args.p:
        for block in solved:
            block.print()
    
    exit(0)
    
if __name__ == "__main__":
    main()
