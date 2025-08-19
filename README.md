# Homework 4: LASSO Regression Analysis

## Project Overview
This project implements LASSO (Least Absolute Shrinkage and Selection Operator) regression analysis on two different datasets: College admissions data and Major League Baseball player salary data. The project demonstrates the application of regularization techniques in statistical learning and compares LASSO performance with ordinary least squares regression.

## Files Description

### `hw4.r`
Main homework file containing LASSO regression analysis on the College dataset. This file:
- Loads and explores the College dataset from ISLR package
- Splits data into training (70%) and test (30%) sets
- Implements LASSO regression using the `glmnet` package
- Performs cross-validation to find optimal lambda values
- Compares LASSO performance with OLS regression
- Reports test MSE and coefficient selection

### `P2_LASSO_HittersData_OVERVIEW.R`
Comprehensive LASSO analysis tutorial using the Hitters dataset. This file:
- Provides detailed explanation of the Hitters dataset (MLB player statistics)
- Demonstrates step-by-step LASSO implementation
- Shows data preprocessing and missing value handling
- Compares different lambda selection strategies
- Illustrates coefficient selection and model interpretation

### `College.csv`
Dataset containing information about US colleges and universities, including:
- **Response variable**: `Apps` (Number of applications received)
- **Predictors**: Private status, acceptance rate, enrollment, academic rankings, financial aid, faculty qualifications, and more
- **Size**: 779 observations with 18 variables

## Key Features

### LASSO Implementation
- **Regularization**: Uses L1 penalty (Lasso) for variable selection
- **Cross-validation**: 10-fold CV to select optimal lambda values
- **Two lambda criteria**: 
  - `lambda.min`: Minimizes cross-validation error
  - `lambda.1se`: Largest lambda within 1 standard error of minimum

### Model Comparison
- **LASSO vs OLS**: Compares prediction accuracy using test MSE
- **Variable Selection**: Shows how LASSO shrinks coefficients to zero
- **Performance Metrics**: Reports improvement percentages

## Requirements

### R Packages
```r
library(glmnet)    # For LASSO regression
library(ISLR)      # For datasets
```

### Data
- College dataset (included in ISLR package)
- Hitters dataset (included in ISLR package)

## Usage

### Running the Main Analysis
```r
source("hw4.r")
```

### Running the Tutorial
```r
source("P2_LASSO_HittersData_OVERVIEW.R")
```

## Results

The analysis demonstrates:
1. **LASSO effectiveness**: Typically achieves lower test MSE compared to OLS
2. **Variable selection**: Automatically identifies important predictors
3. **Regularization benefits**: Prevents overfitting through coefficient shrinkage
4. **Cross-validation**: Robust lambda selection for optimal performance

## Learning Objectives

This project helps understand:
- Regularization techniques in statistical learning
- LASSO regression implementation and interpretation
- Cross-validation for hyperparameter tuning
- Model comparison and evaluation
- Variable selection and coefficient interpretation

## Author
Zander Anderson

## Course
Statistical Learning/Data Science course (Homework 4)