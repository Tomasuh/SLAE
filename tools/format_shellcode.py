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
for shit in theList:
	if shit != '':
		out += "0x" + shit + ","
		#print shit
		#print out

print "NASM stylish:"
print out[:-1]

