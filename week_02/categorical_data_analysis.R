# categorical_data_analysis.R
# ============================================================
#
# This practical introduces the analysis of categorical data in R.
# You will analyze a dataset using contingency tables and common
# statistical tests.
#
# Example Dataset: Smoking and Lung Cancer Study
# ------------------------------------------------------------
# Variables:
#  - Smoking Status : Smoker / Non-Smoker
#  - Lung Cancer    : Yes / No
#

# ------------------------------------------------------------
# Load the Example Dataset
# ------------------------------------------------------------

data <- matrix(
  c(120, 30, 80, 170),
  nrow = 2,
  byrow = TRUE,
  dimnames = list(
    "Smoking Status" = c("Smoker", "Non-Smoker"),
    "Lung Cancer"    = c("Yes", "No")
  )
)

# View the data
print(data)


# ------------------------------------------------------------
# Perform a Chi-Square Test
# ------------------------------------------------------------

chi_test <- chisq.test(data)

# Display the Chi-Square test results
print(chi_test)


# ------------------------------------------------------------
# Perform Fisher’s Exact Test
# (Recommended if any expected counts are below 5)
# ------------------------------------------------------------

fisher_test <- fisher.test(data)

# Display the Fisher's Exact test results
print(fisher_test)


# ------------------------------------------------------------
# Add a Stratification Factor (e.g., Age Group)
# Perform a Mantel-Haenszel Test
# ------------------------------------------------------------

# Install the 'epitools' package if not already installed
if (!require('epitools')) {
  install.packages('epitools')
}

# Load the library
library(epitools)

# Create a 3-dimensional contingency table stratified by Age Group
data_strat <- array(
  c(60, 10, # <50 years: Smoker - Yes, No
    40, 90, # <50 years: Non-Smoker - Yes, No
    30, 5, # ≥50 years: Smoker - Yes, No
    40, 80    # ≥50 years: Non-Smoker - Yes, No),
    dim = c(2, 2, 2),
    dimnames = list(
      "Smoking"    = c("Smoker", "Non-Smoker"),
      "Lung Cancer" = c("Yes", "No"),
      "Age Group"   = c("<50 years", "≥50 years")
    )
  )
  
  # Perform Mantel-Haenszel Test
  mh_test <- mantelhaen.test(data_strat)
  
  # Display the Mantel-Haenszel test results
  print(mh_test)
  
  
  # ------------------------------------------------------------
  # Interpret the Results
  # ------------------------------------------------------------
  
  # - What do the p-values indicate about the associations?
  # - How does stratification affect the adjusted odds ratio?
  #
  # Mantel-Haenszel Adjusted OR = 12.91
  # => Smokers have approximately 12.91 times the odds of developing lung cancer
  #    compared to non-smokers, after adjusting for age.
  #
  # If the crude (unadjusted) OR was significantly higher or lower
  # than this adjusted OR, it would suggest confounding by age.
  #
  
  # ------------------------------------------------------------
  # End of Script
  # ------------------------------------------------------------
  