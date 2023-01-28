#!/usr/bin/python

import string

e=449
N=224117
plaintext=[]
alphabet_string = string.ascii_uppercase
alphabet=list(alphabet_string)
ensemble=list(range(0,26))

ciphertext="FLHFLNBHFOFC@BXHXGTCLHJVS@XLAHXVHRTJVNTHXGTHTPTJSXCV@TLBHVDHXGTCLHDLCT@QBHF@QHRLTXGLT@HVLHXVHDFZZHXGTNBTZETBHRAHXGTCLHGF@QBHHGTHGFBHTPJCXTQHQVNTBXCJHC@BSLLTJXCV@BHFNV@OBXHSBHF@QHGFBHT@QTFEVSLTQHXVHRLC"

def caesar(message, shift, length):
    plaintext=""
    for letter in message:
        if letter == "@":
            plaintext = plaintext + " "
            continue
        plaintext = plaintext + alphabet[(alphabet.index(letter) + shift) % length]
    return plaintext

for i in range(len(ensemble)):
    deciphered = caesar(ciphertext, i, len(ensemble))
    print("Tentative #{0}: {1}".format(i, deciphered))
