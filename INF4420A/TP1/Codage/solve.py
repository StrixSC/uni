#!/usr/bin/python3
import subprocess

subprocess.run(['./signature.sh'])

for i in range(1,2):
    subprocess.run(['./transBase.py', f"{i:04d}", '|', './recepBase.py'])
