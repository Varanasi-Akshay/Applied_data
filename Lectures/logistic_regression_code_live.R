# load 'em up
library(ROCR)
library(pscl)


## initialize the random number generator
set.seed(2)

## read in data
coal_data <- read.csv('COAL_PLANTS.csv')

## shuffle the rows of data
coal_data <- coal_data[sample(nrow(coal_data)),]

## take a look at the data
head(coal_data)
dim(coal_data)
summary(as.factor(coal_data$retire))

## look at the correlations between the data
cor(subset(x = coal_data, select = c("Nameplate.Capacity", "retire")))
cor(subset(x = coal_data, select = c("Operating.Year.avg", "retire")))
cor(subset(x = coal_data, select = c("Energy.Source.1", "retire")))



## plot the data to look at the correlations between each
plot(subset(x = coal_data, select = c("Operating.Year.avg", "Nameplate.Capacity", "Energy.Source.1", "retire")))

## Energy.Source.1 has been converted to a number for plot
levels(coal_data$Energy.Source.1)[1]


coal_train <- coal_data[1:450,]
coal_test <- coal_data[451:597,]

## build the logit model
lgm <- glm(retire ~ Nameplate.Capacity + Operating.Year.avg + Energy.Source.1, data = coal_train, family = binomial(link = "logit"))

## look at the output
summary(lgm)

##
anova(lgm, test="Chisq")

## there is no R^2 for this type of model, but the McFadden R^2 is another indicator of fit
pR2(lgm)

## where is the "BIT" coeficent? -- it is the reference value
contrasts(coal_data$Energy.Source.1)



## check the results

fitted.results <- predict(lgm, newdata=subset(coal_test,select=c('Nameplate.Capacity', 'Operating.Year.avg', 'Energy.Source.1')),type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != coal_test$retire)
print(paste('Accuracy ',round(1-misClasificError, 4)*100, '%', sep = ''))


## check the probility for a given plant
summary(lgm)

## probibility of a 500 MW LIG coal plant built in 1980 being retired
1/(1 + exp(-(2.071e+02 + -1.486e-03*500 + -1.051e-01*1980 + -1.995e+00)))

## probibility of a 750 MW LIG coal plant built in 1960 being retired
1/(1 + exp(-(2.071e+02 + -1.486e-03*750 + -1.051e-01*1960 + -1.995e+00)))

## probibility of a 500 MW SUB coal plant built in 1980 being retired
1/(1 + exp(-(2.071e+02 + -1.486e-03*500 + -1.051e-01*1980 + -4.134e-01)))
 
## probibility of a 750 MW SUB coal plant built in 1960 being retired
1/(1 + exp(-(2.071e+02 + -1.486e-03*750 + -1.051e-01*1960 + -4.134e-01)))

### BIT ###

## probibility of a 500 MW BIT coal plant built in 1980 being retired 
1/(1 + exp(-(2.071e+02 + -1.486e-03*500 + -1.051e-01*1980 )))

## probibility of a 500 MW BIT coal plant built in 1970 being retired 
1/(1 + exp(-(2.071e+02 + -1.486e-03*500 + -1.051e-01*1970 )))





## plot the ROC plot and add up the area under the curve
## summarizes the model’s performance by evaluating the trade offs between true positive rate (sensitivity) and false positive rate
## https://stats.stackexchange.com/questions/105501/understanding-roc-curve?rq=1
p <- predict(lgm, newdata=subset(coal_test,select=c('Nameplate.Capacity', 'Operating.Year.avg', 'Energy.Source.1')),type='response')
pr <- prediction(p, coal_test$retire)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
abline(a=0,b=1,col='red')

## calcualte the area under the ROC curve, the bigger the better
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc


## one more check on the goodness of fit
step <- stepAIC(lgm, direction="both")
step$anova

