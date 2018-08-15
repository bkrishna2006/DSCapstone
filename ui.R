library(shiny)

shinyUI(fluidPage(
  titlePanel("Swiftkey-JHU Word Prediction Application"),
  mainPanel(
    textInput("my_terms",
              "Enter the text here: ", 
              width = '400px', 
              placeholder="your text here.."),
    h4("Predicted next word(s)"),
    verbatimTextOutput(outputId="predictedWords",
                       placeholder = TRUE)  )  ))
    
