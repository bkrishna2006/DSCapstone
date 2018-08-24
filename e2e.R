rm(list = ls())

# source("SetEnvironment.R")
# ******************************************************SetEnvironment.R
DatasetFolder <- "D:/DSCapstoneRNew"

myScriptsDir <- paste0(DatasetFolder,"/Scripts")
myRawDataDir <- paste0(DatasetFolder,"/RawData")
myRefDataDir <- paste0(DatasetFolder,"/RefData")
mySampleDataDir <- paste0(DatasetFolder,"/SampleData")
myGenDataDir <- paste0(DatasetFolder,"/GenData")
myReportsDir <- paste0(DatasetFolder,"/Reports")
# Seed value for TextMining program 
seedValue <- 08242018
# ******************************************************SetEnvironment.R

#source("DataEngineering.R")
# ******************************************************DataEngineering.R
setwd(myRawDataDir)
language = "en_US"
iteration = "01"
myNewDataFiles <- list.files(path = getwd(),pattern = "*.txt")
# for Linux
#system("split -n 5 -d --additional-suffix=.txt en_US.news.txt news")
#system("split -n 5 -d --additional-suffix=.txt en_US.blogs.txt blogs")
#system("split -n 5 -d --additional-suffix=.txt en_US.twitter.txt twitter")

# for Windows change accordingly
system("fsplit -n 5 -d --additional-suffix=.txt en_US.news.txt news")
system("split -n 5 -d --additional-suffix=.txt en_US.blogs.txt blogs")
system("split -n 5 -d --additional-suffix=.txt en_US.twitter.txt twitter")


myNewDataFiles <- list.files(path=getwd(), pattern = paste0(iteration, "*.txt"))

startTime <- Sys.time()
myNewDataset <- lapply(myNewDataFiles,function(x){
  return(list(fileName=x,fileContent=readLines(x,skipNul = T) ))
})
endTime <- Sys.time()

rawDataFileReadTime <- endTime - startTime
# ******************************************************DataEngineering.R


#source("TextMining.R")
# ******************************************************TextMining.R
setwd(mySampleDataDir)

#5. Creating a Document Corpus to explore the data further
#===========================================================

#  Here, using the Text-mining package(tm) of R, a document corpus is created and several cleansing functions are applied to clean up the data, like striping whitespaces, removing Punctuations,Numbers, stop-words and Profanity words.  Stemming has not been done, considering the possible effect this might have on word-prediction accuracy in the context of blogs & tweets if not news.
#Removing profane words using the two profane word collections jointly,with the lapply function didn't work properly and failed to remove many listed profane words. Hence, this was done separately for the two profane word collections.
#```{R createDocCorpus, echo=F}
library(tm)
library(data.table)

myNewCorpus <- Corpus(DirSource(getwd(),pattern = "*Sample.txt"))
# Cleaning the corpus for 1.Whitespaces 2. Punctuation 3. Numbers 4. Stopwords 5. Profanity words etc.
myNewCorpus <- tm_map(myNewCorpus,stripWhitespace)
myNewCorpus <- tm_map(myNewCorpus,removePunctuation)
myNewCorpus <- tm_map(myNewCorpus,removeNumbers)
myNewCorpus <- tm_map(myNewCorpus,tolower)

startTime <- Sys.time()
myNewCorpus <- tm_map(myNewCorpus,removeWords,stopwords("english"))
endTime <- Sys.time()
removingEngStopwordsTime <- endTime - startTime

# Download RefData
swearWordURL <- "http://www.bannedwordlist.com/lists/swearWords.txt"
badWordURL <- "http://www.cs.cmu.edu/~biglou/resources/bad-words.txt"

#```
#```{R downloadProfanityWords, echo=FALSE}

setwd(myRefDataDir)
if(!file.exists("swearWords.txt")){
  download.file(swearWordURL,"swearWords.txt")
}

if(!file.exists("badWords.txt")){
  download.file(badWordURL,"badWords.txt")
}

swearWords.df <- data.frame(word=readLines("swearWords.txt"))
badWords.df <- data.frame(word=readLines("badWords.txt"))
#```

