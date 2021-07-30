#!/usr/bin/env python
import subprocess, re , signal, os, sys

def add_files(dir_name):
    for root, dirs, files in os.walk(dir_name, topdown=True):
        for name in files:
            full_name = os.path.join(root, name)
            match = re.search("CVS",full_name)
            if not match:
                # not in a cvs related directory, we can add it
                ps = subprocess.Popen(['cvs', 'add', full_name], stdout=subprocess.PIPE)
                out, err = ps.communicate()

if len(sys.argv) > 1 :
  add_files(sys.argv[1])
else:
  print("Please supply a cvs controlled directory to add files from")
