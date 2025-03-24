################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Propensity Score Matching (PSM)
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries
# ==============================================================================

# Install if not already installed:
# install.packages("MatchIt")
# install.packages("cobalt")
if (!require("MatchIt")) install.packages("MatchIt")
if (!require("cobalt")) install.packages("cobalt")

library(MatchIt)  # For matching
library(cobalt)   # For balance diagnostics and plots

# ==============================================================================
# STEP 2: Simulate a Dataset
# ==============================================================================

set.seed(123)

n <- 300  # Number of individuals

# Simulate baseline covariates
data <- data.frame(
  age = rnorm(n, mean = 50, sd = 10),
  sex = sample(c("Male", "Female"), n, replace = TRUE),
  bmi = rnorm(n, mean = 25, sd = 4),
  comorbidity_score = rpois(n, lambda = 2)
)

# Treatment assignment based on covariates (simulating confounding)
data$treated <- rbinom(n,
                       1,
                       prob = plogis(
                         -5 + 0.08 * data$age + 0.5 * (data$sex == "Male") + 0.1 * data$comorbidity_score
                       ))

# Examine the first few rows
head(data)

# ==============================================================================
# STEP 3: Estimate Propensity Scores
# ==============================================================================

ps_model <- glm(treated ~ age + sex + bmi + comorbidity_score,
                data = data,
                family = binomial)

# Add predicted propensity scores to data
data$pscore <- predict(ps_model, type = "response")

# ==============================================================================
# STEP 4: Perform Nearest Neighbor Matching
# ==============================================================================

match.it <- matchit(
  treated ~ age + sex + bmi + comorbidity_score,
  data = data,
  method = "nearest",
  distance = "logit"
)

# Summary of matching
summary(match.it,un=TRUE)

# ==============================================================================
# STEP 5: Assess Covariate Balance (Before and After Matching)
# ==============================================================================

# Balance table
bal.tab(match.it)

# Love plot of standardized mean differences
love.plot(match.it,
          stat = "mean.diffs",
          threshold = 0.1,
          abs = TRUE)

# Propensity score distribution before and after matching
plot(match.it, type = "jitter", interactive = FALSE)


# ==============================================================================
# STEP 6: Extract Matched Data
# ==============================================================================

matched_data <- match.data(match.it)

# Check the matched dataset
head(matched_data)

# ==============================================================================
# STEP 7: Outcome Analysis on Matched Data (Example)
# ==============================================================================

# Simulate an outcome variable for demonstration
set.seed(321)
matched_data$outcome <- with(matched_data,
                             0.5 * treated + 0.02 * age + 0.3 * (sex == "Male") + rnorm(nrow(matched_data)))

# Simple linear regression of outcome ~ treatment (unadjusted, since matching balanced covariates)
outcome_model <- lm(outcome ~ treated, data = matched_data)

summary(outcome_model)

################################################################################
# END OF SCRIPT
################################################################################
