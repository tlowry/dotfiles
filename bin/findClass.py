#!/usr/bin/env python
import argparse
import os
import re
import subprocess
from subprocess import Popen, PIPE

# Script to hunt down corresponding jars for missing classes 
# example : findClass.py /folderOfJars -q -n org.apache.log4j.Logger

parser = argparse.ArgumentParser(description="Find a java class within a given directory: findClass.py")
parser.add_argument("-n","--name",type=str, help="java classname to search for",default="class")
parser.add_argument("-q","--quit",dest="quit", help="quit on finding the first match",action='store_true')
parser.add_argument('dir', nargs='?',help="the directory to search", default=os.getcwd())
args = parser.parse_args()

searchClass = args.name.replace(".","/")
quit = args.quit
finished = False

for root, dirs, files in os.walk(args.dir, topdown=True):
    for name in files:
        full_name = os.path.join(root, name)
        match = re.search(".+\.(jar|zip)",full_name)
        if match:
            jarProc = subprocess.Popen(["jar","-tf",full_name], stdout=PIPE, stderr=PIPE)
            session = subprocess.Popen(["grep",searchClass],stdin=jarProc.stdout, stdout=PIPE, stderr=PIPE)
            stdout = session.stdout
            line = stdout.readline()
            while line and not finished:
                if isinstance(line,bytes):
                    line = line.decode(encoding='utf-8', errors='strict')

                line = line.rstrip("\n")
                if len(line) > 0:
                    print(full_name+" "+line)

                line = stdout.readline()

                # quit on first file found if -q specified
                if quit:
                    finished = True

        if finished:
            break

    if finished:
        break
