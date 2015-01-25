## Develop Data Products
## Course Project: Shiny Application and Reproducible Pitch
## Part I. Shiny app
## ui.R

library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Smart Phone Cover Glass Scratch Test"),
  sidebarPanel(
    dateInput("date", "Date:"),

    radioButtons("taber", "Taber Tester Setup (Load, Speed)",
                       c("Dry Test (7.5N, 10cyc/min)" = "Dry_7.5N_10cpm",
                         "Dry Test (10N, 60cyc/min)" = "Dry_10N_60cpm",
                         "Wet Test (20N, 60cyc/min)" = "Wet_20N_60cpm")),

    selectInput("env", "Environment Test",
                       c("Ambient" = "RT",
                         "High Temperature High Humidity" = "HTHH",
                         "Thermal Shock" = "Ts",
                         "Condensation" = "Tc",
                         "Low Temperature -40C" = "LT",
                         "High Temperature" = "HT")),

    numericInput('samples', 'Number of Samples', 5, min = 0, max = 100, step = 1),
    br(),
    sliderInput("tests", 
                "Number of Tests on Each Sample:", 
                value = 10,
                min = 1, 
                max = 100),
    submitButton('Submit'),
    
    fileInput("file", label = h5("Load data file"))
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("plot")), 
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabPanel("Table", tableOutput("table")),
      tabPanel("Help", 
               strong("Instruction"),
               p("1. This is a Shiny app that consists of a Sidebar for user interaction and a Main panel for data analysis display."), 
               p("2. The Sidebar allows the user to enter/select the test conditions and load a data file. For demonstration purpose, a set of simulated data will be generated according per test conditions."),
               p("3. Click the Submit button on the Sidebar and the app will runs a quick demo using the simulated data generated."),
               p("4. Data are displayed via a plot, a summary, and a table in the Main panel."))
    )
  )
))