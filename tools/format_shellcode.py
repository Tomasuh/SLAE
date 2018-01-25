#!/usr/bin/python

import sys,os

stream = os.popen(os.path.dirname(os.path.realpath(__file__))+'/shellcode.sh ' + os.getcwd()+"/"+sys.argv[1])


shellcode = stream.read()

print "Python style shellcode:"
print shellcode

shellcode = shellcode.strip("\n\"")
shellcode = shellcode.replace("\\","")
input = shellcode
theList = input.split("x")
out = ""
for value in theList:
	if value != '':
		out += "0x" + value + ","

print "NASM stylish:"
print out[:-1]

