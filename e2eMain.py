# -*- coding: utf-8 -*-
"""
Created on Thu Aug 30 14:31:31 2018

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
os.chdir(myScriptsDir)

#import Test
#exec(open("Test.py").read())

iteration=1
import e2e
exec(open("e2e.py").read())

PgmEnd = datetime.datetime.now()
print("Execution ended...",PgmEnd,"\n")
ExecTime = PgmEnd - PgmStart
print("Execution time: ", ExecTime,"\n")