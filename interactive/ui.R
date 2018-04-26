library(leaflet)

# Choices for drop-downs
navbarPage("Transaction", id="nav",

  tabPanel("Interactive map",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", width="800", height="600"),

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Transaction amount"),

        selectInput("type", "Transaction type:", c("All", unique(as.character(cleantable$Type)))),
        selectInput("occupation", "Occupation:", c("All", unique(as.character(cleantable$Occupation)))),
        selectInput("party", "Party:", c("All", unique(as.character(cleantable$Party)))),
        selectInput("amount", "Amount:", c("Amount" = "amount"),selected = "amount")
      )

    )
  ),

  conditionalPanel("false", icon("crosshair"))
)
