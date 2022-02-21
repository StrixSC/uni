import argparse
import sys
import os

def checkFile(file: str) -> bool:
    return os.path.isfile(file)

def main():
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

    args = parser.parse_args()
    algo = args.algo
    input = args.input
    p = args.p
    t = args.t
    
    if(algo not in ['brute', 'recursif', 'seuil']):
        print("Mauvais algo, choisir parmis: 'brute', 'recursif', 'seuil'...")
        sys.exit(-1)
        
    if(not (os.path.isfile(input))):
        print("Input file is not good.")
        sys.exit(-1)
    
    print("Algo: ", algo, "Input: ", input, "p: ", p, "t: ", t)

if __name__ == "__main__":
    main()