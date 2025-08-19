

library(glmnet)
library(ISLR)
data(College)
str(College)
summary(College)

# Part a----------
set.seed(123) 
n <- nrow(College)
train_indices <- sample(1:n, size = 0.7 * n)  # 70% for training
train_data <- College[train_indices, ]
test_data <- College[-train_indices, ]
cat("Training set size:", nrow(train_data), "\n")
cat("Test set size:", nrow(test_data), "\n")

# Prep data 
train_x <- model.matrix(Apps ~ . - 1, data = train_data)
test_x <- model.matrix(Apps ~ . - 1, data = test_data)

# Extract response variables
train_y <- train_data$Apps
test_y <- test_data$Apps

# Part b----------
# Fit LASSO regression with a range of lambda values
lasso_fit <- glmnet(train_x, train_y, alpha = 1)

# Part c:----------
cv_lasso <- cv.glmnet(train_x, train_y, alpha = 1, nfolds = 10)

# Get the best lambda values
best_lambda_min <- cv_lasso$lambda.min
best_lambda_1se <- cv_lasso$lambda.1se

cat("Best lambda (min MSE):", best_lambda_min, "\n")
cat("Best lambda (1SE rule):", best_lambda_1se, "\n")

# Plot cross validation results
plot(cv_lasso)

# Part d:----------
#  predictions using lambda.min  
pred_lasso_min <- predict(lasso_fit, s = best_lambda_min, newx = test_x)
test_mse_min <- mean((test_y - pred_lasso_min)^2)

# predictions using lambda.1se 
pred_lasso_1se <- predict(lasso_fit, s = best_lambda_1se, newx = test_x)
test_mse_1se <- mean((test_y - pred_lasso_1se)^2)
cat("Test MSE using lambda.min:", test_mse_min, "\n")
cat("Test MSE using lambda.1se:", test_mse_1se, "\n")

#  coefficients for the best model
coef_lasso <- coef(lasso_fit, s = best_lambda_min)
cat("Number of non-zero coefficients:", sum(coef_lasso != 0) - 1, "\n") 
#nonzeros
non_zero_coef <- coef_lasso[coef_lasso != 0]
cat("Non-zero coefficients:\n")
print(non_zero_coef)
# Compare 
ols_fit <- lm(Apps ~ ., data = train_data)
ols_pred <- predict(ols_fit, newdata = test_data)
ols_mse <- mean((test_y - ols_pred)^2)

cat("OLS Test MSE:", ols_mse, "\n")
cat("LASSO Test MSE (lambda.min):", test_mse_min, "\n")
cat("Improvement:", (ols_mse - test_mse_min) / ols_mse * 100, "%\n")

# simmary 
cat("\n=== SUMMARY ===\n")
cat("Training set size:", nrow(train_data), "\n")
cat("Test set size:", nrow(test_data), "\n")
cat("Best lambda (min MSE):", best_lambda_min, "\n")
cat("Best lambda (1SE rule):", best_lambda_1se, "\n")
cat("Number of non-zero coefficients:", sum(coef_lasso != 0) - 1, "\n")
cat("Test MSE (LASSO, lambda.min):", test_mse_min, "\n")
cat("Test MSE (OLS):", ols_mse, "\n")
