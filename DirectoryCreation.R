DatasetName <- "DSCapstoneR"

myScriptsDir <- paste0("D:/",DatasetName,"/Scripts")
myRawDataDir <- paste0("D:/",DatasetName,"/RawData")
myRefDataDir <- paste0("D:/",DatasetName,"/RefData")
mySampleDataDir <- paste0("D:/",DatasetName,"/SampleData")
myGenDataDir <- paste0("D:/",DatasetName,"/GenData")
myReportsDir <- paste0("D:/",DatasetName,"/Reports")

if (!exists()){
  dir.create(myScriptsDir)
  dir.create(myRawDataDir)
  dir.create(myRefDataDir)
  dir.create(mySampleDataDir)
  dir.create(myGenDataDir)
  dir.create(myReportsDir)
}
