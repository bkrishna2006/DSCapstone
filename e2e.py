# -*- coding: utf-8 -*-
"""
Created on Thu Aug 30 15:05:24 2018

@author: Balaji_KrishnaIyer
"""

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
print("Current Working Directory: ", os.getcwd(),"\n")

from os import listdir
from os.path import isfile, join 
import glob
import time
iteration=1
myNewDataFiles =  glob.glob("*Sample" + str(iteration) + ".txt")
myNewDataFiles

print("Files about to be read in this iteration(myNewDataFiles): ","\n",myNewDataFiles,"\n")
time.sleep(3)
startTime = datetime.datetime.now()
print("Reading Sample file sets one by one ....","\n")
time.sleep(3)

import pandas as pa

def readFile(myList):
    for i in range(0,len(myList)):
        with open(myList[i], 'r', encoding="utf-8") as f:
            for line in f:
                myContent=pa.DataFrame(line)
#                print("hi")
            
#    with open(str('en_US.twitter_smallSample1.txt'), 'r', encoding="utf-8") as f:
#        content=f.read()
    
i=0
with open(myNewDataFiles[i],'r',encoding="utf-8") as f:
        for line in f:
            myContent=pa.DataFrame(line)
#            print(line)

myNewDataset = list(map(readFile,myNewDataFiles))
#next(myNewDataset)
#myNewDataset

#import Test
#exec(open("Test.py").read())

#import e2e
#exec(open("e2e.py").read())

PgmEnd = datetime.datetime.now()
print("Execution ended...",PgmEnd,"\n")
ExecTime = PgmEnd - PgmStart
print("Execution time: ", ExecTime,"\n")