#```{R removingProfanityWords, echo=TRUE}
# Removing profane words separately using the two profane lists, as doing this in one shot using lapply function of plyr package didn't work properly and failed to remove many listed profane words.

swearWords.df <- swearWords.df[!duplicated(swearWords.df),]
badWords.df <- badWords.df[!duplicated(badWords.df),]

startTime <- Sys.time()
myNewCorpus <- tm_map(myNewCorpus,removeWords,swearWords.df)
myNewCorpus <- tm_map(myNewCorpus,removeWords,badWords.df)
endTime <- Sys.time()

removingProfWordsTime = endTime - startTime

rm(swearWordURL,
   badWordURL,
   swearWords.df,
   badWords.df)
gc()

#```
# 5b. Additional cleansing

removeNumeric <- 
  content_transformer(function(x) 
    gsub('[0-9]+', '', x)
  )

removeNonASCII <- 
  content_transformer(function(x) 
    iconv(x, "latin1", "ASCII", sub="")
  )

modifyURL1 <- 
  content_transformer(function(x) 
    gsub("www",replacement = "www.",x)
  )
modifyURL2 <- 
  content_transformer(function(x) 
    gsub("com$",replacement = ".com",x)
  )

myNewCorpus <- tm_map(myNewCorpus, removeNumeric)
myNewCorpus <- tm_map(myNewCorpus, removeNonASCII)
myNewCorpus <- tm_map(myNewCorpus, modifyURL1)
myNewCorpus <- tm_map(myNewCorpus, modifyURL2)

rm(removeNumeric,
   removeNonASCII,
   modifyURL1,
   modifyURL2
)
gc()

# ******************************************************TextMining.R

#source("N-gramsCreation.R")
# ******************************************************N-gramsCreation.R
library(quanteda)

toks <- tokens(corpus(myNewCorpus))

ngrams <- tokens_ngrams(toks, n = 1:4,concatenator = ' ')
unigrams <- tokens_ngrams(toks,n=1,concatenator = ' ')
bigrams <- tokens_ngrams(toks,n=2,concatenator = ' ')
trigrams <- tokens_ngrams(toks,n=3,concatenator = ' ')
quadgrams <- tokens_ngrams(toks,n=4,concatenator = ' ')

#5. Creating Document feature Matrix
ngram_dfm <- dfm(ngrams, verbose = FALSE)
unigram_dfm <- dfm(unigrams, verbose = FALSE)
bigram_dfm <- dfm(bigrams, verbose = FALSE)
trigram_dfm <- dfm(trigrams, verbose = FALSE)
quadgram_dfm <- dfm(quadgrams, verbose = FALSE)

# 6 How many unique words do you need in a frequency sorted dictionary to 
# cover 50% of all word instances in the language? 90%?
# Define function to calculate coverage
CoverageCalc <- function (dfm, percent) {
  words <- sort(colSums(dfm), decreasing = TRUE)
  allwords <- length(dfm@i)
  sum = 0
  for(i in 1:allwords)
  {
    sum <- sum + words[[i]]
    if(sum >= (percent * allwords)) break
  }
  i        
}

unigramCov50 <- CoverageCalc(unigram_dfm, 0.5)
unigramCov75 <- CoverageCalc(unigram_dfm, 0.75)
unigramCov90 <- CoverageCalc(unigram_dfm, 0.9)

bigramCov50 <- CoverageCalc(bigram_dfm, 0.5)
bigramCov75 <- CoverageCalc(bigram_dfm, 0.75)
bigramCov90 <- CoverageCalc(bigram_dfm, 0.9)

trigramCov50 <- CoverageCalc(trigram_dfm, 0.5)
trigramCov75 <- CoverageCalc(trigram_dfm, 0.75)
trigramCov90 <- CoverageCalc(trigram_dfm, 0.9)

quadgramCov50 <- CoverageCalc(quadgram_dfm, 0.5)
quadgramCov75 <- CoverageCalc(quadgram_dfm, 0.75)
quadgramCov90 <- CoverageCalc(quadgram_dfm, 0.9)

