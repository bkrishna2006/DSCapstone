# -*- coding: utf-8 -*-
"""
Created on Wed Aug 29 09:47:51 2018
@author: Balaji_KrishnaIyer
"""
    
''' Program to set the environment and create small chunks of sample files'''
# set the current working directory

%reset -f

import datetime
PgmStart = datetime.datetime.now()
print("Execution started...",PgmStart,"\n")

DatasetFolder = "D:/DataScienceCapstonePy"
#DatasetName = "DSCapstoneR"

myScriptsDir = DatasetFolder + "/Scripts"
myRawDataDir = DatasetFolder + "/RawData"
myRefDataDir = DatasetFolder + "/RefData"
mySampleDataDir = DatasetFolder + "/SampleDataTest"
myGenDataDir = DatasetFolder + "/GenData"
myReportsDir = DatasetFolder + "/Reports"

import os
os.chdir(mySampleDataDir)
os.getcwd() 

print("Current working directory: ",os.getcwd(), "\n")
print("Contents of directory: ", os.listdir(),"\n")

#myFileName = "en_US.twitter_small" 
myFileName = "news_small" 
myFile = myFileName + ".txt"

# Shuffling the contents
#import random
#with open(myFileName, encoding="utf-8") as f:
#    lines=f.read()
#random.shuffle(lines)

with open(myFile, encoding="utf-8") as f:
    content = f.read()
    nRows = content.count("\n") + 1

nChunks = 3

if (nRows and nChunks == 0):
  lineCount= round(nRows/nChunks)
elif (nRows and nChunks != 0):
  lineCount= round(nRows/nChunks)
  nChunks <- nChunks + 1
print("nRows: ",nRows)
print("nChunks: ",nChunks)
print("lineCount: ",lineCount)

from itertools import islice
import io
with open(myFile,'r',encoding='utf-8') as f:   
    for i in range(1,nChunks + 1):            
        if (i == 1):
            smpl_content = list(islice(f,lineCount))
            with io.open(myFileName + "Sample" + str(i) + ".txt", 'w', 
                         encoding='utf-8') as fw:
                fw.write(str(smpl_content))
        elif (i > 1):
            smpl_content = list(islice(f,lineCount))
            with io.open(myFileName + "Sample" + str(i) + ".txt", 'w', 
                         encoding='utf-8') as fw:
                fw.write(str(smpl_content))
PgmEnd = datetime.datetime.now()
print("Execution ended...",PgmEnd,"\n")
ExecTime = PgmEnd - PgmStart
print("Execution time: ", ExecTime,"\n")
        


