################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Stratification, Mantel-Haenszel Analysis, and Visualization
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries
# ==============================================================================

# Install epiR and forestplot if not already installed
if (!require("epiR")) install.packages("epiR")
if (!require("forestplot")) install.packages("forestplot")

library(epiR)       # For epidemiologic analyses
library(forestplot) # For plotting forest plots

# ==============================================================================
# STEP 2: Create 2x2 Tables Stratified by Confounder (Age Group)
# ==============================================================================

# Define the strata tables
age_under50 <- matrix(
  c(30, 20,   # Smokers (Exposed): Cases, Controls
    10, 40),  # Non-Smokers (Unexposed): Cases, Controls
  nrow = 2, byrow = TRUE
)

age_50plus <- matrix(
  c(50, 30,   # Smokers (Exposed): Cases, Controls
    20, 50),  # Non-Smokers (Unexposed): Cases, Controls
  nrow = 2, byrow = TRUE
)

# Combine both strata into a 3D array
tables <- array(
  c(age_under50, age_50plus),  # Combine matrix data
  dim = c(2, 2, 2),            # Dimensions: 2x2x2 (2 strata)
  dimnames = list(
    Outcome = c("Case", "Control"),
    Exposure = c("Smoker", "Non-Smoker"),
    Stratum = c("Age <50", "Age ≥50")
  )
)

# ==============================================================================
# STEP 3: Mantel-Haenszel Stratified Analysis
# ==============================================================================

mh_result <- epi.2by2(
  dat = tables,
  method = "cohort.count"      # Since we are dealing with counts
)

# Output summary results
print(mh_result)

# ==============================================================================
# STEP 4: Extract Odds Ratios and Confidence Intervals for Forest Plot
# ==============================================================================

# Extract stratum-specific ORs and Mantel-Haenszel summary OR
stratum_or <- mh_result$massoc.detail$OR.strata.wald$est
stratum_ci_lower <- mh_result$massoc.detail$OR.strata.wald$lower
stratum_ci_upper <- mh_result$massoc.detail$OR.strata.wald$upper

# Extract Mantel-Haenszel summary OR and CI
mh_or <- mh_result$massoc.detail$OR.mh.wald$est
mh_ci_lower <- mh_result$massoc.detail$OR.mh.wald$lower
mh_ci_upper <- mh_result$massoc.detail$OR.mh.wald$upper

# Combine results into a matrix for the forest plot
labels <- c("Age < 50", "Age ≥ 50", "Mantel-Haenszel Summary")
or_values <- rbind(
  c(stratum_or[1], stratum_ci_lower[1], stratum_ci_upper[1]),
  c(stratum_or[2], stratum_ci_lower[2], stratum_ci_upper[2]),
  c(mh_or, mh_ci_lower, mh_ci_upper)
)

# ==============================================================================
# STEP 5: Create and Display Forest Plot
# ==============================================================================

# Prepare text for forest plot
tabletext <- cbind(
  labels,
  sprintf("%.2f (%.2f - %.2f)", or_values[, 1], or_values[, 2], or_values[, 3])
)

# Generate forest plot
forestplot(
  labeltext = tabletext,
  mean = or_values[, 1],
  lower = or_values[, 2],
  upper = or_values[, 3],
  zero = 1,                     # Reference line at OR = 1
  boxsize = 0.1,
  lineheight = unit(10, "mm"),
  col = fpColors(box = "blue", lines = "black", zero = "red"),
  xlab = "Odds Ratio (95% CI)",
  title = "Forest Plot of Odds Ratios by Age Group\nand Mantel-Haenszel Summary"
)

# ==============================================================================
# STEP 6: Homogeneity Assessment Interpretation
# ==============================================================================

# Extract the Breslow-Day test p-value for homogeneity
homogeneity_p <- mh_result$massoc.detail$wOR.homog$p.value  # Correct access to p-value
cat("\nBreslow-Day Test for Homogeneity p-value:", homogeneity_p, "\n")

# Interpret the p-value
if (homogeneity_p > 0.05) {
  cat("✅ No significant heterogeneity detected. Mantel-Haenszel summary OR is appropriate.\n")
} else {
  cat("⚠️ Significant heterogeneity detected! Consider stratum-specific ORs instead of a summary measure.\n")
}

################################################################################
# END OF SCRIPT
################################################################################
