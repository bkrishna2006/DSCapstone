DatasetFolder <- "D:/DSCapstoneRNew"

#mySampleDataDir <- paste0(DatasetFolder,DatasetName,"/SampleData")
mySampleDataDir <- paste0(DatasetFolder,"/SampleDataTest")

setwd(mySampleDataDir)
#myCon <- file(description = "newsSample.txt",method = "r")
#myCon <- file(description = "smalltestfile.txt",method = "r")
myCon <- file(description = "newsSample.txt",method = "r")
newsSampleBef <- readLines(con = myCon, skipNul = T)
nRows=length(newsSampleBef)
newsSample <- sample(newsSampleBef,size = nRows)

nChunks <- 3

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
    newsChunks[[i]] <- scan(file = myCon,
                       encoding = "Latin-1",
                       what = "character",
                       nlines = lineCount, 
                       skip = 0, 
                       skipNul = T)  
  } else if (i>1){
    newsChunks[[i]] <- scan(file = myCon,
                       encoding = "Latin-1",
                       what = "character",
                       nlines = lineCount,
                       skip = lineCount*(i-1),
                       skipNul = T)  
}
  }


newsChunks
newsChunksNew <- print(unlist(newsChunks))
for (i in 1:nChunks) {
  newsChunksNew <- print(unlist(newsChunks[[i]]))
  write(newsChunksNew,file = paste0("newsSample",i, ".txt"))
}
close(myCon)
