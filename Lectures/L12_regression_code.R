###### REGRESSION, ME397 DATA ANALYSIS CLASS ####### Joshua D. Rhodes, PhD | The Univeristy of Texas at Austin | @joshdr83

## libraries to load
library(GGally)
library(MASS)


## read in some data -- this dataset inludes the total amoutn of electrcity genresated in the US by year from multiple types of power plants as well as the amount of CO2 emitted
ghg <- read.csv('gen_ghg_comb_1987_2016.csv')

head(ghg)

matplot(ghg[c(2:4,6,7,9,10)], type = c("b"),pch=1,col = 1:7)
legend("left", legend = names(ghg[c(2:4,6,7,9,10)]), col=1:7, pch=1)

## one place to start to look at data for building regression models is to see if data are correlated

cor(subset(x = ghg, select = c("coal_twh", "MMT_co2"))) # strong positive correlation

cor(subset(x = ghg, select = c("coal_twh", "co2_inten"))) # moderate positive correlation

cor(subset(x = ghg, select = c("ng_twh", "MMT_co2"))) # moderate positive correlation

cor(subset(x = ghg, select = c("ng_twh", "co2_inten"))) # strong negative correlation

cor(subset(x = ghg, select = c("hydro_twh", "co2_inten"))) # very weak positive correlation

## let's start to visualize the data to see if there are some general trends to look for

plot(subset(x = ghg, select = c("coal_twh", "MMT_co2"))) # generally increasing coal generation increases tons of CO2 emitted, makes sense as coal is the most CO2 intensive source we have

plot(subset(x = ghg, select = c("coal_twh", "ng_twh", "MMT_co2")))  # let's throw some more data in there

plot(subset(x = ghg, select = c("year", "coal_twh", "ng_twh", "MMT_co2"))) # putting in year helps give an anchor as to time

plot(subset(x = ghg, select = c("year", "coal_twh", "ng_twh", "co2_inten")))

plot(subset(x = ghg, select = c("year", "coal_twh", "ng_twh", "hydro_twh", "co2_inten"))) # why hydro doesn't appear to be correlated with much

plot(subset(x = ghg, select = c("year", "coal_twh", "ng_twh", "hydro_twh", "renewable_twh", "co2_inten")))

## correlation between regressors !!! --> This could lead to multicollinearity -- which predictor is actually influencing?

cor(subset(x = ghg, select = c("renewable_twh", "ng_twh")))

## Regression

?lm # 

mod.1 <- lm(co2_inten ~ coal_twh, data = ghg)

summary(mod.1) ## not great


mod.2 <- lm(co2_inten ~ coal_twh + ng_twh, data = ghg)
 
summary(mod.2) ## much better, but there could be other factors


mod.3 <- lm(co2_inten ~ coal_twh + ng_twh + nuclear_twh, data = ghg)
 
summary(mod.3) ## continuted to be better


mod.4 <- lm(co2_inten ~ coal_twh + ng_twh + nuclear_twh + renewable_twh, data = ghg)
 
summary(mod.4)


mod.5 <- lm(co2_inten ~ coal_twh + ng_twh + nuclear_twh + renewable_twh + hydro_twh, data = ghg)
 
summary(mod.5)


mod.6 <- lm(co2_inten ~ coal_twh + ng_twh + nuclear_twh + renewable_twh + hydro_twh + ng_twh2, data = ghg)

summary(mod.6)

## we can test our model to see if there are better fits w/o some of the data:
## https://stats.stackexchange.com/questions/347652/default-stepaic-in-r

step <- stepAIC(mod.6, direction="both")
step$anova

## AIC = Akaike information criterion: estimator of the relative quality of statistical models for a given set of data, the smaller the better

## consider a dataset where some predictors are not helpful
 
data <- mtcars[,c("mpg","disp","hp","wt")]
head(data)
Model1_LM <- lm(mpg ~ ., data = data)
summary(Model1_LM)
fit1_LM <- stepAIC(Model1_LM)


###### It is good to test for colinearity and pretty graphics!
ggpairs(ghg[2:7])




