#Reading the dataset
hospitall <- read.csv("C:\\Users\\KM\\Desktop\\My thesis\\hospital.csv")
hospitalization<-(hospital[,20])
death<-(hospitall[,3])
survey <- data.frame(date=death,tx_start=hospitalization)

#caclulating the difference (d)
diff <- as.Date(survey$date, format="%d-%m-%y")- as.Date(survey$tx_start, format="%d-%m-%y")
dif <- as.numeric(diff, units="days")
V16 <- ifelse( !is.na( dif )&dif<31, 1, 0) 

#Adding the difference d to the database (hospital)
hospitall <- cbind(hospitall, V16)


#Digitizing all the columns into a database ''hospitall'' where In total 0 is negative, 1 is positive, 2 is no data 
seventeenth <- hospitall[,17]
hospitall[,17] <- as.numeric(levels(hospitall[,17]))[hospitall[,17]]
hospitall <- as.matrix(hospitall)
for (i in 1:1099)
{ if (hospitall[i,2]=='Yes')                       
{hospitall[i,2]=1}                              
  else
  {hospitall[i,2]=0}
  
  if (hospitall[i,4]=='Female')   
  {hospitall[i,4]=0}                              
  else
  {hospitall[i,4]=1}
  
  if (hospitall[i,6]=='Yes')   
  {hospitall[i,6]=0}                              
  else
  {hospitall[i,6]=1}
  
  if (hospitall[i,7]=='Yes')   
  {hospitall[i]=0}                              
  else if (hospitall[i,7]=='No')
  {hospitall[i,7]=1}
  else 
  {hospitall[i,7]=2}
  
  if (hospitall[i,8]=='Yes')   
  {hospitall[i,8]=0}                              
  else if (hospitall[i,8]=='No')
  {hospitall[i,8]=1}
  else 
  {hospitall[i,8]=2}
  
  if (hospitall[i,9]=='Yes')   
    hospitall[i,9]=0                              
  else if (hospitall[i,9]=='No')
    hospitall[i,9]=1
  else 
    hospitall[i,9]=2
  
  if (hospitall[i,10]=='Yes')   
  {hospitall[i,10]=0}                              
  else if (hospitall[i,10]=='No')
  {hospitall[i,10]=1}
  else 
  {hospitall[i,10]=2}
  
  if (hospitall[i,11]=='Yes')   
  {hospitall[i,11]=0}                              
  else if (hospitall[i,11]=='No')
  {hospitall[i,11]=1}
  else 
  {hospitall[i,11]=2}
  
  if (hospitall[i,12]=='Yes')   
  {hospitall[i,12]=0}                              
  else if (hospitall[i,12]=='No')
  {hospitall[i,12]=1}
  else 
  {hospitall[i,12]=2}
  
  if (hospitall[i,13]=='Yes')   
  {hospitall[i,13]=0}                              
  else if (hospitall[i,13]=='No')
  {hospitall[i,13]=1}
  else 
  {hospitall[i,13]=2}
  
  if (hospitall[i,14]=='Yes')   
  {hospitall[i,14]=0}                              
  else if (hospitall[i,14]=='No')
  {hospitall[i,14]=1}
  else 
  {hospitall[i,14]=2}
  
  if (hospitall[i,15]=='Yes')   
  {hospitall[i,15]=0}                              
  else if (hospitall[i,15]=='No')
  {hospitall[i,15]=1}
  else 
  {hospitall[i,15]=2}
  
  if (hospitall[i,16]=='Smoker')   
  {hospitall[i,16]=0}                              
  else if (hospitall[i,16]=='Never smoked')
  {hospitall[i,16]=1}
  else if (hospitall[i,16]=='No data')
  {hospitall[i,16]=2}
  else 
  {hospitall[i,16]=2}
  
  if (hospitall[i,18]=='STEMI')   
  {hospitall[i,18]=0}                              
  else
  {hospitall[i,18]=1}
  
  if(is.na(hospitall[i,17]))
    hospitall[i,17]=2
  else if (hospitall[i,17] <74.3 | hospitall[i,17]>107)
    hospitall[i,17]=0
  else
    hospitall[i,17]=1}



