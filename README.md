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
PI(%): 0-60, Vs(m/s):100-650, H(m): 10-100, αgR(g): 0.05-1 and γ(kN/m3): 12-24
2. Click on the "Pridict" button to generate probabilistic PGA predictions. 
The tool generates:

Mean prediction: Central estimate of PGA

Standard deviation: Spread of predicted values

Coefficient of Variation (CoV): Normalized measure of dispersion

95% Credible Interval: Uncertainty bounds of the prediction

Histogram: Distribution of posterior predictions

3. Export results as .csv files by clicking on "Download predicted PGA" for detailed analysis.
### Troubleshooting

App won’t launch? Ensure all packages are installed and App.r is in the working directory.

Inputs out of range? Confirm all values are within specified limits.

Prediction looks off? Try with different realistic inputs and check units.

### Contact
If you have questions, feedback, or need assistance, feel free to contact:

Ayele T. Chala

Emails: chala.ayele.tesema@hallgato.sze.hu
	sonoft@gmail.com


