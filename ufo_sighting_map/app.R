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

ufo_df<-read.csv("../derived_data/nuforc_ufo_clean_data.csv",header=TRUE, stringsAsFactors=FALSE)
ufo_df<-ufo_df%>%filter(is.na(year)==0)%>%
    filter(year>=2000)%>%
    transform(city_latitude=as.numeric(city_latitude),city_longitude=as.numeric(city_longitude))%>%
    filter(is.na(city_latitude)==0)%>%
    select(-stats,-text,-posted,-duration_hours,-duration_minutes,-duration,-duration_seconds)


ufo_shape<-ufo_df %>% filter(str_detect(shape,"2018.*")==0)
shapes_in_order <- ufo_shape %>% group_by(shape) %>% tally() %>% arrange(desc(n),shape) %>% pull(shape)


# Define UI for application that draws a histogram
ui <- fluidPage(
    mainPanel( 
        #this will create a space for us to display our map
        leafletOutput(outputId = "mymap",width="125%",height=1000), 
    # Application title
    titlePanel("UFO Reports by Year"),
    ),
    # Sidebar with a slider input for number of bins 
    absolutePanel(top=700,left=20,
            sliderInput("year",
                        "Year:",
                        min = 2000,
                        max = 2021,
                        value = 2010,
                        step=1,
                        sep="")
        )
        )
# Define server logic required to draw a histogram
server <- function(input, output) {
    #define color palete for shape of ufo
    pal<- colorFactor(palette='Paired',domain=factor(ufo_shape$shape,shapes_in_order))
    
    output$mymap <- renderLeaflet({
        df<- ufo_shape %>% filter(year==input$year)
        leaflet(df) %>% setView(lng = -99, lat = 39, zoom = 4.2)  %>% #setting the view over ~ center of North America
            addTiles() %>% 
            addCircles(data = df,color= ~pal(shape),lat = ~ city_latitude, lng = ~ city_longitude, weight = 1, radius = 20000, label = ~as.character(paste0("UFO Shape: ", sep = " ", shape)), fillOpacity = 0.75)
    })
    
    }

# Run the application 
shinyApp(ui = ui, server = server)