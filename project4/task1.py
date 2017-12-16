#!/usr/bin/env python3

import sys
import os
import numpy
import numpy.linalg
import scipy.misc

def getOutputPngName(path, rank):
    filename, ext = os.path.splitext(path)
    return filename + '.' + str(rank) + '.png'

def getOutputNpyName(path, rank):
    filename, ext = os.path.splitext(path)
    return filename + '.' + str(rank) + '.npy'

if len(sys.argv) < 3:
    sys.exit('usage: task1.py <PNG inputFile> <rank>')

inputfile = sys.argv[1]
rank = int(sys.argv[2])
outputpng = getOutputPngName(inputfile, rank)
outputnpy = getOutputNpyName(inputfile, rank)

image = scipy.misc.imread(inputfile)
U, s, V = numpy.linalg.svd(image)
new_img = numpy.matmul(numpy.matmul(U[:, :rank], numpy.diag(s[:rank])), V[:rank, :])

numpy.save(outputnpy, new_img)
scipy.misc.imsave(outputpng, new_img)