Coverage_Stat <- matrix(data = c("Type", "50%", "75%", "90%",
                                 "unigram",unigramCov50,unigramCov75,unigramCov90,
                                 "bigram",bigramCov50,bigramCov75,bigramCov90,
                                 "trigram",trigramCov50,trigramCov75,trigramCov90,
                                 "quadgram", quadgramCov50,quadgramCov75,quadgramCov90),
                        nrow = 5,
                        ncol = 4,
                        byrow = TRUE
)


write.csv(Coverage_Stat,file = "NgramsCoverageStat.csv")
# from Coverage statistics table, it is decided to go with whatever is required for 90% coverage, 
# as we are working on a small sample of 1 % of the data.

# for unigram

unigramVector <- topfeatures(unigram_dfm, unigramCov75)
unigramVector <- sort(unigramVector, decreasing = FALSE)
unigramDf <- data.frame(words = names(unigramVector), freq = unigramVector)
unigramDf_sorted <- unigramDf[order(unigramDf$words, -unigramDf$freq),]

# for Biragram
bigramVector <- topfeatures(bigram_dfm, bigramCov75)
bigramVector <- sort(bigramVector, decreasing = FALSE)
bigramDf <- data.frame(words = names(bigramVector), freq = bigramVector)
bigramDf_sorted <- bigramDf[order(bigramDf$words, -bigramDf$freq),]

# for trigram
trigramVector <- topfeatures(trigram_dfm, trigramCov75)
trigramVector <- sort(trigramVector, decreasing = FALSE)
trigramDf <- data.frame(words = names(trigramVector), freq = trigramVector)
trigramDf_sorted <- trigramDf[order(trigramDf$words, -trigramDf$freq),]

# for Quadragram
quadgramVector <- topfeatures(quadgram_dfm, quadgramCov75)
quadgramVector <- sort(quadgramVector, decreasing = FALSE)
quadgramDf <- data.frame(words = names(quadgramVector), freq = quadgramVector)
quadgramDf_sorted <- quadgramDf[order(quadgramDf$words, -quadgramDf$freq),]

#for ngram
ngramDf <- rbind(unigramDf,bigramDf,trigramDf,quadgramDf)
ngramDf_sorted <- ngramDf[order(ngramDf$words, -ngramDf$freq),]

write.csv(x = ngramDf_sorted,file = "NgramDf_sorted.csv")

rm(unigramVector,bigramVector,trigramVector,quadgramVector,
   unigramCov50,bigramCov50,trigramCov50,quadgramCov50,
   unigramCov75,bigramCov75,trigramCov75,quadgramCov75,
   unigramCov90,bigramCov90,trigramCov90,quadgramCov90,
   unigramDf,bigramDf,trigramDf,quadgramDf,ngramDf
)
gc()


# ******************************************************N-gramsCreation.R


#source("TextPredictionModelling.R")
# ******************************************************TextPredictionModelling.R
library(dplyr)

df1 <- mutate(unigramDf_sorted,prob=round(freq/sum(freq),7))
df2 <- mutate(bigramDf_sorted,prob=round(freq/sum(freq),7))
df3 <- mutate(trigramDf_sorted,prob=round(freq/sum(freq),7))
df4 <- mutate(quadgramDf_sorted,prob=round(freq/sum(freq),7))

# drop all n-gram occurances where the probability is zero.
#df1sel <- dplyr::filter(df1,(prob != 0 && freq > 1))
#df2sel <- dplyr::filter(df2,(prob != 0 && freq > 1))
#df3sel <- dplyr::filter(df3,(prob != 0 && freq > 1))
#df4sel <- dplyr::filter(df4,(prob != 0 && freq > 1))

# drop all n-gram occurances where the probability is zero.
df1sel <- dplyr::filter(df1,(freq > 1))
df2sel <- dplyr::filter(df2,(freq > 1))
df3sel <- dplyr::filter(df3,(freq > 1))
df4sel <- dplyr::filter(df4,(freq > 1))


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

# ******************************************************TextPredictionModelling.R
