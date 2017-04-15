#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(maptools)
library(ggplot2)
library(plotly)
library(googleVis)
## Prepare data to be displayed
## Load presidential election data by state from 1932 - 2012
library(RCurl)
## Add min and max values to the data


shinyServer(function(input, output) {
   myYear <- reactive({
      input$Year
      
   })
   inorout <- reactive({
      input$inorout
   })
   output$year <- renderText({
      paste("International",inorout(), myYear())
   })
   output$geogvis <- renderGvis({

      gvisGeoChart(t20,
                   locationvar="country", colorvar="arrivals",
                   options=list(region="world", resolution="countries",
                                width="100%", height="50%",
                                colorAxis="{colors:['#FFFFFF', '#0000FF']}"
                   ))
   })
      
      output$column <- renderGvis({
         
         Column <- gvisColumnChart(t20,xvar="country",yvar="arrivals")
   })

})