#Taking only the useful culomns 
hospitall<- hospitall[,-c(1,3,5,19,20)]
hospitall <- as.data.frame(hospitall)
hospitall$Reanimation.before.the.hospitalization <- as.numeric(hospitall$Reanimation.before.the.hospitalization)
hospitall$Creatinin.level <- as.numeric(hospitall$Creatinin.level)
hospitall[] <- lapply(hospitall, function(x) {
  if(is.factor(x)) as.numeric(as.character(x)) else x
})

# Scaling into a dataset ''totalll''
maxs <- apply(hospitall, 2, max) 
mins <- apply(hospitall, 2, min)
scaled <- as.data.frame(scale(hospitall, center = mins, scale = maxs - mins))
totalll <- scaled[,]


#partitioning
set.seed(222)
ind <- sample( 2, nrow(totalll) , replace =TRUE , prob = c(0.7 , 0.3))
train <- totalll[ind==1,]
test <-totalll[ind==2,]


#Modelling, Confusion Matrics and Misclassifications
#NeuralNet 1hidden layer
library(neuralnet)
set.seed(333)
n1 <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train, linear.output=FALSE,  err.fct = "ce",  hidden = 1) 
output_train_nn1 <- compute (n1, train[,-V16])
p1 <- output_train_nn1$net.result                      
pred1 <- ifelse (2*p1>0.5, 1, 0)
tab1 <- table(pred1, train$V16)
mis1 <- 1-sum(diag(tab1))/sum(tab1) 
##0.3824289406 
n1t <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = test, linear.output=FALSE,  err.fct = "ce",  hidden = 1) 
output_test_nn1 <- compute (n1t, test[ ,-16])
p2 <- output_test_nn1$net.result                      
pred2 <- ifelse (2*p2>0.5, 1, 0)
tab2 <- table(pred2, test$V16)
mis2 <- 1-sum(diag(tab2))/sum(tab2)
##0.05846153846

#NeuralNet 3hidden layers
n3 <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train, linear.output=FALSE,  err.fct = "ce",  hidden = 3) 
output_train_nn3 <- compute (n3, train[ ,-16])
p3 <- output_train_nn3$net.result                      
pred3 <- ifelse (2*p3>0.5, 1, 0)
tab3 <- table(pred3, train$V16)
mis3 <- 1-sum(diag(tab3))/sum(tab3)                
##0.06589147287
n3t <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = test, linear.output=FALSE,  err.fct = "ce",  hidden = 3) 
output_test_nn3 <- compute (n3t, test[ ,-16])
p4 <- output_test_nn3$net.result                      
pred4 <- ifelse (2*p2>0.5, 1, 0)
tab4 <- table(pred4, test$V16)
mis4 <- 1-sum(diag(tab4))/sum(tab4)
##0.05846153846

#NeuralNet 5hidden layers
n5 <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train, linear.output=FALSE,  err.fct = "ce",  hidden = 5) 
output_train_nn5 <- compute (n5, train[ ,-16])
p5 <- output_train_nn5$net.result                      
pred5 <- ifelse (2*p5>0.5, 1, 0)
tab5 <- table(pred5, train$V16)
mis5 <- 1-sum(diag(tab5))/sum(tab5)
##0.04521963824
n5t <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = test, linear.output=FALSE,  err.fct = "ce",  hidden = 5) 
output_test_nn5<- compute (n5t, test[ ,-16])
p6 <- output_test_nn5$net.result                      
pred6 <- ifelse (2*p6>0.5, 1, 0)
tab6 <- table(pred6, test$V16)
mis6 <- 1-sum(diag(tab6))/sum(tab6)
## 0.01538461538

#NeuralNet 2-1hidden layers  
n2_1 <- neuralnet(V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train,  linear.output=FALSE, err.fct = "ce", hidden = c(2,1)  )
output_train_n1_2 <- compute (n2_1, train[ ,-16])
p7 <- output_train_n1_2$net.result                      
pred7 <- ifelse (2*p7>0.5, 1, 0)
tab7 <- table(pred7, train$V16)
mis7 <- 1-sum(diag(tab7))/sum(tab7)
##0.1085271318
n2_1t <- neuralnet(V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = test,  linear.output=FALSE, err.fct = "ce", hidden = c(2,1)  )
output_test_n1_2 <- compute (n2_1t, test[ ,-16])
p8 <- output_test_n1_2$net.result                      
pred8 <- ifelse (2*p8>0.5, 1, 0)
tab8 <- table(pred8, test$V16)
mis8 <- 1-sum(diag(tab8))/sum(tab8)
## 0.04

