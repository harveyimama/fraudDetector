#####################
# Logstic regression
################


trans = read.csv('Downloads/harvey_p2.csv',header = F)
summary(trans)
head(trans)
library("lubridate")
library('dplyr')
library('glmnet')

train1 = sample(1:nrow(trans), 7*nrow(trans)/10)
test = (-train1)

logit.overall1 = glm(V16 ~ .-V18, family = "binomial", data = trans[train1,])

summary(logit.overall1)


logit.overall2 = glm(V16 ~ .-V18-V6, family = "binomial", data = trans[train1,])

summary(logit.overall2)


logit.overall3 = glm(V16 ~ .-V18-V6-V1, family = "binomial", data = trans[train1,])

summary(logit.overall3)

logit.overall4 = glm(V16 ~ .-V18-V6-V1-V9, family = "binomial", data = trans[train1,])

pchisq(logit.overall4$deviance, logit.overall4$df.residual, lower.tail = FALSE)

summary(logit.overall4)

LC.predicted = round(logit.overall4$fitted.values)
table(truth = trans[train1,]$V16, prediction = LC.predicted)

test_dats =trans[test,] %>% filter(trans[test,]$V5 != 'WEBSERVICE' & trans[test,]$V6 != 'POS-TRANSFER')

logit.test <- ifelse((predict.glm(logit.overall4,test_dats,type="response"))>0.5, "TRUE", "FALSE")
confusion = table(truth = test_dats$V16, prediction = logit.test)
acc = (confusion[1,1]+confusion[2,2])/nrow(test_dats)

#####################
# Ridge regression
#####################
x = model.matrix(V16 ~ .-V18-V6-V1-V9, trans)[, -1]
y = trans$V16
grid = 10^seq(5, -2, length = 100)  
ridge= cv.glmnet(x[train1,], y[train1], alpha = 0, lambda = grid,family = "binomial")
ridge.best = glmnet(x[train1,], y[train1], alpha = 0, lambda = ridge$lambda.min ,family = "binomial")
ridge.predict  = predict(ridge.best,s= ridge$lambda.min, newx = x[test,],type="response")
coef_  = predict(ridge,s= ridge$lambda.min,type = "coefficients")

ridge.test <- ifelse((predict(ridge.best,s= ridge$lambda.min, newx = x[test,],type="response"))>0.5, "TRUE", "FALSE")
ridge.tester = trans[test,]
ridge.test.df = as.data.frame(ridge.test)
table(truth = ridge.tester$V16, prediction = ridge.test.df$s77)


#####################
# Random forest
#####################

library(randomForest)
oob.err = numeric(13)
for (mtry in 1:13) {
  fit = randomForest(as.factor(V16)~ .-V18-V6-V1-V9, data =  trans[train1,], mtry = mtry)
  oob.err[mtry] = fit$err.rate[500, 1]
}
rf = randomForest(as.factor(V16) ~ .-V18-V6-V1-V9, data =  trans[train1,], 
                        mtry = which(oob.err == min(oob.err)))
confusion = table(predict(rf, trans[test,], type = "class"), trans[test,]$V16)
acc = (confusion[1,1]+confusion[2,2])/nrow(OJ.test)


#####################
# Decision  tree
#####################

library(tree)
trans$V3 = as.factor(trans$V3 )
trans$V4 = as.factor(trans$V4 )
trans$V5 = as.factor(trans$V5 )
trans$V6 = as.factor(trans$V6 )
trans$V10 = as.factor(trans$V10 )
trans$V11 = as.factor(trans$V11 )
trans$V12 = as.factor(trans$V12 )
trans$V13 = as.factor(trans$V13 )
trans$V14 = as.factor(trans$V14 )
trans$V15 = as.factor(trans$V15 )
trans$V18 = as.factor(trans$V18 )
trans$V16 = as.factor(trans$V16 )
summary(trans)
train1 = sample(1:nrow(trans), 7*nrow(trans)/10)
test = (-train1)
initial.tree = tree(V16 ~ .-V18-V6-V1-V9, split = "gini", data =  trans[train1,],
                    control=tree.control(nrow(trans[train1,]), mincut = 10000))
summary(initial.tree)

tree.predictions = predict(initial.tree, trans[test,], type = "class")
tree.likelihood = predict(initial.tree, trans[test,])
confusion = table(tree.predictions, trans[test,]$V16)
acc = (confusion[1,1]+confusion[2,2])/nrow(test_dats)

tree.predictions


cv.training = cv.tree(initial.tree, FUN = prune.misclass)
best.nodes = cv.training$size[which(cv.training$dev == min(cv.training$dev))] # optimal number of nodes is 11
prune.tree = prune.misclass(initial.tree, best = best.nodes)

summary(prune.tree) 
tree.predictions = predict(prune.tree, trans[test,], type = "class")
confusion = table(tree.predictions, trans[test,]$V16)
acc = (confusion[1,1]+confusion[2,2])/nrow(test_dats)


