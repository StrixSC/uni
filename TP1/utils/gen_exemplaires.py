import subprocess

for n in ["10", "1000","5000","10000","50000","100000","500000"]:
    subprocess.call("python inst_gen.py -s {} -n 5".format(n))