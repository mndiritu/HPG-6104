################################################################################
# HPG 6104 - Epidemiologic Methods II
# Week 5 Lecture: Advanced Confounding Control Measures
# Practical Example in R: Inverse Probability of Treatment Weighting (IPTW)
################################################################################

# ==============================================================================
# STEP 1: Load Required Libraries
# ==============================================================================

# Install if not already installed:
# install.packages("survey")    # For weighted analyses
# install.packages("cobalt")    # For balance diagnostics

if (!require("survey"))
  install.packages("survey")
if (!require("cobalt"))
  install.packages("cobalt")

library(survey)   # Weighted regression analysis
library(cobalt)   # For balance checking

# ==============================================================================
# STEP 2: Simulate a Dataset
# ==============================================================================

set.seed(123)

n <- 300  # Number of individuals

# Simulate covariates
data <- data.frame(
  age = rnorm(n, mean = 50, sd = 10),
  sex = sample(c("Male", "Female"), n, replace = TRUE),
  bmi = rnorm(n, mean = 25, sd = 4),
  comorbidity_score = rpois(n, lambda = 2)
)

# Treatment assignment depends on covariates (confounding!)
data$treated <- rbinom(n,
                       1,
                       prob = plogis(
                         -5 + 0.08 * data$age + 0.5 * (data$sex == "Male") + 0.1 * data$comorbidity_score
                       ))

# ==============================================================================
# STEP 3: Estimate Propensity Scores
# ==============================================================================

ps_model <- glm(treated ~ age + sex + bmi + comorbidity_score,
                data = data,
                family = binomial)

# Add PS to data
data$pscore <- predict(ps_model, type = "response")

# Examine PS distribution
hist(data$pscore, main = "Propensity Score Distribution", xlab = "Propensity Score")


# ==============================================================================
# STEP 4: Calculate IPT Weights
# ==============================================================================

# Inverse Probability of Treatment Weights (unstabilized)
data$iptw <- ifelse(data$treated == 1, 1 / data$pscore, 1 / (1 - data$pscore))

# Optional: Stabilized Weights (reduce variance)
p_treated <- mean(data$treated)
data$stabilized_iptw <- ifelse(data$treated == 1,
                               p_treated / data$pscore,
                               (1 - p_treated) / (1 - data$pscore))

# ==============================================================================
# STEP 5: Check Covariate Balance After Weighting
# ==============================================================================

# Balance diagnostics before and after weighting (cobalt package)
bal.tab(
  treated ~ age + sex + bmi + comorbidity_score,
  data = data,
  weights = data$iptw,
  method = "weighting"
)

# Love plot (Standardized Mean Differences)
love.plot(
  treated ~ age + sex + bmi + comorbidity_score,
  data = data,
  weights = data$iptw,
  method = "weighting",
  abs = TRUE,
  threshold = 0.1
)

# ==============================================================================
# STEP 6: Analyze Outcome in the Weighted Sample
# ==============================================================================

# Simulate an outcome variable (for illustration)
set.seed(321)
data$outcome <- with(data, 0.5 * treated + 0.02 * age + 0.3 * (sex == "Male") + rnorm(n))

# Create survey design object for weighted regression
design <- svydesign(ids = ~ 1,
                    weights = ~ iptw,
                    data = data)

# Weighted regression: Outcome ~ Treated
weighted_model <- svyglm(outcome ~ treated, design = design)

# Summary of the weighted model
summary(weighted_model)

################################################################################
# END OF SCRIPT
################################################################################
