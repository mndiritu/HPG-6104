################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Stratification, Mantel-Haenszel Analysis, and Visualization
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries
# ==============================================================================

# Install epiR and forestplot if not already installed
# install.packages("epiR")
# install.packages("forestplot")

library(epiR)        # For epidemiologic analyses
library(forestplot)  # For plotting forest plots

# ==============================================================================
# STEP 2: Create 2x2 Tables Stratified by Confounder (Age Group)
# ==============================================================================

# Define the strata tables
age_under50 <- matrix(c(30, 20, 10, 40), nrow = 2, byrow = TRUE)
age_50plus  <- matrix(c(50, 30, 20, 50), nrow = 2, byrow = TRUE)

# Combine strata into a list
tables <- list(age_under50, age_50plus)

# ==============================================================================
# STEP 3: Mantel-Haenszel Stratified Analysis
# ==============================================================================

mh_result <- epi.2by2(
  dat = tables,
  method = "cohort.count",      # Since we are dealing with counts
  homogeneity = "breslow.day"   # Perform Breslow-Day test for homogeneity
)

# Output summary results
print(mh_result)

# ==============================================================================
# STEP 4: Extract Odds Ratios and Confidence Intervals for Forest Plot
# ==============================================================================

# Retrieve stratum-specific ORs
or_stratum1 <- mh_result$stratum$`age_under50`$OR.strata.wald
or_stratum2 <- mh_result$stratum$`age_50plus`$OR.strata.wald

# Retrieve the Mantel-Haenszel combined OR
or_mh <- mh_result$massoc$OR.mh.wald

# Create labels for the strata and overall
labels <- c("Stratum: Age < 50", "Stratum: Age ≥ 50", "Mantel-Haenszel Summary")

# Compile ORs and 95% CIs into a matrix
or_values <- rbind(
  c(or_stratum1[1], or_stratum1[2], or_stratum1[3]),  # Stratum 1
  c(or_stratum2[1], or_stratum2[2], or_stratum2[3]),  # Stratum 2
  c(or_mh[1], or_mh[2], or_mh[3])                     # Mantel-Haenszel
)

# ==============================================================================
# STEP 5: Create and Display Forest Plot
# ==============================================================================

# Combine labels and ORs for forest plot table
tabletext <- cbind(
  labels,
  sprintf("%.2f (%.2f - %.2f)", or_values[, 1], or_values[, 2], or_values[, 3])
)

# Plot
forestplot(
  labeltext = tabletext,
  mean = or_values[, 1],
  lower = or_values[, 2],
  upper = or_values[, 3],
  zero = 1,                     # Reference line at OR = 1
  boxsize = 0.1,
  lineheight = unit(10, "mm"),
  col = forestplot::fpColors(box = "blue", lines = "black", zero = "red"),
  xlab = "Odds Ratio (95% CI)",
  title = "Forest Plot of Odds Ratios by Age Group\nand Mantel-Haenszel Summary"
)

# ==============================================================================
# STEP 6: Homogeneity Assessment Interpretation
# ==============================================================================

# Breslow-Day test p-value for homogeneity
homogeneity_p <- mh_result$homogeneity$`breslow.day`$p.value
cat("\nBreslow-Day Test for Homogeneity p-value:", homogeneity_p, "\n")

if (homogeneity_p > 0.05) {
  cat("✅ No significant heterogeneity detected. Mantel-Haenszel summary OR is appropriate.\n")
} else {
  cat("⚠️ Significant heterogeneity detected! Consider stratum-specific ORs instead of a summary measure.\n")
}

################################################################################
# END OF SCRIPT
################################################################################
