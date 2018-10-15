options(shiny.maxRequestSize=1000*1024^2)

if (!require("meanr")) install.packages("meanr")
if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("trinker/coreNLPsetup", "trinker/stansent")
pacman::p_load_current_gh("trinker/lexicon", "trinker/sentimentr")
pacman::p_load(sentimentr, dplyr, magrittr)
pacman::p_load_gh("trinker/sentimentr", "trinker/stansent", "sfeuerriegel/SentimentAnalysis", "wrathematics/meanr")
pacman::p_load(syuzhet, qdap, microbenchmark, RSentiment)

library(ggplot2)
library(lubridate)
library(dplyr)
library(stringr)
library(Hmisc)

datadir <- "./data"
# datafile <- "EconData.RData"
# datadirfile <- paste(datadir, datafile, sep="/")
# load(datadirfile, envir = .GlobalEnv)

