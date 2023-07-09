import subprocess

def tchecker(app_path):
    p = subprocess.run(args=["./phpjoern/php2ast", app_path], stdout=None, stderr=None)
    if p.returncode == 0:
        p = subprocess.run(args=["./phpast2cpg", "."], stdout=subprocess.PIPE)
        out = p.stdout.decode()
        print(out)
        res = open("result.txt", "w", encoding="utf-8")
        res.write(out)
        res.flush()

import sys

if len(sys.argv) < 2:
    print("Usage: tchecker <app_path>")
else:
    app_path = sys.argv[1]
    tchecker(app_path)