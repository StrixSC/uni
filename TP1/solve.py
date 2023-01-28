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

#for num in ensemble:
#    crypted = rsa(num)
#    if crypted in chiffre_cherche:
#            print("Plaintext: {0} - {1}\nCiphertext: {2}".format(num, alphabet[num-1],crypted))
#
for num in ensemble:
    print("Message: {0}, Chiffrement: {1}".format(num, rsa(num)))
