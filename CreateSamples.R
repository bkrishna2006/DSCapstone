rm(list = ls())
pgmStart <- Sys.time()
message("Execution started: ",Sys.time(),"\n")

#DatasetFolder <- "/home/bkrishna2006_gmail_com/"
#DatasetName <- "DSCapstoneR"

#myRawDataDir <- paste0(DatasetFolder,DatasetName,"/RawData")
#mySampleDataDir <- paste0(DatasetFolder,DatasetName,"/SampleData")

DatasetFolder <- "D:/DSCapstoneRNew"
#DatasetName <- "DSCapstoneR"

myScriptsDir <- paste0(DatasetFolder,"/Scripts")
myRawDataDir <- paste0(DatasetFolder,"/RawData")
myRefDataDir <- paste0(DatasetFolder,"/RefData")
mySampleDataDir <- paste0(DatasetFolder,"/SampleData")
myGenDataDir <- paste0(DatasetFolder,"/GenData")
myReportsDir <- paste0(DatasetFolder,"/Reports")

# Seed value for TextMining program
seedValue <- 08272018
# ******************************************************SetEnvironment.R

#source("DataEngineering.R")
# ******************************************************DataEngineering.R

setwd(myRawDataDir)
message("Current working directory: ",getwd(), "\n")
# for Linux
#system("split -n 99 -d --additional-suffix=.txt en_US.blogs.txt blogsSample")
#system("split -n 99 -d --additional-suffix=.txt en_US.news.txt newsSample")
#system("split -n 99 -d --additional-suffix=.txt en_US.twitter.txt twitterSample")

# for Windows
#setwd(mySampleDataDir)
setwd(myRawDataDir)
news <- file(description = "en_US.news.txt",method = "r")
#myCon <- file(description = "smalltestfile.txt",method = "r")
newsSampleBef <- readLines(con = news, skipNul = T)
nRows=length(newsSampleBef)
newsSample <- sample(newsSampleBef,size = nRows)
#newsSampleBef
#newsSample

nChunks <- 98

if (nRows%%nChunks==0){
  lineCount= round(nRows/nChunks)
} else if(nRows%%nChunks!=0){
  lineCount= round(nRows/nChunks)
  nChunks <- nChunks + 1
}

message(paste("nChunks: ",nChunks))
message(paste("lineCount: ",lineCount))
newsChunks <- vector('list',nChunks)

for (i in 1:nChunks) {
  if (i==1){
    newsChunks[[i]] <- scan(file = news,
                            encoding = "Latin-1",
                            what = "character",
                            nlines = lineCount, 
                            skip = 0, 
                            skipNul = T)  
  } else if (i>1){
    newsChunks[[i]] <- scan(file = news,
                            encoding = "Latin-1",
                            what = "character",
                            nlines = lineCount,
                            skip = lineCount*(i-1),
                            skipNul = T)  
  }
}

setwd(mySampleDataDir)

for (i in 1:nChunks) {
  newsChunksNew <- print(unlist(newsChunks[[i]]))
  write(newsChunksNew,file = paste0("newsSample",i, ".txt"))
    
}
close(news)


#newsChunksNew <- print(unlist(newsChunks))
#write.csv(newsChunksNew,file = "newsChunks.txt")

message("Finished splitting the files","\n")
Sys.sleep(3)


message("Moving files to Sample directory...","\n")
system(paste0("move ",myRawDataDir,"/*Sample*.txt ",mySampleDataDir))
message("Moved files to Sample directory...","\n")
Sys.sleep(3)
message("Contents of my Sample directory...","\n")
Sys.sleep(3)
setwd(mySampleDataDir)
#system("ls -l")
#message(list.files())
pgmEnd <- Sys.time()
execTime <- pgmEnd - pgmStart
message("Execution time: ",execTime,"\n")