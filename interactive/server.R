library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
zipdata <- allzips

# will be drawn last and thus be easier to see
zipdata <- zipdata[order(zipdata$amount),]

function(input, output, session) {
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
  


  # add circles
  observe({
    seldata <- zipdata
    # Filter data based on selections
    if (input$type != "All") {
      seldata <- seldata[seldata$type == input$type,]
    }
    if (input$occupation != "All") {
      seldata <- seldata[seldata$occupation == input$occupation,]
    }
    if (input$party != "All") {
      seldata <- seldata[seldata$party == input$party,]
    }
    if (input$month != "All") {
      seldata <- seldata[seldata$month == input$month,]
    }    
    
    colorBy <- input$amount
    sizeBy <- input$amount
    colorData <- seldata[[colorBy]]
    pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    radius <- seldata[[sizeBy]] / max(seldata[[sizeBy]]) * 30000

    leafletProxy("map", data = seldata) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function(zipcode, lat, lng) {
    selectedZip <- allzips[allzips$zipcode == zipcode,]
    content <- as.character(tagList(
      tags$h4("Transaction Amount:", sum(as.numeric(selectedZip$amount))),
      sprintf("Date: %s", as.character(selectedZip$date)), tags$br(),
      sprintf("Transaction Type: %s", as.character(selectedZip$type)), tags$br(),
      sprintf("Occupation: %s", as.character(selectedZip$occupation)), tags$br(),
      sprintf("Party: %s", as.character(selectedZip$party))
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })

}
