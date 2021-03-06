import os
import re
import sys

path = "../"
if len(sys.argv) > 1:
    path = sys.argv[1]

destination = open(path + "algorithmicbotany.pde", "w")
pattern = re.compile(r'public.*class')
path += "source/"


def parse(fp, destination):
    with open(fp, 'r') as f:
        for line in f.readlines():
            if pattern.match(line):
                destination.write(re.sub('public ', '', line))
                continue
            symbol_position = line.find("/*~")
            if symbol_position >= 0:
                destination.write(
                    line[0:symbol_position] +
                    line[symbol_position + 3:len(line)])
                continue
            symbol_position = line.find("~*/")
            if symbol_position >= 0:
                destination.write(
                    line[0:symbol_position] +
                    line[symbol_position + 3:len(line)])
                continue
            symbol_position = line.find("/*!-*/")
            if symbol_position >= 0:
                destination.write(
                    line[0:symbol_position + 2] +
                    line[symbol_position + 6:len(line)])
                continue
            symbol_position = line.find("/*-!*/")
            if symbol_position >= 0:
                destination.write(
                    line[0:symbol_position] +
                    line[symbol_position + 4:len(line)])
                continue
            destination.write(line)


parse(path + "source.pde", destination)

for root, dirs, files in os.walk(path):
    for fp in files:
        if fp == "source.pde":
            continue
        parse(path + fp, destination)

destination.close()
