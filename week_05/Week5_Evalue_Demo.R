################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: E-value Calculation
################################################################################

# ==============================================================================
# STEP 1: Load Required Library
# ==============================================================================

# Install the EValue package if not already installed
# install.packages("EValue")

if (!require("EValue"))
  install.packages("EValue")

library(EValue)

# ==============================================================================
# STEP 2: Define Observed Effect Estimate
# ==============================================================================

# Example: Assume an observed Risk Ratio (RR) of 2.5
# Confidence Interval (CI): 1.8 to 3.2

rr <- 2.5
lower_ci <- 1.8
upper_ci <- 3.2

# ==============================================================================
# STEP 3: Calculate E-values
# ==============================================================================

# Calculate E-value for point estimate and confidence interval
evalue_rr <- evalues.RR(est = rr, lo = lower_ci, hi = upper_ci, true = 1)

# Display E-value results
print(evalue_rr)

# ==============================================================================
# STEP 4: Interpret Results
# ==============================================================================

# The output includes:
# - E-value for the point estimate
# - E-value for the lower bound of the confidence interval
# - These show the minimum strength of association an unmeasured confounder
#   would need to have (with both exposure and outcome) to nullify the result.

################################################################################
# END OF SCRIPT
################################################################################
