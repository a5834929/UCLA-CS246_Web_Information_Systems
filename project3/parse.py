#!/bin/python

import os, sys, re


dict3 = {}
dirlist = os.listdir("0643")

for file in dirlist:
	print("parsing "+file+"...")
	words = [re.findall(r'[a-zA-Z]+',line) for line in open("0643/"+file)]
	words = [item for sublist in words for item in sublist]
	words = [word.lower() for word in words]

	for word in words:
		if word in dict3:
			dict3[word] += 1
		else:
			dict3[word] = 1

d = []
for line in open("dict1.txt"):
	d.append(line.strip("\n"))	


with open('dict3.txt', 'w') as file:
 	for key in d:
 		if key in dict3:
 			file.write(key+"\t"+str(dict3[key])+"\n")
 		else:
 			file.write(key+"\t"+"0"+"\n")