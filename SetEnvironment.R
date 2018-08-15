DatasetFolder <- "D:/DSCapstoneR"
DatasetName <- "Set1"


myScriptsDir <- paste0("D:/",DatasetName,"/Scripts")
myRawDataDir <- paste0("D:/",DatasetName,"/RawData")
myRefDataDir <- paste0("D:/",DatasetName,"/RefData")
mySampleDataDir <- paste0("D:/",DatasetName,"/SampleData")
myGenDataDir <- paste0("D:/",DatasetName,"/GenData")
myReportsDir <- paste0("D:/",DatasetName,"/Reports")

# Sample size for the timebeing is set to 2.5 % - as input for DataEngineering.R program
sampleSize <- 0.025
# Seed value for TextMining program 
seedValue <- 08142018
# Define the number of top n-grams to be shown in barcharts in N-gramCreation.R program.
topN = 10
