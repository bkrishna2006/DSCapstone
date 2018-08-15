
# The sorted N-grams should be available

readRDS(paste0(myGenDataDir,"/Ngrams.RData"))

# Computing probabilities of each ngram occurance
library(dplyr)

df1 <- mutate(unigramDf_sorted,prob=round(freq/sum(freq),7))
df2 <- mutate(bigramDf_sorted,prob=round(freq/sum(freq),7))
df3 <- mutate(trigramDf_sorted,prob=round(freq/sum(freq),7))
df4 <- mutate(quadgramDf_sorted,prob=round(freq/sum(freq),7))

# drop all n-gram occurances where the probability is zero.
df1sel <- dplyr::filter(df1,prob != 0)
df2sel <- dplyr::filter(df2,prob != 0)
df3sel <- dplyr::filter(df3,prob != 0)
df4sel <- dplyr::filter(df4,prob != 0)

# Split the n-gram occurances 

# bigrams split
df2selNew <- as.data.frame(matrix(nrow = length(df2sel$words),ncol = 1))
for (i in 1:length(df2sel$words) ) {
  splitList.i <- strsplit(as.character(df2sel$words[i]),split = " ")
  
  df2selNew$ngram[i] <- splitList.i[[1]][1]
  df2selNew$freq <- df2sel$freq
  df2selNew$prob <- df2sel$prob
  df2selNew$predNext[i] <- splitList.i[[1]][2]
}
df2selNew$V1 <- NULL
#View(df2selNew)

# trigrams split
df3selNew <- as.data.frame(matrix(nrow = length(df3sel$words),ncol = 1))
for (i in 1:length(df3sel$words) ) {
  splitList.i <- strsplit(as.character(df3sel$words[i]),split = " ")
  
  df3selNew$ngram[i] <- paste(splitList.i[[1]][1],splitList.i[[1]][2])
  df3selNew$freq <- df3sel$freq
  df3selNew$prob <- df3sel$prob
  df3selNew$predNext[i] <- splitList.i[[1]][3]
}
df3selNew$V1 <- NULL
#View(df3selNew)

# quadgrams split
df4selNew <- as.data.frame(matrix(nrow = length(df4sel$words),ncol = 1))
for (i in 1:length(df4sel$words) ) {
  splitList.i <- strsplit(as.character(df4sel$words[i]),split = " ")
  
  df4selNew$ngram[i] <- paste(splitList.i[[1]][1],
                              splitList.i[[1]][2],
                              splitList.i[[1]][3])
  df4selNew$freq <- df4sel$freq
  df4selNew$prob <- df4sel$prob
  df4selNew$predNext[i] <- splitList.i[[1]][4]
}
df4selNew$V1 <- NULL
#View(df4selNew)

#Combine all n-gram freqency, prob look-up table into one.

dfAllselNew <- rbind(df2selNew,df3selNew,df4selNew)

setwd(myGenDataDir)
write.csv(x = dfAllselNew,file = "dfAllselNew.csv")

rm(df1, df1sel,
   df2, df2sel,
   df3, df3sel,
   df4, df4sel
)

rm(i, splitList.i)
##  Balaji check from here ***

# Write the ngrams to disk  (Unigram and ngram are not required.)
setwd(myGenDataDir)

neededObjects <- c("df2selNew",
                   "df3selNew",
                   "df4selNew",
                   "dfAllselNew",
                   "myScriptsDir")


for (i in 1:length(neededObjects)){
  saveRDS(neededObjects,paste0("./",neededObjects[i],".RData"))
}

rm(list=setdiff(ls(),neededObjects))
gc()


# for Testing
#inputText <- "dont"
#allgramTemp <- filter(.data = dfAllselNew,ngram == inputText)  
#predTextTemp <- filter(allgramTemp, prob == max(prob))
#predText <- message(select(predTextTemp,predNext))

# Balaji (1) Train with more data (2) Integrate with Shiny (3) smoothing 
# (4) Code refactoring  (5) Convert to Python (6) Prepare Report/Rmd.

