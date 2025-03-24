################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Indirect Standardization (SMR Calculation)
################################################################################

# ==============================================================================
# STEP 1: Define the Data
# ==============================================================================

# Age groups
age_groups <- c("0-19", "20-39", "40-59", "60+")

# Study Population - Age Group Sizes
study_pop <- c(5000, 7000, 4000, 3000)

# Standard Population - Age-specific Mortality Rates (per 1,000 population)
standard_rates <- c(1.5, 4.0, 12.0, 40.0)

# Observed deaths in the study population (actual data collected)
observed_deaths <- c(8, 25, 50, 150)

# ==============================================================================
# STEP 2: Calculate Expected Deaths Using Standard Rates
# ==============================================================================

# Expected deaths = Standard rates * Study population / 1,000
expected_deaths <- standard_rates * study_pop / 1000

# ==============================================================================
# STEP 3: Compute SMR (Standardized Mortality Ratio)
# ==============================================================================

# Total observed deaths
total_observed <- sum(observed_deaths)

# Total expected deaths
total_expected <- sum(expected_deaths)

# SMR = Observed / Expected
SMR <- total_observed / total_expected

# ==============================================================================
# STEP 4: Output the Results
# ==============================================================================

# Create a summary table
indirect_standardization_table <- data.frame(
  Age_Group = age_groups,
  Study_Pop = study_pop,
  Standard_Rate_per1000 = standard_rates,
  Observed_Deaths = observed_deaths,
  Expected_Deaths = round(expected_deaths, 2)
)

# Print the table and SMR
print("Indirect Standardization (SMR) Summary Table")
print(indirect_standardization_table)

cat("\nStandardized Mortality Ratio (SMR):", round(SMR, 2), "\n")

################################################################################
# END OF SCRIPT
################################################################################
