# Bayesian Generalized Linear Model (GLM) for peak ground acceleration (PGA) predictions

Welcome to the Bayesian Generalized Linear Model (GLM) for peak ground acceleration (PGA) predictions repository! 
This tool leverages Bayesian GLMs to probabilistically predict PGA while accounting for geotechnical variability and uncertainty.
## Features
Probabilistic prediction of PGA using a Bayesian framework.
Input parameters include plasticity index (PI), shear wave velocity (Vs), depth to bedrock (H), reference PGA at the bedrock level (αgR), and unit weight of soil (γ).
Provides credible intervals and visualizations for uncertainty quantification.
User-friendly interface built with Shiny in R.
Results exportable as .csv files for further analysis.

## Getting Started!
Before running the tool, ensure you have:
1. R installed: Download it from the [official R website](https://www.r-project.org/).
2. RStudio (optional but recommended): Get it from [RStudio's website](https://posit.co/downloads/)

### Installation
Install the required R libraries:
1. install.packages(c("shiny", "rstanarm", "ggplot2", "posterior"))
2. Clone or download this repository, including the application script (App.r).

### Running the Application!

To run the Bayes-PGA-Predictor application:

1. Open RStudio (or your preferred R environment).
2. Load the App.r script.
3. Execute the script by clicking the Run App button or using the appropriate command.
4. The application will launch in your default web browser.
### How It Works
The application allows users to:

1. Input geotechnical parameters within specified ranges.
2. Generate probabilistic PGA predictions, including the mean, standard deviation, coefficient of variation (CoV), and 95% credible intervals.
3. Visualize results through histograms.
4. Export results as .csv files for detailed analysis.

### Contact
If you have questions, feedback, or need assistance, feel free to contact:

Ayele T. Chala

Email: chala.ayele.tesema@hallgato.sze.hun

