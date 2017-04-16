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
library(ggplot2)
library(plotly)
library(googleVis)



shinyServer(function(input, output) {
   myYear <- reactive({
      input$Year
      
   })
   inorout <- reactive({
      input$inorout
   })
   region_sel <- reactive({
     input$Regionsel
   })
   
   inoroutboth <- reactive({
     input$inoroutboth
   })
   
   output$year <- renderText({
      paste("Top 20 International Inbound in ", myYear())
   })
   
   output$myDirection <- renderText({
     paste(inorout())
   })
   
   output$myDirection2 <- renderText({
     paste(inoroutboth())
   })
   
   output$myRegion <- renderText({
     paste(region_sel())
   })
   
   
   output$geogvis <- renderGvis({
     
     temp <- subset(tidy_ntto_inbound_y, 
                      (Year == myYear()))
     
      gvisGeoChart(temp,
                   locationvar="MixRegion", colorvar="numbercount",
                   options=list(region="world", resolution="countries",
                                width="100%", height="50%",
                                colorAxis="{minValue: 10000, maxValue: 30000000, colors:['green', 'yellow', 'red']}"
                                
                   ))
   })
      
    
   

      
      
      output$inoroutboundcount<-renderPlotly({
        
        if (input$inorout=="Inbound"){
        inbound_region %>% spread(Region, numbercount) %>% 
          plot_ly(x = ~as.POSIXct(Date)) %>%
          add_trace(y=~africa, name='africa', mode='lines', line = list(color="gray", width = 1, dash = 'dot')) %>%
          add_trace(y=~asia, name='asia', mode='lines', line = list(color="red", width = 1, dash = 'dot')) %>%
          add_trace(y=~canada, name='canada', mode='lines', line = list(color="orange", width = 1, dash = 'dot')) %>%
          add_trace(y=~europe, name='europe', mode='lines', line = list(color="pink", width = 1, dash = 'dot')) %>%
          add_trace(y=~`latin america excl mexico`, name='latin america excl mexico', mode='lines', line = list(color="green", width = 1, dash = 'dot')) %>%
          add_trace(y=~mexico, name='mexico', mode='lines', line = list(color="purple", width = 1, dash = 'dot')) %>%
          add_trace(y=~`middle east`, name='middle east', mode='lines', line = list(color="black", width = 1, dash = 'dot')) %>%
          add_trace(y=~oceania, name='oceania', mode='lines', line = list(color="blue", width = 1, dash = 'dot')) %>% 
          layout(xaxis = list(title = "Date"), yaxis = list(title = "Number of travelers"))}
        else{
          outbound_region %>% spread(Region, numbercount) %>% 
            plot_ly(x = ~as.POSIXct(Date)) %>%
            add_trace(y=~africa, name='africa', mode='lines', line = list(color="gray", width = 1, dash = 'dot')) %>%
            add_trace(y=~asia, name='asia', mode='lines', line = list(color="red", width = 1, dash = 'dot')) %>%
            add_trace(y=~canada, name='canada', mode='lines', line = list(color="orange", width = 1, dash = 'dot')) %>%
            add_trace(y=~europe, name='europe', mode='lines', line = list(color="pink", width = 1, dash = 'dot')) %>%
            add_trace(y=~`latin america excl mexico`, name='latin america excl mexico', mode='lines', line = list(color="green", width = 1, dash = 'dot')) %>%
            add_trace(y=~mexico, name='mexico', mode='lines', line = list(color="purple", width = 1, dash = 'dot')) %>%
            add_trace(y=~`middle east`, name='middle east', mode='lines', line = list(color="black", width = 1, dash = 'dot')) %>%
            add_trace(y=~oceania, name='oceania', mode='lines', line = list(color="blue", width = 1, dash = 'dot')) %>% 
            layout(xaxis = list(title = "Date"), yaxis = list(title = "Number of travelers"))
        }
      })
      
      
      output$regional_details<-renderPlotly({
        if (input$inoroutboth == "Inbound"){regional_travel %>% 
            filter(Region==input$Regionsel) %>% 
            plot_ly(x = ~as.POSIXct(Date)) %>%
            add_trace(y=~numbercount.x, name='Inbound', mode='lines', line = list(color="gray", width = 1, dash = 'dot')) %>%
            layout(xaxis = list(title = "Date"), yaxis = list(title = "Number of travelers"))}
        else{
          if (input$inoroutboth == "Outbound"){regional_travel %>% 
              filter(Region==input$Regionsel) %>% 
              plot_ly(x = ~as.POSIXct(Date)) %>%
              add_trace(y=~numbercount.y, name='Outbound', mode='lines', line = list(color="blue", width = 1, dash = 'dot')) %>%
              layout(xaxis = list(title = "Date"), yaxis = list(title = "Number of travelers"))}
        else{
          regional_travel %>% 
          filter(Region==input$Regionsel) %>% 
          plot_ly(x = ~as.POSIXct(Date)) %>%
          add_trace(y=~numbercount.x, name='Inbound', mode='lines', line = list(color="gray", width = 1, dash = 'dot')) %>%
          add_trace(y=~numbercount.y, name='Outbound', mode='lines', line = list(color="blue", width = 1, dash = 'dot')) %>%
          layout(xaxis = list(title = "Date"), yaxis = list(title = "Number of travelers"))}}
      })
      
     
})