library(shiny)
library(dplyr)
library(stringi)
#setwd(myGenDataDir)
#load("allgram.RData")
#options(shiny.reactlog=TRUE)

shinyServer(function(input, output) {

  inputWordsReactive <- reactive({
    inputText <- input$my_terms
  })

  output$predictedWords = renderText({
    termsSimple()
  })

  termsSimple <- reactive({
    
    t <- stri_trans_tolower(inputWordsReactive())
    if (t=="") {
      return(" ")
    }
    t <- unlist(strsplit(x = t,split = " "))
#    t <- unlist(strsplit(x = stri_trans_tolower(inputWordsReactive()),split = " "))
    last <- t[length(t)]
    lastBut1 <- t[length(t)-1]
    lastBut2 <- t[length(t)-2]
    t3 <- paste(lastBut2,lastBut1,last, sep = " ")
    t2 <- paste(lastBut1,last, sep = " ")
    t1 <- paste(last)
    
    allgramTempt3 <- filter(.data = dfAllselNew,ngram == t3)
    allgramTempt2 <- filter(.data = dfAllselNew,ngram == t2)
    allgramTempt1 <- filter(.data = dfAllselNew,ngram == t1)

# to keep predicted word place-holder clean
    
#    blank <- " "
#    return(blank)
    
      if (length(allgramTempt1$ngram) > 0) {
      predTextTemp1 <- filter(allgramTempt1, prob == max(prob))
      predTextTemp2 <- select(predTextTemp1,predNext)
      for(i in 1:length(predTextTemp2$predNext)){
         predictedWord.i <- paste(predTextTemp2$predNext)
         return(predictedWord.i)
        }
    } else if (length(allgramTempt2$ngram) > 0) {
      predTextTemp1 <- filter(allgramTempt2, prob == max(prob))
      predTextTemp2 <- select(predTextTemp1,predNext)
      for(i in 1:length(predTextTemp2$predNext)){
         predictedWord.i <- paste(predTextTemp2$predNext)
        return(predictedWord.i)
        }
    } else if (length(allgramTempt3$ngram) > 0) {
      predTextTemp1 <- filter(allgramTempt3, prob == max(prob))
      predTextTemp2 <- select(predTextTemp1,predNext)
      print(predTextTemp2)
      for(i in 1:length(predTextTemp2$predNext)){
        predictedWord.i <- paste(predTextTemp2$predNext)
        return(predictedWord.i)
        }
    } else if (length(allgramTempt1$ngram) == 0) {
      return(predictedWord.i)
    }  
  })
})
