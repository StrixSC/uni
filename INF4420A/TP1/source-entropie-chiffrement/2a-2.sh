#!/bin/bash

./texte 200 | ./cesar > texte.enc && echo "Version encodée: " && cat texte.enc && echo "$EOF" && (cat texte.enc | ./cesar-d) > texte.txt && echo "Version décodée: " &&  cat texte.txt
