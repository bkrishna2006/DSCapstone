# Main Program that calls the other programs in an order

source("SetEnvironment.R")
source("DataEngineering.R")

setwd(myScriptsDir)
source("SetEnvironment.R")
source("TextMining.R")

setwd(myScriptsDir)
source("SetEnvironment.R")
source("N-gramsCreation.R")

setwd(myScriptsDir)
source("SetEnvironment.R")
source("TextPredictionModelling.R")

setwd(myScriptsDir)
source("ui.R")

setwd(myScriptsDir)
source("server.R")
