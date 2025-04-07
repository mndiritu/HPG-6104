# Load built-in dataset
data(mtcars)

# Convert 'am' (0 = automatic, 1 = manual) to factor for binary outcome
mtcars$am <- factor(mtcars$am, labels = c("Automatic", "Manual"))

# Fit logistic regression model
model <- glm(am ~ mpg + hp, data = mtcars, family = binomial)

# Summary of the model
summary(model)
