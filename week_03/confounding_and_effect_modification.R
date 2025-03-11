# Script hpg6104_con_eff_mod.R  -----------------------------------------

# Load necessary libraries
sourceDir(RSCRIPTS)
if (!require("dplyr"))
  install.packages("dplyr")
library(dplyr)
# Set seed for reproducibility
set.seed(123)

# Generate synthetic dataset ----------------------------------------------

# Set seed for reproducibility
set.seed(123)

# Generate synthetic dataset
n <- 500  # Sample size

data <- data.frame(
  Smoking = rbinom(n, 1, 0.4),
  # 40% Smokers
  Occupational_Exposure = rbinom(n, 1, 0.3),
  # 30% High-Risk Jobs
  Age_Group = sample(
    c("Young", "Old"),
    n,
    replace = TRUE,
    prob = c(0.5, 0.5)
  )  # 50/50 split
)

# Define lung cancer risk based on Smoking and Occupational Exposure
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

# Preview the data
head(data)

# Export if needed
# write.csv(data, "Smoking_LungCancer_Dataset.csv", row.names = FALSE)


# Identifying Confounding -------------------------------------------------

# Load necessary library
if (!require("epiR"))
  install.packages("epiR")
library(epiR)

# Create a 2x2 table for Smoking (X) and Lung Cancer (Y)
table_crude <- table(data$Smoking, data$Lung_Cancer)
print(table_crude)

# Compute the crude odds ratio (unadjusted)
crude_or <- epi.2by2(table_crude)
print(crude_or)

# Compute the Adjusted Odds Ratio (Adjusted for Confounder)
# Logistic regression adjusting for Occupational Exposure (Confounder)
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure,
                 data = data,
                 family = binomial)
summary(model_adj)

# Extract odds ratio and confidence intervals
exp(cbind(OR = coef(model_adj), confint(model_adj)))


# Stratified Analysis (Checking for Effect Modification)  --------


# Stratify by Age Group and compute separate ORs
young_data <- subset(data, Age_Group == "Young")
old_data <- subset(data, Age_Group == "Old")

# Compute odds ratio for young group
table_young <- table(young_data$Smoking, young_data$Lung_Cancer)
young_or <- epi.2by2(table_young)
print(young_or)

# Compute odds ratio for old group
table_old <- table(old_data$Smoking, old_data$Lung_Cancer)
old_or <- epi.2by2(table_old)
print(old_or)

# Testing for Confounding vs. Effect Modification -------------------------

# Step 1: Fit a Logistic Regression Model Without Interaction 
# (Checking for Confounding)

# Logistic regression adjusting for occupational exposure (Confounder)
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure,
                 data = data,
                 family = binomial)
summary(model_adj)

# Extract odds ratios and confidence intervals
exp(cbind(OR = coef(model_adj), confint(model_adj)))

# Step 2: Fit a Logistic Regression Model With an Interaction Term (Checking for Effect Modification)
# Logistic regression with interaction term for Smoking & Age Group
model_interaction <- glm(Lung_Cancer ~ Smoking * Age_Group,
                         data = data,
                         family = binomial)
summary(model_interaction)

# Extract odds ratios
exp(cbind(OR = coef(model_interaction), confint(model_interaction)))


# Controlling for Confounding ---------------------------------------------

# Step 1: Stratification (Manually Adjusting for Confounding)
# Stratify by Occupational Exposure and compute separate ORs
high_exposure <- subset(data, Occupational_Exposure == 1)
low_exposure <- subset(data, Occupational_Exposure == 0)

# Compute odds ratio for high occupational exposure group
table_high <- table(high_exposure$Smoking, high_exposure$Lung_Cancer)
high_or <- epi.2by2(table_high)
print(high_or)

# Compute odds ratio for low occupational exposure group
table_low <- table(low_exposure$Smoking, low_exposure$Lung_Cancer)
low_or <- epi.2by2(table_low)
print(low_or)

#Step 2: Adjusting for Confounding Using Logistic Regression
# Logistic regression adjusting for confounder
model_adj <- glm(Lung_Cancer ~ Smoking + Occupational_Exposure, data = data, family = binomial)
summary(model_adj)

# Extract odds ratios and confidence intervals
exp(cbind(OR = coef(model_adj), confint(model_adj)))


