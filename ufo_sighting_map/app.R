#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(stringr)
library(shinyWidgets)

args <- commandArgs(trailingOnly=T);
port <- as.numeric(args[[1]]);

#data processing and filtering
ufo_df<-read.csv("../derived_data/nuforc_ufo_clean_data.csv",header=TRUE, stringsAsFactors=FALSE)
ufo_df<-ufo_df%>%filter(is.na(year)==0)%>%
    filter(year>=2000)%>%
    transform(city_latitude=as.numeric(city_latitude),city_longitude=as.numeric(city_longitude))%>%
    filter(is.na(city_latitude)==0)%>%
    select(-stats,-text,-posted,-duration_hours,-duration_minutes,-duration,-duration_seconds)
# add index to later us as unique identifier
ufo_df$index<-1:nrow(ufo_df)

shapes_in_order <- ufo_df %>% group_by(shape) %>% tally() %>% arrange(desc(n),shape) %>% pull(shape)

ui <- fluidPage(
    tabPanel("Interactive map", 
            div(class = "outer",
                 tags$head(
                     # this next section contains custom HTML code used to style the RShiny App
                     tags$style(HTML("input[type='number'] {
                                              max-width: 80%;
                                            }
                                            
                                            div.outer {
                                              position: fixed;
                                              top: 41px;
                                              left: 0;
                                              right: 0;
                                              bottom: 0;
                                              overflow: hidden;
                                              padding: 0;
                                            }
                                            
                                            /* Customize fonts */
                                            body, label, input, button, select { 
                                              font-family: 'Helvetica Neue', Helvetica;
                                              font-weight: 200;
                                            }
                                            h1, h2, h3, h4 { font-weight: 400; }
                                            
                                            #controls {
                                              /* Appearance */
                                              background-color: white;
                                              padding: 0 20px 20px 20px;
                                              cursor: move;
                                              /* Fade out while not hovering */
                                              opacity: 0.65;
                                              zoom: 0.9;
                                              transition: opacity 100ms 500ms;
                                            }
                                            #controls:hover {
                                              /* Fade in while hovering */
                                              opacity: 0.95;
                                              transition-delay: 0;
                                            }
                                            
                                            /* Position and style citation */
                                            #cite {
                                              position: absolute;
                                              bottom: 10px;
                                              left: 10px;
                                              font-size: 12px;
                                            }
                                            
                                            /* If not using map tiles, show a white background */
                                            .leaflet-container {
                                              background-color: white !important;
                                            }
                                    "))
                     
        ),  
            # control the map object
            leafletOutput(outputId = "mymap",width="155%",height=800), 
            # moveable panel for interactive filtering
            absolutePanel(id="controls", class="panel panel-default",fixed = TRUE,
                  draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                  width = 330, height = "auto",
                sliderInput("year",
                        "Year:",
                        min = 2000,
                        max = 2021,
                        value = 2010,
                        step=1,
                        sep=""),
                pickerInput(
                    inputId="shape", label="Choose UFO Shapes to Display",
                    choices = shapes_in_order,
                    selected=shapes_in_order,
                    option= list(`actions-box`=TRUE, size=10, `selected-text-format`="count > 3"),
                    multiple=TRUE
                    ),
                h5("Note: click on UFO sighting to display more information.")
            )
        )
    )
)

server <- function(input, output) {
    #define color palete for shape of ufo
    pal<- colorFactor(palette='Paired',domain=factor(ufo_df$shape,shapes_in_order))
    
    #reactive expression used to observe both inputs (year and shape selection)
    toListen <- reactive({
        list(input$year,input$shape)
    })
    
    output$mymap <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(lng = -80, lat = 39, zoom = 4.4)
    })
    # changes displayed markers as user selects year and shape of UFO sighting
    observeEvent(toListen(), {
        df<- ufo_df %>% filter(year==input$year & shape %in% input$shape)
        leafletProxy("mymap") %>%   
            clearMarkers() %>% 
            addCircleMarkers(data = df,color= ~pal(shape),lat = ~ city_latitude, lng = ~ city_longitude, layerId = ~ index, weight = 1, radius = 5, 
                       label = ~as.character(paste0("UFO Shape: ", sep = " ", shape)), fillOpacity = 0.75)
    })
    # Shows a popup at given location
    showUfoPopup <- function(id,ufo_df){
        selectedufo <- ufo_df %>% filter((ufo_df$index) == (id))
        print(selectedufo)
        content <- as.character(tagList(
            tags$strong(HTML(sprintf("%s, %s %s",
              selectedufo$city, selectedufo$state, selectedufo$date_time
              ))), tags$br(),
            sprintf("Shape: %s", selectedufo$shape), tags$br(),
            sprintf("Duration (minutes): %s", as.integer(selectedufo$duration_minutes)), tags$br(),
            sprintf("Report link: %s", selectedufo$report_link)
        ))
        leafletProxy("mymap") %>% addPopups(selectedufo$city_longitude, selectedufo$city_latitude, content)
    }
    
    # When map is clicked, show a popup with more info on the UFO sighting
    observeEvent(input$mymap_marker_click, {
        click<-input$mymap_marker_click
        leafletProxy("mymap") %>% clearPopups()
        if (is.null(click))
            return()
        isolate({
            showUfoPopup(click$id,ufo_df)
        })
    })
}

# Run the application 
#shinyApp(ui = ui, server = server)
shinyApp(ui = ui, server = server, options = list(port=port,
                                                host="0.0.0.0"))