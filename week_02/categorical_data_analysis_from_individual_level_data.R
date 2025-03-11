# categorical_data_analysis_from_individual_level_data.R

# This introduces the student to categorical data analysis from
# individual level data
# This dataset includes 100 observations with columns:
#  ID: Unique participant identifier.
#  Smoking_Status: Smoker or Non-Smoker.
#  Lung_Cancer: Yes or No.
# Age_Group: <50 years or ≥50 years (for stratification).

# Load the dataset: -------------------------------------------------------
getwd() # check the working directory to ensure you have paths correct
data <- read.csv("week_02/Smoking_LungCancer_Dataset.csv")
head(data)


# Approach 1: Individual-Level Analysis -----------------------------------

# Step 1: Load the Dataset in R (already done)
# Step 2: Perform a Chi-Square Test Using Individual-Level Data
# Perform Chi-Square test
table1 <- table(data$Smoking, data$Lung_Cancer)
chi_test <- chisq.test(table1)
print(chi_test)

# Step 3: Estimate a Crude Odds Ratio (OR) from Aggregated Data

# Extract counts from contingency table
a <- table1[1, 1]  # Cases in exposed
d <- table1[2, 2]  # Non-cases in unexposed
b <- table1[1, 2]  # Non-cases in exposed
c <- table1[2, 1]  # Cases in unexposed

# Compute crude odds ratio
crude_or <- (a * d) / (b * c)
print(crude_or)

# Step 4: Perform Fisher’s Exact Test (for small expected counts)
# Perform Fisher’s Exact Test
fisher_test <- fisher.test(table1)
print(fisher_test)

# Approach 2: Aggregated 2x2 Contingency Table Analysis -------------------

# Step 1: Construct an Aggregated 2x2 Contingency Table
# Create contingency table from individual-level data
contingency_table <-
  table(data$Smoking, data$Lung_Cancer, dnn = c("Smoking", "Lung Cancer"))

# Display the contingency table
print(contingency_table)

# While the table created thus can still provide proper estimates, it is not
# they typical epidemiological contingency table
# This behaviour can be fixed using the factor() function as below
epi_contingency_table <-
  table(
    factor(data$Smoking, levels = c(1, 0)),
    factor(data$Lung_Cancer, levels = c(1, 0)),
    dnn = c("Smoking", "Lung Cancer")
  )

# Display the contingency table
print(epi_contingency_table)

# Step 2: Perform a Chi-Square Test Using Aggregated Data
# Perform Chi-Square test
chi_test <- chisq.test(epi_contingency_table)
print(chi_test)

# Step 3: Perform Fisher’s Exact Test (if expected counts are low)
# Perform Fisher’s Exact Test
fisher_test <- fisher.test(epi_contingency_table)
print(fisher_test)

# Step 4: Perform Mantel-Haenszel Test Using Aggregated Data
# Perform Mantel-Haenszel Test
mh_test <-
  mantelhaen.test(table(data$Smoking, data$Lung_Cancer, data$Age_Group))
print(mh_test)
