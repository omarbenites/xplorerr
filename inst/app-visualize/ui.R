library(shiny)
library(shinyBS)
library(shinythemes)
library(descriptr)
library(dplyr)

shinyUI(	
  navbarPage(HTML("Visualizer"), id = 'mainpage',
    source('ui/ui_data.R', local = TRUE)[[1]],
    source('ui/ui_visualize.R', local = TRUE)[[1]]
))
