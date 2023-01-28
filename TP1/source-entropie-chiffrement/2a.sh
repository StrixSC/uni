#!/bin/bash

./lettre 200 | ./cesar > lettre.enc && echo "Version encodée: " && cat lettre.enc && echo "$EOF" && (cat lettre.enc | ./cesar-d) > lettre.txt && echo "Version décodée: " &&  cat lettre.txt
