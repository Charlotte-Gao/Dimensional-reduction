library(shiny)
library(MASS)
library(datasets)
library(shinyjs)
library(pls)
library(caret)
library(recipes)
library(AppliedPredictiveModeling)
library(shinycssloaders)
set.seed(1)
data(mtcars)
attach(mtcars)
mtcars$vs=as.factor(mtcars$vs)
mtcars$am=as.factor(mtcars$am)
numerical = mtcars[-c(8,9)]
Scores=pls::plsr(mpg ~ ., data = numerical , scale = TRUE )$scores

#choices5 = c("RMSEP","R2")
modelpca <- prcomp(~ . -mpg, data = numerical, scale. = TRUE)
PCA=predict(modelpca, newdata = numerical)
choices1=colnames(Scores)
choices2=colnames(PCA)
choices3=c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")
choices4=c("step_pls","step_pca")
#choices5=c("pcr","plsr")
numerical.dist <- stats::dist(numerical)
numerical.sam <- MASS::sammon(numerical.dist, k = 2)
data(solubility)
training = solTrainXtrans # transformed using Box-cox
training$solubility = solTrainY
training_solubility=solTrainY