# confounding_and_effect_modification.R
# ==========================================================
#
# Analysis of Confounding and Effect Modification
#
# This script generates synthetic data and demonstrates how to:
#   - Identify confounding
#   - Assess for effect modification
#   - Adjust for confounders using stratification and regression
#

# ----------------------------------------------------------
# Load Necessary Libraries and Scripts
# ----------------------------------------------------------

# Load custom scripts (assuming RSCRIPTS is defined elsewhere)
sourceDir(RSCRIPTS)

# Load dplyr for data manipulation
if (!require("dplyr"))
  install.packages("dplyr")
library(dplyr)

# Set seed for reproducibility
set.seed(123)


# ----------------------------------------------------------
# Generate Synthetic Dataset
# ----------------------------------------------------------

n <- 500  # Sample size

# Create data frame with predictors
data <- data.frame(
  Smoking = rbinom(n, 1, 0.4),
  # 40% Smokers
  Occupational_Exposure = rbinom(n, 1, 0.3),
  # 30% High-Risk Jobs
  Age_Group = sample(
    c("Young", "Old"),
    n,
    replace = TRUE,
    prob = c(0.5, 0.5)                        # 50/50 split
  )
)

# Define Lung Cancer risk based on Smoking and Occupational Exposure
data$Lung_Cancer <- NA

for (i in 1:nrow(data)) {
  if (data$Smoking[i] == 1 & data$Occupational_Exposure[i] == 1) {
    data$Lung_Cancer[i] <- rbinom(1, 1, 0.6)
  } else if (data$Smoking[i] == 1) {
    data$Lung_Cancer[i] <- rbinom(1, 1, 0.3)
  } else if (data$Occupational_Exposure[i] == 1) {
    data$Lung_Cancer[i] <- rbinom(1, 1, 0.2)
  } else {
    data$Lung_Cancer[i] <- rbinom(1, 1, 0.1)
  }
}

# Preview the dataset
head(data)

# Optional: Export the dataset
# write.csv(data, "Smoking_LungCancer_Dataset.csv", row.names = FALSE)


# ----------------------------------------------------------
# Identifying Confounding
# ----------------------------------------------------------

# Load epiR for epidemiological analysis
if (!require("epiR"))
  install.packages("epiR")
library(epiR)

# Create a 2x2 table: Smoking (Exposure) vs Lung Cancer (Outcome)
table_crude <- table(data$Smoking, data$Lung_Cancer)
print(table_crude)

# Compute crude odds ratio (unadjusted)
crude_or <- epi.2by2(table_crude)
print(crude_or)

# Logistic regression adjusting for Occupational Exposure (Confounder)
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure,
                 data = data,
                 family = binomial)

# Regression summary
summary(model_adj)

# Extract adjusted odds ratios and 95% confidence intervals
exp(cbind(OR = coef(model_adj), confint(model_adj)))


# ----------------------------------------------------------
# Stratified Analysis (Assessing Effect Modification)
# ----------------------------------------------------------

# Stratify by Age Group and compute separate odds ratios
young_data <- subset(data, Age_Group == "Young")
old_data   <- subset(data, Age_Group == "Old")

# Odds ratio for Young Age Group
table_young <- table(young_data$Smoking, young_data$Lung_Cancer)
young_or <- epi.2by2(table_young)
print(young_or)

# Odds ratio for Old Age Group
table_old <- table(old_data$Smoking, old_data$Lung_Cancer)
old_or <- epi.2by2(table_old)
print(old_or)


# ----------------------------------------------------------
# Testing for Confounding vs. Effect Modification
# ----------------------------------------------------------

## Step 1: Logistic Regression WITHOUT Interaction (Confounding)
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure,
                 data = data,
                 family = binomial)

summary(model_adj)
exp(cbind(OR = coef(model_adj), confint(model_adj)))


## Step 2: Logistic Regression WITH Interaction (Effect Modification)
model_interaction <- glm(Lung_Cancer ~ Smoking * Age_Group,
                         data = data,
                         family = binomial)

summary(model_interaction)
exp(cbind(OR = coef(model_interaction), confint(model_interaction)))


# ----------------------------------------------------------
# Controlling for Confounding
# ----------------------------------------------------------

## Step 1: Stratification (Manual Control for Confounding)

# Stratify by Occupational Exposure and compute separate ORs
high_exposure <- subset(data, Occupational_Exposure == 1)
low_exposure  <- subset(data, Occupational_Exposure == 0)

# Odds ratio for High Occupational Exposure group
table_high <- table(high_exposure$Smoking, high_exposure$Lung_Cancer)
high_or <- epi.2by2(table_high)
print(high_or)

# Odds ratio for Low Occupational Exposure group
table_low <- table(low_exposure$Smoking, low_exposure$Lung_Cancer)
low_or <- epi.2by2(table_low)
print(low_or)


## Step 2: Logistic Regression (Adjusting for Confounding)
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure,
                 data = data,
                 family = binomial)

summary(model_adj)
exp(cbind(OR = coef(model_adj), confint(model_adj)))


# ----------------------------------------------------------
# End of Script
# ----------------------------------------------------------
