#!/bin/python3

# Script to create the HEX of a string for scalpel


import sys

def hexify(string):
    hexified = ""

    for c in string:
        h = "\\"
        h += hex(ord(c))[1:]
        hexified += h
        
    return hexified

if len(sys.argv) == 1:
    print("USAGE: {} STRING(S)_TO_HEXIFY...".format(sys.argv[0]))
    sys.exit(1) 

for arg in sys.argv[1:]:
    print(hexify(arg))
