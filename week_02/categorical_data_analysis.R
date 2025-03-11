# categorical_data_analysis

# This practical introduces the analysis of categorical data in R
# Analyze a dataset using contingency tables and statistical tests in R.
# Load the following dataset in R
#(or use a dataset of your choice with categorical variables).
# It uses an Example dataset: Smoking and Lung Cancer Study

# Load the example dataset ------------------------------------------------

data <- matrix(
  c(120, 30, 80, 170),
  nrow = 2,
  byrow = TRUE,
  dimnames = list(
    "Smoking Status" = c("Smoker", "Non-Smoker"),
    "Lung Cancer" = c("Yes", "No")
  )
)
print(data)


# Perform a Chi-square test on the dataset: -------------------------------

chi_test <- chisq.test(data)
print(chi_test)


# If any expected counts are below 5, perform a Fisher’s exact tes --------

fisher_test <- fisher.test(data)
print(fisher_test)

# Add a stratification factor (e.g., age group) and perform a Mant --------

if(!require('epitools'))
  install.packages('epitools')
library(epitools)
data_strat <- array(
  c(60, 10, 40, 90, 30, 5, 40, 80),
  dim = c(2, 2, 2),
  dimnames = list(
    "Smoking" = c("Smoker", "Non-Smoker"),
    "Lung Cancer" = c("Yes", "No"),
    "Age Group" = c("<50 years", "≥50 years")
  )
)
mh_test <- mantelhaen.test(data_strat)
print(mh_test)


# Interpret the results: --------------------------------------------------

# What do the p-values indicate about the associations?
# How does stratification affect the adjusted odds ratio?
# Mantel-Haenszel Adjusted OR = 12.91, indicating that smokers 
# have approximately 12.91 times the odds of developing lung cancer 
# compared to non-smokers, after adjusting for age.
# If the crude (unadjusted) OR was significantly higher or 
# lower than this adjusted OR, it suggests confounding by age.

  
