## Develop Data Products
## Course Project: Shiny Application and Reproducible Pitch
## Part I: Shiny app
## server.R

library(shiny)

shinyServer(
  function(input, output) {
    output$odate <- renderPrint({input$date})
    output$otaber <- renderPrint({input$taber})
    output$oenv <- renderPrint({input$env})
    output$osamples <- renderPrint({input$samples})   
    output$otests <- renderPrint({input$tests})   

    output$ofile <- renderPrint({input$file})
    
    # Reactive expression to generate the requested distribution. This is 
    # called whenever the inputs change. The renderers defined 
    # below then all use the value computed from this expression
    cts_data <- reactive({  
      taber <- switch(input$taber,
                     Dry_7.5N_10cpm = rnorm,
                     Dry_10N_60cpm = rpois,
                     Wet_20N_60cpm = rnorm,
                     rnorm)
      if (input$taber == "Dry_7.5N_10cpm" || input$taber == "Wet_20N_60cpm") {
            mean <- switch(input$taber,
                      Dry_7.5N_10cpm = 50,
                      Dry_10N_60cpm = input$tests,
                      Wet_20N_60cpm = 100,
                      10)
      
            sd <- switch(input$taber,
                     Dry_7.5N_10cpm = 15,
                     Dry_10N_60cpm = NULL,
                     Wet_20N_60cpm = 10,
                     10)
      
            as.integer(taber(input$samples * input$tests, mean, sd))

      } else {    
            taber(input$samples * input$tests, input$tests)
      }

    })
    
    # Generate a plot of the data. Also uses the inputs to build the 
    # plot label. Note that the dependencies on both the inputs and
    # the 'data' reactive expression are both tracked, and all expressions 
    # are called in the sequence implied by the dependency graph
    output$plot <- renderPlot({
      date <- input$date
      taber <- input$taber
      env <- input$env
      samples <- input$samples
      tests <- input$tests      
      mu <- mean(cts_data())
      hist(cts_data(), 
           main=paste('Scratch Test (',date,', ',taber,', ',env,', ',tests,' tests/sample for ',samples,' samples',')',sep=''))
      abline(v=mu, col='red')
    })
    
    # Generate a summary of the data
    output$summary <- renderPrint({
      summary(cts_data())
    })
    
    # Generate an HTML table view of the data
    output$table <- renderTable({
      data.frame(Cycles_to_Scratch=cts_data())
    })
  }
)