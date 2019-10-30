#############################################################################
##### 	STRUCTURES DISCRETES - LOG2810									#####
#####	Travail réalisé par Ragib Ahashan, Pritam Patel, Nawras Kader	#####
#####	Travail Pratique 1												#####
#####	Version de Python utilisé: 3.7.3								#####
#############################################################################


# Le format représenté dans le fichier externe entrepot.txt est le format d'un CSV file.

import csv


class Vertix:
    def __init__(self, vertix_id, objectsA, objectsB, objectsC):
        self.id = vertix_id
        self.numberObjectsA = objectsA
        self.numberObjectsB = objectsB
        self.numberObjectsC = objectsC
    
x = Vertix(1,2,4.5)
x.id, x.numberObjectsA

liste_noeuds = []

with open('entrepot.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            print(f'Column names are {", ".join(row)}')
            line_count += 1
        else:
            print(f'\t{row[0]} works in the {row[1]} department, and was born in {row[2]}.')
            line_count += 1
    print(f'Processed {line_count} lines.')


