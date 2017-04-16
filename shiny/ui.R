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
              
tabPanel("Number of Travelers",
   
         fluidPage(
   
           tabsetPanel(
             tabPanel("Interactive Map", 
                      hr(),
                      sidebarPanel(width = 3,
                        sliderInput("Year", "Select Year for Interactive Map:",
                                    min = 2005, max = 2015, value = 20, step = 1,format="###0",animate=TRUE)),
                      mainPanel(width = 9,
                        h4(textOutput("year"),  align = "center"),htmlOutput("geogvis"))
                      ),
                      
             tabPanel("Regional Summary", 
                      hr(),
                      sidebarPanel(width = 3,
                                   selectizeInput('inorout', 'Direction',choices = c("Inbound", "Outbound"), selected="")),
                      mainPanel(width = 9,
                                h4(textOutput("myDirection"),  align = "center"),plotlyOutput('inoroutboundcount', height = 600))
             ),
                      
             tabPanel("Regional details", 
                      hr(),
                      sidebarPanel(width = 3,
                      selectizeInput('Regionsel', 'Region',choices = regional_travel$Region, selected=""),
                      selectizeInput('inoroutboth', 'Direction',choices = c("Inbound", "Outbound", "Both"))),
                      mainPanel(width = 9,
                                h4(textOutput("myDirection2"), textOutput("myRegion"),  align = "center"),
                                plotlyOutput('regional_details', height = 600)))
          
      
   ))),

tabPanel("Spending Analysis",
         
         fluidPage(
           
           mainPanel(
             plotlyOutput('inboundspending')
             ))
         

)
)
)