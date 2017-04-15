#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(plotly)

# Define UI for application that draws a histogram

shinyUI( 
   # 
   # fluidPage(
   #    
   #    # Application title
   #    titlePanel("Hello Shiny!"),
   #    
   #    sidebarLayout(
   #       
   #       # Sidebar with a slider input
   #       sidebarPanel(
   #             sliderInput
   #             ("Year", "Select Year:", 
   #                min=1996, max=2016, value=20,  step=1,
   #                format="###0",animate=TRUE))
   #       ),
   #       
   #       # Show a plot of the generated distribution
   #       mainPanel(
   #          h3(textOutput("year")), 
   #          htmlOutput("geogvis"),
   #          htmlOutput("column")
   #       )
   #    )
   # )
   # 
   
navbarPage("American On the Way", id="nav",
              
tabPanel("Interactive map",
   
         fluidPage(
   
      
      sidebarLayout(
         
         sidebarPanel(width = 3,
            sliderInput("Year", "Select Year:",  
                        min = 1996, max = 2016, value = 20, step = 1,format="###0",animate=TRUE),
            selectizeInput('inorout', 'Direction',
                                     choices = c("inbound", "outbound"), selected="")
            
         ),
         
         mainPanel(width = 9,
            h4(textOutput("year"), align = "center"), 
                     htmlOutput("geogvis"),
                      htmlOutput("column")
         )
      )
   ))
)
)