# ==============================================================================
# Load and explore data
# ==============================================================================
if (!require("mlbench")) install.packages("mlbench")
library(mlbench)
data(PimaIndiansDiabetes)
head(PimaIndiansDiabetes)

# Fit logistic regression model
model <- glm(diabetes ~ glucose + age + mass + pressure, 
             data = PimaIndiansDiabetes, 
             family = binomial)

# View model output
summary(model)

# Get odds ratios and confidence intervals
exp(coef(model))
exp(confint(model))

# Crude model output ------------------------------------------------------

crude_model <- glm(diabetes ~ glucose, data = PimaIndiansDiabetes, family = binomial)
exp(coef(crude_model))
