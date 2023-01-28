#!/bin/bash

./signature.sh

FOLDER="out"
rm -rf $FOLDER
mkdir $FOLDER

for i in {0000..9999}
do
    ./transBase.py $i > $FOLDER/$i.out && echo "$EOF" && cat $FOLDER/$i.out | ./recepBase.py
done