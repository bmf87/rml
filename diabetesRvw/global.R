# Loading packages
library(shiny)
library(bslib)
library(DT)
library(dplyr)
library(ggplot2)
library(shinyjs)
library(MASS)


# Load scripts
source("utils.R", local = FALSE)

# Load data sets & model
dbData = readRDS("data/dbData.rds")
testDiabetes = readRDS("data/testDiabetes.rds")
fitx = readRDS("data/fitx.rds")
tidyFitx = readRDS("data/tidyFitx.rds")