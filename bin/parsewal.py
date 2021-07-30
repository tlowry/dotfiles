#!/usr/bin/python3
import json, sys, subprocess

if len(sys.argv) < 2:
    print ("use vuwal <pywal_theme.json>")
    sys.exit()

file=sys.argv[1]

# call scol script to get shell code for hex color
def scol(code):
    result = subprocess.run(['scol', code], stdout=subprocess.PIPE)
    col=result.stdout.decode('utf-8')
    return col

# print name, hex, and term color value for each code
def print_cols(cols):
    for k in cols:
        code=cols[k]
        print(k+" "+code+" "+scol(code))

with open(file) as f:
    data = json.load(f)

    if "special" in data:
        spec = data["special"]
        print_cols(spec)

    if "colors" in data:
        cols=data["colors"]
        print_cols(cols)

