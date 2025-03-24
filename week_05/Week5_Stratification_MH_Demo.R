################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Stratification and Mantel-Haenszel Analysis
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries
# ==============================================================================

# Load custom scripts (assuming RSCRIPTS is defined elsewhere)
# sourceDir(RSCRIPTS)

# Install epiR if not already installed (uncomment the next line if needed)
# install.packages("epiR")

# Load the epiR package for epidemiologic analysis
library(epiR)

# ==============================================================================
# STEP 2: Create 2x2 Tables Stratified by Confounder (Age Group)
# ==============================================================================

# This example examines the association between Smoking (Exposure)
# and Lung Cancer (Outcome), stratified by Age Group.

# Each 2x2 table format is:
#              Lung Cancer
# Smoking       Yes     No
# --------------------------
# Yes           a       b
# No            c       d

# ------------------------------------------------------------------------------
# Stratum 1: Age < 50
# ------------------------------------------------------------------------------
# Smokers with cancer: 30
# Smokers without cancer: 20
# Non-smokers with cancer: 10
# Non-smokers without cancer: 40

age_under50 <- matrix(
  c(30, 20,   # Smokers (Exposed): Cases, Controls
    10, 40),  # Non-Smokers (Unexposed): Cases, Controls
  nrow = 2, byrow = TRUE
)

# ------------------------------------------------------------------------------
# Stratum 2: Age ≥ 50
# ------------------------------------------------------------------------------
# Smokers with cancer: 50
# Smokers without cancer: 30
# Non-smokers with cancer: 20
# Non-smokers without cancer: 50

age_50plus <- matrix(
  c(50, 30,   # Smokers (Exposed): Cases, Controls
    20, 50),  # Non-Smokers (Unexposed): Cases, Controls
  nrow = 2, byrow = TRUE
)

# Combine both strata into a list for analysis
tables <- list(age_under50, age_50plus)

# ==============================================================================
# STEP 3: Perform Mantel-Haenszel Stratified Analysis
# ==============================================================================

# Run Mantel-Haenszel analysis
mh_result <- epi.2by2(
  dat = tables,
  method = "cohort.count",  # Use 'cohort.count' because we have counts, not person-time
  homogeneity = "breslow.day"  # Perform the Breslow-Day test for homogeneity
)

# ==============================================================================
# STEP 4: View Results
# ==============================================================================

# Output the summary of results
print(mh_result)

# ==============================================================================
# STEP 5: Interpret the Results
# ==============================================================================

# The output includes:
# - Stratum-specific Odds Ratios (ORs) with 95% Confidence Intervals
# - Mantel-Haenszel Combined (Adjusted) OR with CI
# - Breslow-Day Test for Homogeneity p-value

# If Breslow-Day test p > 0.05:
#   - There is no significant heterogeneity → OK to use Mantel-Haenszel summary OR.
# If p < 0.05:
#   - Significant heterogeneity suggests potential effect modification → 
#     report stratum-specific ORs.

# ==============================================================================
# Notes:
# - epiR::epi.2by2() uses different methods: cohort.count, cohort.time, case.control
#   - Use 'case.control' when analyzing case-control study odds ratios.
# - You can add more strata as needed.
# ==============================================================================

################################################################################
# END OF SCRIPT
################################################################################
