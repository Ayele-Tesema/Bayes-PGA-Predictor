library(rstanarm)
library(ggplot2)
library(posterior)

# Load and fit the model as done in your setup
set.seed(123)
mydata <- read.csv("pData.csv")
mydata$log_PGA <- log(mydata$PGA)
PGA_Data <- mydata[, c("PI", "Vs", "H", "αgR", "γ", "log_PGA")]
PGA_model <- stan_glm(log_PGA ~ ., data = PGA_Data, iter = 30000, warmup = 1000, 
                      family = gaussian(), prior = normal(), prior_intercept = normal(),
                      model = TRUE)
# Save model to RDS file
saveRDS(PGA_model, "PGA_model.rds")
#the end of simulation
