# categorical_data_analysis_from_individual_level_data.R
# ======================================================
#
# This script introduces the student to categorical data analysis 
# from individual-level data.
#
# Dataset:
# --------
#  - 100 observations with the following columns:
#      ID             : Unique participant identifier
#      Smoking_Status : Smoker or Non-Smoker
#      Lung_Cancer    : Yes or No
#      Age_Group      : <50 years or ≥50 years (for stratification)
#

# -------------------------------------------------------------------
# Load the Dataset
# -------------------------------------------------------------------

getwd()  # Check the working directory to ensure you have paths correct

data <- read.csv("week_02/Smoking_LungCancer_Dataset.csv")
head(data)


# -------------------------------------------------------------------
# Approach 1: Individual-Level Analysis
# -------------------------------------------------------------------

## Step 1: Perform a Chi-Square Test Using Individual-Level Data
table1 <- table(data$Smoking, data$Lung_Cancer)
chi_test <- chisq.test(table1)

print(chi_test)

## Step 2: Estimate a Crude Odds Ratio (OR) from Aggregated Data

# Extract counts from contingency table
a <- table1[1, 1]  # Cases in exposed (Smoking = 1, Lung_Cancer = 1)
b <- table1[1, 2]  # Non-cases in exposed
c <- table1[2, 1]  # Cases in unexposed
d <- table1[2, 2]  # Non-cases in unexposed

# Compute crude odds ratio
crude_or <- (a * d) / (b * c)

print(crude_or)

## Step 3: Perform Fisher’s Exact Test (for small expected counts)
fisher_test <- fisher.test(table1)

print(fisher_test)


# -------------------------------------------------------------------
# Approach 2: Aggregated 2x2 Contingency Table Analysis
# -------------------------------------------------------------------

## Step 1: Construct an Aggregated 2x2 Contingency Table

# Default table (may not follow epidemiological conventions)
contingency_table <- table(
  data$Smoking,
  data$Lung_Cancer,
  dnn = c("Smoking", "Lung Cancer")
)

print(contingency_table)

# Better formatted epidemiological table (1 before 0)
epi_contingency_table <- table(
  factor(data$Smoking, levels = c(1, 0)),
  factor(data$Lung_Cancer, levels = c(1, 0)),
  dnn = c("Smoking", "Lung Cancer")
)

print(epi_contingency_table)


## Step 2: Perform a Chi-Square Test Using Aggregated Data
chi_test_epi <- chisq.test(epi_contingency_table)

print(chi_test_epi)


## Step 3: Perform Fisher’s Exact Test (if expected counts are low)
fisher_test_epi <- fisher.test(epi_contingency_table)

print(fisher_test_epi)


## Step 4: Perform Mantel-Haenszel Test (Stratified by Age Group)
mh_test <- mantelhaen.test(
  table(data$Smoking, data$Lung_Cancer, data$Age_Group)
)

print(mh_test)

# -------------------------------------------------------------------
# End of Script
# -------------------------------------------------------------------
