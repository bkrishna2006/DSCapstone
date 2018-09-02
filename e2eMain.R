# Main Program that calls the other programs in an order

#DatasetFolder <- "/home/bkrishna2006_gmail_com/"
#DatasetName <- "DSCapstoneR"

#myScriptsDir <- paste0(DatasetFolder,DatasetName,"/Scripts")
#myRawDataDir <- paste0(DatasetFolder,DatasetName,"/RawData")
#myRefDataDir <- paste0(DatasetFolder,DatasetName,"/RefData")
#mySampleDataDir <- paste0(DatasetFolder,DatasetName,"/SampleData")
#myGenDataDir <- paste0(DatasetFolder,DatasetName,"/GenData")
#myReportsDir <- paste0(DatasetFolder,DatasetName,"/Reports")

DatasetFolder <- "D:/DSCapstoneRNew"
DatasetName <- "DSCapstoneR"

myScriptsDir <- paste0(DatasetFolder,"/Scripts")
myRawDataDir <- paste0(DatasetFolder,"/RawData")
myRefDataDir <- paste0(DatasetFolder,"/RefData")
mySampleDataDir <- paste0(DatasetFolder,"/SampleData")
myGenDataDir <- paste0(DatasetFolder,"/GenData")
myReportsDir <- paste0(DatasetFolder,"/Reports")

setwd(myScriptsDir)
iteration = "00"
source("e2e.R")