


library(ISLR)
fix(Hitters)
names(Hitters)
attach(Hitters)

# Description of "Hitters" Data 
# Major League Baseball Data from the 1986 and 1987 seasons.
# Format
# A data frame with 322 observations of major league players on the following 20 variables.
# AtBat Number of times at bat in 1986
# Hits Number of hits in 1986
# HmRun Number of home runs in 1986
# Runs Number of runs in 1986
# RBI Number of runs batted in in 1986
# Walks Number of walks in 1986
# Years Number of years in the major leagues
# CAtBat Number of times at bat during his career
# CHits Number of hits during his career
# CHmRun Number of home runs during his career
# CRuns Number of runs during his career
# CRBI Number of runs batted in during his career
# CWalks Number of walks during his career
# League A factor with levels A (American League) and N (National League) indicating player’s league at the end of 1986
# Division A factor with levels E and W indicating player’s division at the end of 1986
# PutOuts Number of put outs in 1986
# Assists Number of assists in 1986
# Errors Number of errors in 1986
# Salary 1987 annual salary on opening day in thousands of dollars
# NewLeague A factor with levels A and N indicating player’s league at the beginning of 1987


### Salary variable is missing for some of the players. 
## in.na() function can be used to identify the missing observations
## It returns a vector of the same length as the input vector: 
## TRUE: for any obs missing and FALSE: for non-missing elements
## Salary has 59 missing observations
  
dim(Hitters)
sum(is.na(Hitters$Salary))

# na.omit() removes all of the rows that have missing vaues in any variables.
Hitters=na.omit(Hitters)
dim(Hitters)
sum(is.na(Hitters))


########### Chapter 6 Lab 2:  LASSO MODEL   #########################################################



## glmnet() function is used to fit the lasso model:
## x (predictors) is a matrix and y (response) is a vector
## model.matrix() function creates matrix x (for 19 predictors, eliminating Salary and creates dummy varible for qualitative predictors.)

#x=model.matrix(Salary~.,Hitters)[,-1]

### Alternatively you can use the following by removing Salary
x=Hitters[,-which(colnames(Hitters)=="Salary")]
class(x)

### Convert data frame to matrix: it also creates dummy varible for qualitative predictors
x=data.matrix(x)
class(x)

y=Hitters$Salary



################################# OVERVIEW: STEP BY STEP LASSO ############################################
################################# The Lasso  ##############################################################
###########################################################################################################


## PART 1:  Create the grid for lambda


# Use glmnet package to perform LASSO

install.packages("glmnet")
library(glmnet)

## To implemnet the LASSO over a grid of values ranging lamda from 10000000000 to 0.01 
## lamda=0.01 corresponds to least square fit
## lamda=10000000000 corresponds to null model (coeff of parameters are close to zero)



grid=10^seq(10,-2,length=100)


## PART 2: Split the sample in training vs. test data to estimate test error rate

set.seed(1)

### Randomly choose a subset of numbers between 1 and n (number of obs) for training observations
train=sample(1:nrow(x), nrow(x)/2)

#### TEST data will be observations not in the training data 
test=(-train)
y.test=y[test]



## PART 3:  Fit lasso model using glmnet() funcion: use argumnet alpha=1 

lasso.mod=glmnet(x[train,],y[train],alpha=1,lambda=grid)

# Depending on the choice of lambda, some of the coeff will be exactly equal to zero.
plot(lasso.mod)


### PART 4: Perfrom cross-valiadtion to choose the best lambda and compute associated test error

set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=1)
plot(cv.out)
bestlam=cv.out$lambda.min

### PART 5: ESTIMATE THE predicted values using the best lambda and compute MSE 

lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])

## MSE=100743, substantially lower than the test set MSE of the null model and the least sq model 
mean((lasso.pred-y.test)^2)


### PART 6: Compare LASSO TEST MSE with the NULL Model (Lambda=infinity) and the Linear Regression Model (Lambda=0) 

## NULL MODEL MSE 
mean((mean(y[train])-y.test)^2)

## we get the same result by fitting a LASSO model with a very large value of lambda=10^(10)
lasso.pred=predict(lasso.mod,s=1e10,newx=x[test,])
mean((lasso.pred-y.test)^2)

## Least sq regression is simply lasso regssion with lambda=0
lasso.pred=predict(lasso.mod,s=0,newx=x[test,])
mean((lasso.pred-y.test)^2)


### PART 7: CONSTRUCT THE LASSO MODEL FOR THE ENTIRE DATA 

out=glmnet(x,y,alpha=1,lambda=grid)

### predict the coefficient at the best lambda = "bestlam"
lasso.coef=predict(out,type="coefficients",s=bestlam)[1:20,]


# 12 out of 19 coeff are zero. Lasso model with lambda chosen by cross-validation contains only seven variables
lasso.coef
lasso.coef[lasso.coef!=0]



### PART 8: Now use the Lasso predictors to fit the Linear Regression Model

attach(Hitters)
lm.fit.lasso=lm(y~Hits+Walks+CRuns+CRBI+League+Division+PutOuts)

#Provide the summary of the fitted model: coefficient estimates, t-stat, p-value, R-sq
summary(lm.fit.lasso)



################    PART 9   ####################################################################################
##### COMPUTE and COMPARE TEST MSE FOR LINEAR MODEL AND LASSO MODEL #############################################
##### SHOW THAT LASSO MODEL TEST MSE IS BETTER ##################################################################

### Check whether linear regression provides better prediction accuracy than LASSO

lm.fit=lm(Salary~.,data=Hitters[train,])
summary(lm.fit)
yhat_lm=predict(lm.fit,newdata=Hitters[-train,])

### MSE associated with the linear regression
mean((yhat_lm-y.test)^2)


### FIT THE REGRESSION MODEL USING LASSO CHOSEN PREDICTORS and compute the test MSE

lm.fit.lasso=lm(Salary~Hits+Walks+CRuns+CRBI+League+Division+PutOuts, data=Hitters[train,])

#Provide the summary of the fitted model: coefficient estimates, t-stat, p-value, R-sq
summary(lm.fit.lasso)

yhat_lm_lasso=predict(lm.fit.lasso,newdata=Hitters[-train,])


### MSE associated with the linear regression using predictors chosen by LASSO. LASSO TEST MSE is significantly reduced
mean((yhat_lm_lasso-y.test)^2)