#NeuralNet5layers with repetitions (tuning) 
n5r <- neuralnet(V16 ~Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train, linear.output=FALSE, err.fct = "ce",   hidden = 5,    lifesign = 'full', rep = 5, )
##4th conversion error: error: 60.27809	time: 1.34 mins ;  5th conversion error: 73.32952	time: 1.84 mins          

n5r4 <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train, linear.output=FALSE,  err.fct = "ce",  hidden = 5, rep =4) 
output_train_nn5r4 <- compute (n5r4, train[ ,-16])
p9 <- output_train_nn5r4$net.result                      
pred9 <- ifelse (2*p9>0.5, 1, 0)
tab9 <- table(pred9, train$V16)
mis9 <- 1-sum(diag(tab9))/sum(tab9)               
##0.03875968992
n5r4t <- neuralnet (V16 ~ Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = test, linear.output=FALSE,  err.fct = "ce",  hidden = 5, rep =4) 
output_test_nn5r4<- compute (n5r4t, test[ ,-16])
p10 <- output_test_nn5r4$net.result                      
pred10 <- ifelse (2*p6>0.5, 1, 0)
tab10 <- table(pred6, test$V16)
mis10 <- 1-(sum(diag(tab10))/sum(tab10))
## 0.1138461538

#The randomForest Modelling and confusion matrics and misclassifications
train$V16 <- as.factor(train$V16)
test$V16 <- as.factor(test$V16)
library(randomForest)
library(caret)
set.seed(222)
rf_train <- randomForest(V16~., data = train)
p11 <- predict(rf_train , train)
tab11 <- confusionMatrix(p11, train$V16)
##0.034883

set.seed(222)
rf_test <- randomForest(V16~., data = test)
p12 <- predict(rf_test , test)
tab12 <- confusionMatrix(p12, test$V16)
## 0.027692

## Tuning the randomForest (best is mtree=3)
t <- tuneRF(train [,-16], train[,16],stepFactor = 0.5,plot = TRUE , ntreeTry = 500, trace = TRUE, improve = 0.5)

rf_best <- randomForest (V16~., data = train, ntree=200, mtry =3, importance = TRUE, proximity = TRUE)               
p13 <- predict(rf_best , train)
tab13 <- confusionMatrix(p13, train$V16)
##0.036175                

rf_best_test <- randomForest (V16~., data = test, ntree=200, mtry =3, importance = TRUE, proximity = TRUE)               
p14 <- predict(rf_best , test)
tab14 <- confusionMatrix(p14, test$V16)
##0.08923

rf_best230 <- randomForest (V16~., data = train, ntree=230, mtry =3, importance = TRUE, proximity = TRUE)               
p15 <- predict(rf_best230 , train)
tab15 <- confusionMatrix(p15, train$V16) 
##0.042635                

rf_best_test230 <- randomForest (V16~., data = test, ntree=230, mtry =3, importance = TRUE, proximity = TRUE)               
p16 <- predict(rf_best230 , test)
tab16 <- confusionMatrix(p16, test$V16)
##0.095384

rf_best500 <- randomForest (V16~., data = train, ntree=500, mtry =3, importance = TRUE, proximity = TRUE)               
p1_5 <- predict(rf_best500 , train)
tab1_5 <- confusionMatrix(p1_5, train$V16) 
##0.042635                

rf_best_test500 <- randomForest (V16~., data = test, ntree=500, mtry =3, importance = TRUE, proximity = TRUE)               
p1_6 <- predict(rf_best_test500 , test)
tab1_6 <- confusionMatrix(p16, test$V16)
##0.095384

#The Support Machine Vector, confusion matrixes and misclassifications
library(ggplot2)
library(e1071)
mymodel_train <- svm(V16~., data = train)
pred <- predict(mymodel_train, train[,-16])
cm_train <- table(Predicted = pred, Actual = train$V16)
mis17 <- 1-sum(diag(cm_train)/sum(cm_train))
##0.086563

mymodel_test <- svm(V16~., data = test)
pred <- predict(mymodel_test, test[,-16])
cm_test <- table(Predicted = pred, Actual = test$V16)
mis18 <- 1-sum(diag(cm_test)/sum(cm_test))
##0.043076

