import argparse
import sys

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

    args = parser.parse_args()
    algo = args.algo
    input = args.input
    p = args.p
    t = args.t
    
    print("Algo: ", algo, "Input: ", input, "p: ", p, "t: ", t)

if __name__ == "__main__":
    main()