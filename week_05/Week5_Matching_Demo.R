################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Individual Matching using MatchIt
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries and scripts
# ==============================================================================
# Load custom scripts (assuming RSCRIPTS is defined elsewhere)
# sourceDir(RSCRIPTS)

# MatchIt is a commonly used package for matching methods in observational data.
# It supports nearest neighbor matching, exact matching, and others.

# Install MatchIt if not already installed (uncomment if needed)
# install.packages("MatchIt")

# Load the package
if (!require("MatchIt"))
  install.packages("MatchIt")
library(MatchIt)

# ==============================================================================
# STEP 2: Simulate a Hypothetical Dataset
# ==============================================================================
# We'll simulate data for 200 individuals with:
# - treated: an exposure variable (1 = treated/exposed, 0 = untreated/unexposed)
# - age: a continuous covariate
# - sex: a categorical covariate (Male/Female)

set.seed(123)  # for reproducibility

n <- 200  # number of individuals

# Create the dataset
data <- data.frame(
  treated = rbinom(n, 1, 0.5),  # random assignment to treatment (50/50 chance)
  age = round(rnorm(n, mean = 50, sd = 10),0),  # normal distribution around 50 years
  sex = sample(c("Male", "Female"), n, replace = TRUE)  # random sex assignment
)

# View the first few rows of data
head(data)

# ==============================================================================
# STEP 3: Perform Nearest Neighbor Matching
# ==============================================================================
# Match treated and untreated participants based on age and sex.
# Method "nearest" finds the closest control for each treated subject.

# Run matching
match.out <- matchit(
  treated ~ age + sex,  # model formula for variables to match on
  data = data,          # the dataset
  method = "nearest"    # nearest neighbor matching method
)

# View a summary of matching results
summary(match.out)

# ==============================================================================
# STEP 4: Examine Covariate Balance
# ==============================================================================
# Check how well the matching balanced the confounders.
# Plot quantile-quantile plots for standardized mean differences.

# QQ plot of standardized mean differences before and after matching
plot(summary(match.out), type = "qq")

# ==============================================================================
# STEP 5: Extract the Matched Dataset
# ==============================================================================
# Create a new data frame with matched observations
matched.data <- match.data(match.out)

# View the first few rows of the matched dataset
head(matched.data)

# ==============================================================================
# STEP 6: Optional Analysis Post-Matching
# ==============================================================================
# For example, we can run a simple regression model on the matched data.
# Here we look at how treatment is associated with age (just for illustration).

model <- lm(age ~ treated, data = matched.data)
summary(model)

# ==============================================================================
# Notes:
# - Replace 'age' with your outcome variable in real data analysis.
# - Further analysis could involve logistic regression for binary outcomes,
#   survival analysis, etc.
# ==============================================================================

################################################################################
# END OF SCRIPT
################################################################################
