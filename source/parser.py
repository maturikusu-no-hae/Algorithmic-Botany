import os
import re
destination = open("../algorithmicbotany.pde", "w")
pattern = re.compile(r'public\s+class')
path = "./"

def parse(file, destination):
  with open(file, 'r') as f:
    for line in f.readlines():
      if pattern.match(line):
        destination.write(re.sub('public', '', line))
        continue
      symbol_position = line.find("/*~")
      if symbol_position >= 0:
        destination.write(line[0:symbol_position] + line[symbol_position + 4:len(line)])
        continue
      symbol_position = line.find("~*/")
      if symbol_position >= 0:
        destination.write(line[0:symbol_position] + line[symbol_position + 4:len(line)])
        continue
      else:
        destination.write(line)

parse ('source.pde', destination)
for root, dirs, files in os.walk(path):
  for fp in  files:
    if (fp == "source.pde"):
      continue
    parse(fp, destination)
destination.close()