### Tuning for the svm
tmodel_train <- tune(svm, V16~., data = train,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
mymodel_train1 <- tmodel_train$best.model
pred_train1 <- predict(mymodel_train1, train[,-16])
cm_train1 <- table(Predicted = pred_train1, Actual = train$V16)
mis18 <- 1-sum(diag(cm_train1)/sum(cm_train1))
##0.031007

tmodel_test <- tune(svm, V16~., data = test,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
mymodel_test1 <- tmodel_test$best.model
pred_test1 <- predict(mymodel_test1, test[,-16])
cm_test1 <- table(Predicted = pred_test1, Actual = test$V16)
mis19 <- 1-sum(diag(cm_test1)/sum(cm_test1))
##0.015384                     

#Decision Tree Modelling
set.seed(12345)
library(party)
myformula <- V16~.
ff_ctree_train <- ctree(myformula, data = train)
pp_train <- predict(ff_ctree_train)
tabb_train <- table(pp_train, train$V16)
mis20 <- 1-sum(diag(tabb_train))/sum(tabb_train)
##0.1266149871                 

ff_ctree_test <- ctree(myformula, data = test)
pp_test <- predict(ff_ctree_test)
tabb_test <- table(pp_test, test$V16)
mis21 <- 1-sum(diag(tabb_test))/sum(tabb_test)              
##0.12

--------------------------
  #CrossValidation in NN5
  folds = createFolds(train$V16,  k=10)
cvtrain_nn= lapply (folds, function(x){
  train_fold = train [-x,]
  test_fold=train [x,]
  n5_fold <- neuralnet(V16~Is.the.patient.alive.or.not+Sex+PCI.is.happened.or.not+Reanimation.before.the.hospitalization+Cardiogen.shock.at.hospitalization+Myocardialis.infarctus.in.medical.history+Health.failure.in.medical.history+Hypertonia.in.medical.history.or.during.the.treatment+Stroke.in.medical.history+Diabetes.in.medical.history+Peripherial.vascular.disease.in.medical.history+Hyperlipidaemia.in.medical.history+Smoker.in.medical.history+Creatinin.level+Diagnosis, data = train_fold, linear.output=FALSE, hidden = 5 )
  output_train_nn5_fold <- compute (n5_fold, train_fold[ ,-16])
  p5_fold <- output_train_nn5_fold$net.result                      
  pred5_fold <- ifelse (2*p5_fold>0.5, 1, 0)
  tab5_fold <- table(pred5_fold, train$V16)
  accuracynn= (tab5_fold[1,1] + tab5_fold[2,2] )/ (tab5_fold[1,1]+tab5_fold[1,2]+tab5_fold[2,2]+tab5_fold[2,1])
  return(accuracynn)})
cv_svm_train_nn <- mean(as.numeric(cvtrain_nn))
##0.071059


#CrossValidation in randomForest
##3/230
train$V16 <- as.factor(train$V16)
folds = createFolds(train$V16,  k=10)
cvtrain_rf = lapply (folds, function(x){
  train_fold = train [-x,]
  test_fold=train [x,]
  rf_best230fold <- randomForest (V16~., data = train_fold, ntree=230, mtry =3, importance = TRUE, proximity = TRUE)
  predtrain1 <- predict(rf_best230fold, train_fold[,-16])
  cmtrain1rf <- table(Predicted =  predtrain1, Actual = train_fold$V16)
  accuracyrf= (cmtrain1rf[1,1] + cmtrain1rf[2,2] )/ (cmtrain1rf[1,1]+cmtrain1rf[1,2]+cmtrain1rf[2,2]+cmtrain1rf[2,1])
  return(accuracyrf)})
cv_svm_train_rf <- mean(as.numeric(cvtrain_rf))
##0.037322

##3/200
train$V16 <- as.factor(train$V16)
folds = createFolds(train$V16,  k=10)
cvtrain_rf = lapply (folds, function(x){
  train_fold = train [-x,]
  test_fold=train [x,]
  rf_best200fold <- randomForest (V16~., data = train_fold, ntree=200, mtry =3, importance = TRUE, proximity = TRUE)
  predtrain1_200 <- predict(rf_best200fold, train_fold[,-16])
  cmtrain1rf_200 <- table(Predicted =  predtrain1_200, Actual = train_fold$V16)
  accuracyrf_200= (cmtrain1rf_200[1,1] + cmtrain1rf_200[2,2] )/ (cmtrain1rf_200[1,1]+cmtrain1rf_200[1,2]+cmtrain1rf_200[2,2]+cmtrain1rf_200[2,1])
  return(accuracyrf_200)})
cv_svm_train_rf_200 <- mean(as.numeric(cvtrain_rf))
##0.03876115206


#CrossValidation in SVM 
folds = createFolds(train$V16,  k=10)
cvtrain = lapply (folds, function(x){
  train_fold = train [-x,]
  test_fold=train [x,]
  tmodeltrain <- tune(svm, V16~., data = train_fold,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
  mymodeltrain1 <- tmodeltrain$best.model
  predtrain1 <- predict(mymodeltrain1, train_fold[,-16])
  cmtrain1 <- table(Predicted =  predtrain1, Actual = train_fold$V16)
  accuracy= (cmtrain1[1,1] + cmtrain1[2,2] )/ (cmtrain1[1,1]+cmtrain1[1,2]+cmtrain1[2,2]+cmtrain1[2,1])
  return(accuracy)})
cv_svm_train <- mean(as.numeric(cvtrain))
##0.03904522967

#CrossValidation in randomForest
##3/230
hospitall$V16 <- as.factor(hospitall$V16)
folds = createFolds(hospitall$V16,  k=10)
cvtrain_rf = lapply (folds, function(x){
  train_fold = hospitall [-x,]
  test_fold=hospitall [x,]
  rf_best230fold <- randomForest (V16~., data = train_fold, ntree=230, mtry =3, importance = TRUE, proximity = TRUE)
  predtrain1 <- predict(rf_best230fold, train_fold[,-16])
  cmtrain1rf <- table(Predicted =  predtrain1, Actual = train_fold$V16)
  accuracyrf= (cmtrain1rf[1,1] + cmtrain1rf[2,2] )/ (cmtrain1rf[1,1]+cmtrain1rf[1,2]+cmtrain1rf[2,2]+cmtrain1rf[2,1])
  return(accuracyrf)})
cv_svm_train_rf <- mean(as.numeric(cvtrain_rf))
##0.03882301274

##3/200
hospitall$V16 <- as.factor(hospitall$V16)
folds = createFolds(hospitall$V16,  k=10)
cvtrain_rf = lapply (folds, function(x){
  train_fold = hospitall [-x,]
  test_fold=hospitall [x,]
  rf_best200fold <- randomForest (V16~., data = train_fold, ntree=200, mtry =3, importance = TRUE, proximity = TRUE)
  predtrain1_200 <- predict(rf_best200fold, train_fold[,-16])
  cmtrain1rf_200 <- table(Predicted =  predtrain1_200, Actual = train_fold$V16)
  accuracyrf_200= (cmtrain1rf_200[1,1] + cmtrain1rf_200[2,2] )/ (cmtrain1rf_200[1,1]+cmtrain1rf_200[1,2]+cmtrain1rf_200[2,2]+cmtrain1rf_200[2,1])
  return(accuracyrf_200)})
cv_svm_train_rf_200 <- mean(as.numeric(cvtrain_rf))
##0.03902482867


#CrossValidation in SVM 
folds = createFolds(hospitall$V16,  k=10)
cvtrain = lapply (folds, function(x){
  train_fold = hospitall [-x,]
  test_fold=hospitall [x,]
  tmodeltrain <- tune(svm, V16~., data = train_fold,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
  mymodeltrain1 <- tmodeltrain$best.model
  predtrain1 <- predict(mymodeltrain1, train_fold[,-16])
  cmtrain1 <- table(Predicted =  predtrain1, Actual = train_fold$V16)
  accuracy= (cmtrain1[1,1] + cmtrain1[2,2] )/ (cmtrain1[1,1]+cmtrain1[1,2]+cmtrain1[2,2]+cmtrain1[2,1])
  return(accuracy)})
cv_svm_train <- mean(as.numeric(cvtrain))
##0.03904522967

#CrossValidation in SVM - 5folds
folds = createFolds(train$V16,  k=5)
cvtrain = lapply (folds, function(x){
  train_fold = train [-x,]
  test_fold=train [x,]
  tmodeltrain <- tune(svm, V16~., data = train_fold,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
  mymodeltrain1 <- tmodeltrain$best.model
  predtrain1 <- predict(mymodeltrain1, train_fold[,-16])
  cmtrain1 <- table(Predicted =  predtrain1, Actual = train_fold$V16)
  accuracy= (cmtrain1[1,1] + cmtrain1[2,2] )/ (cmtrain1[1,1]+cmtrain1[1,2]+cmtrain1[2,2]+cmtrain1[2,1])
  return(accuracy)})
cv_svm_train <- mean(as.numeric(cvtrain))
##0.521428

## Model Performance Evaluation - train set - best models
#SVM-TRAIN

library (ROCR)
PREDSVMBESTTRAIN <- predict (mymodel_train1, train, type = 'prob')
hist (PREDSVMBESTTRAIN)

PREDSVMBESTTRAIN <- prediction (PREDSVMBESTTRAIN, train$V16)
evalsvmtrainbest <- performance(PREDSVMBESTTRAIN, "acc")
plot (evalsvmtrainbest)
## best cut off is at 0.1

maxsvmtrainbest <- which.max(slot(evalsvmtrainbest, "y.values")[[1]])
accsvmtrainbest <- slot(evalsvmtrainbest, "y.values")[[1]] [maxsvmtrainbest]
cutsvmtrainbest <- which.max(slot(evalsvmtrainbest, "x.values")[[1]])
print (c(Accuracy = accsvmtrainbest, Cutoff = cutsvmtrainbest))
rocsvmtrainbest <- performance (PREDSVMBESTTRAIN, "tpr", "fpr")
plot(rocsvmtrainbest, colorize =T, ylab = "sensitivity", xlab="1-specificity")

# area under the curve
aucsvmtrainbest <- performance(PREDSVMBESTTRAIN, "auc")
aucsvmtrainbest <- unlist (slot(aucsvmtrainbest, "y.values"))
## AUC the greater, the better (for SVM 0.889823 from the max of 1)

#SVM-TEST
PREDSVMBESTTEST <- predict (mymodel_test1, test, type = 'prob')
hist (PREDSVMBESTTEST)

PREDSVMBESTTEST <- prediction (PREDSVMBESTTEST, test$V16)
evalsvmtestbest <- performance(PREDSVMBESTTEST, "acc")
plot (evalsvmtestbest)
## best cut off is at 0.1

maxsvmtestbest <- which.max(slot(evalsvmtestbest, "y.values")[[1]])
accsvmtestbest <- slot(evalsvmtestbest, "y.values")[[1]] [maxsvmtestbest]
cutsvmtestbest <- which.max(slot(evalsvmtestbest, "x.values")[[1]])
print (c(Accuracy = accsvmtestbest, Cutoff = cutsvmtestbest))
rocsvmtestbest <- performance (PREDSVMBESTTEST, "tpr", "fpr")
plot(rocsvmtestbest, colorize =T, ylab = "sensitivity", xlab="1-specificity")

# area under the curve
aucsvmtestbest <- performance(PREDSVMBESTTEST, "auc")
aucsvmtestbest <- unlist (slot(aucsvmtestbest, "y.values"))
## AUC the greater, the better (for SVM TEST 0.992399 from the max of 1)

#SVM-ON THE WHOLE SET

tmodel_hospitall <- tune(svm, V16~., data = hospitall ,ranges = list(epsilon = seq(0,1,0.2), cost = 2^(2:6)))
mymodel_hospitall1 <- tmodel_hospitall$best.model
PREDSVMBESTHOSPITALL <- predict ( mymodel_hospitall1, hospitall, type = 'prob')
hist (PREDSVMBESTHOSPITALL)

PREDSVMBESTHOSPITALL <- prediction (PREDSVMBESTHOSPITALL, hospitall$V16)
evalsvmhospitallbest <- performance(PREDSVMBESTHOSPITALL, "acc")
plot (evalsvmhospitallbest)
## best cut off is at 0.1

maxsvmhospitallbest <- which.max(slot(evalsvmhospitallbest, "y.values")[[1]])
accsvmhospitallbest <- slot(evalsvmhospitallbest, "y.values")[[1]] [maxsvmhospitallbest]
cutsvmhospitallbest <- which.max(slot(evalsvmhospitallbest, "x.values")[[1]])
rocsvmhospitallbest <- performance (PREDSVMBESTHOSPITALL, "tpr", "fpr")
plot(rocsvmhospitallbest, colorize =T, ylab = "sensitivity", xlab="1-specificity")

# area under the curve
aucsvmhospitallbest <- performance(PREDSVMBESTHOSPITALL, "auc")
aucsvmhospitallbest <- unlist (slot(aucsvmhospitallbest, "y.values"))
## AUC the greater, the better (for SVM TEST 0.9459457434 from the max of 1)
