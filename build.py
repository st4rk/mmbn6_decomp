"""

Build Mega Man Battle Network 6 Gregar ROM

For now, we are using armips for testing and understand better the process


1. We build all .s files and create a new .gba
2. We check the sha1 of the base rom and the current rom
3. If it fails, we are generating wrong code and we need to review it.

"""


import os
import hashlib

ASSEMBLER = './armips '
COMMAND = ''
TARGET = 'base.s'

# source: https://www.programiz.com/python-programming/examples/hash-file
def hash_file(filename):
   """"This function returns the SHA-1 hash
   of the file passed into it"""
   # make a hash object
   h = hashlib.sha1()
   # open file for reading in binary mode
   with open(filename,'rb') as file:
       # loop till the end of the file
       chunk = 0
       while chunk != b'':
           # read only 1024 bytes at a time
           chunk = file.read(1024)
           h.update(chunk)
   # return the hex representation of digest
   return h.hexdigest()


print("[-] starting build")

BUILD_COMMAND = ASSEMBLER + COMMAND + TARGET

os.system(BUILD_COMMAND)

print("[-] build done, sha1sum check")

sha1_base = hash_file("base.gba")
sha1_output = hash_file("output_base.gba")

print("[-] base sha1: {0}".format(sha1_base))
print("[-] output sha1: {0}".format(sha1_output))

if sha1_base == sha1_output:
	print("[-] success build!")
else:
	print("[-] invalid code")
