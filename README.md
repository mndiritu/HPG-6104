

---

# HPG 6104: Epidemiological Methods II - R Practicals

Welcome to the **HPG 6104: Epidemiological Methods II - R Practicals** repository. This repository is designed to help you apply key epidemiological methods using R as part of the **Master of Public Health Data Science** curriculum.

This repository complements the lecture content and assessments in **HPG 6104**, covering core concepts such as measures of disease frequency, causal inference, confounding, logistic regression, and modern approaches like machine learning in epidemiology.

---

## 📚 Course Overview
HPG 6104 focuses on advanced epidemiologic methods, providing learners with the skills to:
- Conceptualize and design observational epidemiologic studies
- Calculate and interpret measures of association between exposures and disease
- Address confounding, selection bias, and information bias
- Apply causal inference frameworks including DAGs
- Test research hypotheses using stratification, standardization, and logistic regression
- Utilize machine learning methods on large health datasets

---

## 🛠️ Repository Structure
```
/datasets/       # Sample datasets used in practicals
/week_01/        # Measures of Disease Frequency & Association (Prevalence, Incidence, RR, OR, PAR%)
/week_02/        # Contingency Tables and Categorical Data Analysis (Chi-Square, Mantel-Haenszel)
/week_03/        # Confounding and Effect Modification (Stratification, DAGs)
/week_04/        # Causal Inference (Exchangeability, Counterfactuals, DAGs)
/week_05/        # Advanced Confounding Control (Matching, Standardization, Propensity Scores)
/week_06/        # Logistic Regression (Modeling, OR Interpretation, Adjusting for Confounding)
/week_07/        # Study Designs (Cross-sectional, Case-control, Cohort, RCTs)
/week_08/        # Bias and Validity (Selection Bias, Information Bias)
/week_09/        # Machine Learning in Epidemiology (Prediction vs. Causal Models)
/utils/          # Reusable functions and code snippets
```

---

## 🧰 Getting Started

### Prerequisites
- R (version ≥ 4.0.0)
- RStudio (optional but recommended)
- Basic familiarity with R and epidemiology concepts (completed HPG 6103)

### Installing Required Packages
You can install all required packages with the following R script:

```r
install.packages(c("tidyverse", "epitools", "epiR", "foreign", "dplyr", "tableone", "ggplot2", "dagitty", "caret", "randomForest"))
```

---

## 📅 Weekly Practical Themes

| Week  | Topic                                                 | Key Concepts                                    |
|-------|-------------------------------------------------------|-------------------------------------------------|
| 1     | Measures of Disease Frequency & Association          | Incidence, Prevalence, RR, OR, AR, PAR%        |
| 2     | Categorical Data Analysis & Contingency Tables       | 2x2 Tables, Chi-square, Mantel-Haenszel        |
| 3     | Confounding and Effect Modification                  | DAGs, Stratified Analysis                      |
| 4     | Causal Inference in Epidemiology                     | Exchangeability, Counterfactuals, DAGs         |
| 5     | Advanced Confounding Control Measures                | Matching, Propensity Scores, Standardization   |
| 6     | Logistic Regression in Epidemiology                  | OR Interpretation, Model Fitting               |
| 7     | Epidemiologic Study Designs                          | Cross-sectional, Case-Control, Cohort, RCTs    |
| 8     | Bias and Validity                                    | Selection Bias, Information Bias               |
| 9     | Machine Learning in Epidemiology                    | Prediction Models, Causal Models, ML Tools     |

---

## 🔨 How to Use This Repository
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/HPG6104_RPracticals.git
   ```

2. Navigate into a week's folder:
   ```bash
   cd week_01
   ```

3. Open the R script in RStudio or run it directly in the R console:
   ```r
   source("week_01_measures_of_association.R")
   ```

4. Explore the datasets provided in `/datasets/` and modify scripts as needed for practice.

---

## ✅ Learning Outcomes
By the end of these practical sessions, you should be able to:
- Calculate and interpret measures of association and disease frequency
- Apply statistical tests to analyze categorical data
- Build and interpret logistic regression models
- Draw and interpret DAGs for causal inference
- Address confounding and effect modification using stratification and matching
- Implement basic machine learning algorithms in epidemiological research

---

## 📘 References & Resources
- **Essentials of Epidemiology in Public Health (4th Ed.)** - Ann Aschengrau & George Seage
- **Interpreting Epidemiologic Evidence (2nd Ed.)** - David A. Savitz
- **Epidemiology Matters** - Katherine M. Keyes & Sandro Galea
- R Documentation: [https://cran.r-project.org/manuals.html](https://cran.r-project.org/manuals.html)

---

## 👩🏾‍🏫 Course Coordinator
Dr. Moses Ndiritu  
Lecturer, Epidemiological Methods II  
Master of Public Health Data Science  
University of Nairobi
Email: mndiritu@gmail.com

---
