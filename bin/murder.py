#!/usr/bin/env python
import subprocess, re , signal, os, sys

def kill_by_name(proc):
  ps = subprocess.Popen(['ps', '-ef'], stdout=subprocess.PIPE)
  out, err = ps.communicate()

  for line in out.splitlines():
    if proc in line and not "grep" in line:
      pieces = re.split("\s+", line)
      pid = int(pieces[1])
      print("killing "+proc+" : "+str(pid))
      os.kill(pid, signal.SIGKILL)

if len(sys.argv) > 1 :
  proc = sys.argv[1]
  kill_by_name(proc)
else:
  print("Please supply a binary name to kill")
