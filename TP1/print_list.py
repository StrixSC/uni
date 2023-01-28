#!/usr/bin/python

import string

e=449
N=224117
plaintext=[]
alphabet_string = string.ascii_uppercase
alphabet=list(alphabet_string)
ensemble=list(range(0,26))
chiffre_cherche=[72268,22820,183139,33258,75958]

def rsa(number):
    return (number**e) % N

for num in ensemble:
    print("Message: {0}, Lettre: {1}, Chiffrement: {2}".format(num, alphabet[num], rsa(num)))

