library(shiny)
library(rstanarm)
library(ggplot2)
library(posterior)

# Load pre-trained model (assuming it is saved as "PGA_model.rds")
PGA_model <- readRDS("PGA_model.rds")

# Define ranges for input variables using "αgR"
feature_ranges <- list(
  PI = c(0, 60),
  Vs = c(100, 650),
  H = c(10, 100),
  αgR = c(0.05, 1),    # Using "αgR" consistently
  γ = c(12, 24)
)

# Define the UI with modified display layout #f9f9f9   #e6f7ff;
ui <- fluidPage(
  titlePanel("Bayesian GLM for PGA predictions"),
  tags$head(tags$style(HTML('
    body {font-family: serif, sans-serif; background-color: lightgray;font-size: 16px;}
    h2, h3 {color: #003366; font-size: 20px;}         /* Set font size for h2 and h3 */
    h5{color: #003366; font-size: 16px;}
    .shiny-text-output {color: #333; font-size: 16px;} /* Set font size for text output */
    .well {background-color: #e6f7ff;font-size: 16px;}
  '))),
  
  sidebarLayout(
    sidebarPanel(
      h4("Input Parameters",style = "color: red;font-size: 20px;"),
      fluidRow(
        column(6, h5("PI (%)")),
        column(6, numericInput("PI", label = NULL, value = 30, min = feature_ranges$PI[1], max = feature_ranges$PI[2])),
        column(12, p("Range: ", feature_ranges$PI[1], "-", feature_ranges$PI[2]))
      ),
      fluidRow(
        column(6, h5("Vs (m/s)")),
        column(6, numericInput("Vs", label = NULL, value = 350, min = feature_ranges$Vs[1], max = feature_ranges$Vs[2])),
        column(12, p("Range: ", feature_ranges$Vs[1], "-", feature_ranges$Vs[2]))
      ),
      fluidRow(
        column(6, h5("H (m)")),
        column(6, numericInput("H", label = NULL, value = 30, min = feature_ranges$H[1], max = feature_ranges$H[2])),
        column(12, p("Range: ", feature_ranges$H[1], "-", feature_ranges$H[2]))
      ),
      fluidRow(
        column(6, h5("αgR (g)")),   
        column(6, numericInput("αgR", label = NULL, value = 0.25, min = feature_ranges$αgR[1], max = feature_ranges$αgR[2])),
        column(12, p("Range: ", feature_ranges$αgR[1], "-", feature_ranges$αgR[2]))
      ),
      fluidRow(
        column(6, h5("γ (kN/m³)")),
        column(6, numericInput("γ", label = NULL, value = 18, min = feature_ranges$γ[1], max = feature_ranges$γ[2])),
        column(12, p("Range: ", feature_ranges$γ[1], "-", feature_ranges$γ[2]))
      ),
      actionButton("predict", "Predict", style = "font-size: 18px; background-color: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px;margin-top: 50px;"),
      downloadButton("downloadData", "Download predicted PGA", style = "font-size: 18px; background-color: #2196F3; color: white; padding: 10px 20px; border: none; border-radius: 5px; margin-top: 25px;")
    ),
    
    mainPanel(
      h4("Statistical summary of predicted PGA",style = "color: blue;"),
      fluidRow(
        column(6, h5("Predicted PGA (mean):")),
        column(6, verbatimTextOutput("mean_pred"))
      ),
      fluidRow(
        column(6, h5("Standard Deviation:")),
        column(6, verbatimTextOutput("std_dev"))
      ),
      fluidRow(
        column(6, h5("Coefficient of Variation (%):")),
        column(6, verbatimTextOutput("CoV"))
      ),
      fluidRow(
        column(6, h5("95% Credible Interval (g):")),
        column(6, verbatimTextOutput("cred_interval"))
      ),
      fluidRow(
        column(12, plotOutput("histogram"))
      ),
      tags$hr(),
      tags$div(style = "font-size: 16px;", tableOutput("input_data_display")),  # Set font size for table display
      tags$hr(),
      tags$p(style = "text-align: left; font-size: 16px;", 
             "Author: Ayele T. Chala, Szechenyi Istvan University, Hungary", 
             tags$br(),
             "Email: chala.ayele.tesema@hallgato.sze.hu")
    )
  )
)

server <- function(input, output, session) {
  # Store predictions for export
  predictions <- reactiveVal(data.frame(PGA = numeric(0)))
  
  observeEvent(input$predict, {
    # Check if all inputs are within the specified ranges
    if (input$PI < feature_ranges$PI[1] || input$PI > feature_ranges$PI[2]) {
      showModal(modalDialog(
        title = "Error",
        "PI value is out of range. Please enter a value between 0 and 60.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    if (input$Vs < feature_ranges$Vs[1] || input$Vs > feature_ranges$Vs[2]) {
      showModal(modalDialog(
        title = "Error",
        "Vs value is out of range. Please enter a value between 100 and 650.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    if (input$H < feature_ranges$H[1] || input$H > feature_ranges$H[2]) {
      showModal(modalDialog(
        title = "Error",
        "H value is out of range. Please enter a value between 10 and 100.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    if (input$αgR < feature_ranges$αgR[1] || input$αgR > feature_ranges$αgR[2]) {
      showModal(modalDialog(
        title = "Error",
        "αgR value is out of range. Please enter a value between 0.05 and 1.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    if (input$γ < feature_ranges$γ[1] || input$γ > feature_ranges$γ[2]) {
      showModal(modalDialog(
        title = "Error",
        "γ value is out of range. Please enter a value between 12 and 24.",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    
    # Retrieve input values
    input_data <- data.frame(
      PI = input$PI,
      Vs = input$Vs,
      H = input$H,
      αgR = input$αgR,       # Consistently using "αgR"
      γ  = input$γ 
    )
    
    # Make prediction and calculate statistics
    prediction_samples <- exp(posterior_predict(PGA_model, newdata = input_data, draws = 25000))
    predictions(data.frame(PGA = prediction_samples))  # Store for download
    mean_pred <- mean(prediction_samples)
    std_dev <- sd(prediction_samples)
    CoV <- std_dev / mean_pred * 100
    cred_interval <- quantile(prediction_samples, probs = c(0.025, 0.975))
    
    # Render prediction results in fluid row format
    output$mean_pred <- renderText({
      round(mean_pred, 3)
    })
    output$std_dev <- renderText({
      round(std_dev, 3)
    })
    output$CoV <- renderText({
      round(CoV, 2)
    })
    output$cred_interval <- renderText({ 
      paste(round(cred_interval[1], 3), "-", round(cred_interval[2], 3))
    })
    
    # Display histogram of prediction samples
    output$histogram <- renderPlot({
      # Ensure the data frame for ggplot is created correctly
      prediction_df <- data.frame(PGA = as.vector(prediction_samples))
      
      ggplot(prediction_df, aes(x = PGA)) +
        geom_histogram(bins = 35, fill = "darkblue", color = "white") +
        labs(title = "Histogram of Predicted PGA", x = "PGA (g)", y = "Frequency") +
        theme_minimal() +
        theme(
          plot.title = element_text(size = 18, family = "serif", face = "bold"),
          axis.title = element_text(size = 18, family = "serif"),
          axis.text = element_text(size = 18, family = "serif"), # Font size for axis numbers
          panel.grid = element_blank(), # Remove grid lines
          axis.line = element_line(color = "black"), # Add x and y axis lines
          axis.ticks = element_line(color = "black") # Add x and y axis ticks
        )
    })
  })
  
  # CSV download handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("PGA_predictions_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(predictions(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
