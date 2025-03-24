################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Direct Standardization
################################################################################

# ==============================================================================
# STEP 1: Create Data for Study and Standard Populations
# ==============================================================================

# Define age groups
age_groups <- c("0-19", "20-39", "40-59", "60+")

# Study Population - Age-specific Mortality Rates (per 1,000 people)
study_rates <- c(2, 5, 15, 50)

# Study Population - Age Group Sizes
study_pop <- c(5000, 7000, 4000, 3000)

# Standard Population - Age Group Sizes (the reference)
standard_pop <- c(6000, 6000, 4000, 4000)

# ==============================================================================
# STEP 2: Calculate Expected Deaths in the Standard Population
# ==============================================================================

# Expected deaths = Study rates (per 1,000) * Standard population / 1,000
expected_deaths <- study_rates * standard_pop / 1000

# ==============================================================================
# STEP 3: Calculate Age-Adjusted Rate
# ==============================================================================

# Age-adjusted rate = Sum of expected deaths / Total standard population * 1,000
total_expected_deaths <- sum(expected_deaths)
total_standard_pop <- sum(standard_pop)

adjusted_rate <- (total_expected_deaths / total_standard_pop) * 1000

# ==============================================================================
# STEP 4: Output the Results
# ==============================================================================

# Create a summary table for clarity
standardization_table <- data.frame(
  Age_Group = age_groups,
  Study_Rate_per1000 = study_rates,
  Standard_Pop = standard_pop,
  Expected_Deaths = expected_deaths
)

# Print the table and the adjusted rate
print("Direct Standardization Summary Table")
print(standardization_table)

cat("\nAge-Adjusted Mortality Rate (per 1,000 population):", round(adjusted_rate, 2), "\n")

################################################################################
# END OF SCRIPT
################################################################################
