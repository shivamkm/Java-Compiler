import sys
import os

fhand = open("nikhil.y", "r")
for line in fhand:
    l = line.strip().split()
    if len(l) > 1 and l[1].strip() == ":":
        print("%type <str>", l[0])

fhand.close()
