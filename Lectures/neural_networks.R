###### neural newtorks, ME397 DATA ANALYSIS CLASS ####### Joshua D. Rhodes, PhD \ The Univeristy of Texas at Austin \ @joshdr83

## origional logistic regression -- this is the same as seen in the logistic regression lecture

	library(ROCR)
	library(pscl)

	## initialize the random number generator
	set.seed(2)

	## read in data
	coal_data <- read.csv('COAL_PLANTS.csv')

	## create training and test datasets
	coal_train <- coal_data[1:450,]
	coal_test <- coal_data[451:597,]

	## create model
	lgm <- glm(retire ~ Nameplate.Capacity + Operating.Year.avg + Energy.Source.1, data = coal_train, family = binomial(link = "logit"))

	## look at the output
	summary(lgm)

	## check the results
	fitted.results <- predict(lgm, newdata=subset(coal_test,select=c('Nameplate.Capacity', 'Operating.Year.avg', 'Energy.Source.1')),type='response')
	fitted.results <- ifelse(fitted.results > 0.5,1,0)
	misClasificError <- mean(fitted.results != coal_test$retire)
	print(paste('Accuracy Logit: ',round(1-misClasificError, 4)*100, '%', sep = ''))


## neural networks -- this will use the same problem as the logit example, but will use a neural network instead

	library(caTools)
	library(neuralnet)

	## read in data and downselect to just the needed columns
	coal_data <- read.csv('COAL_PLANTS.csv')
	coal2 <- coal_data[c('retire', 'Nameplate.Capacity', 'Operating.Year.avg', 'Energy.Source.1')]

	## neural networks often need to be normalized to converge, find the max and min for each column
	maxs <- apply(coal2[,2:3], 2, max)
	mins <- apply(coal2[,2:3], 2, min)
	
	## this will scale the continious varaibles (columns 2 & 3) from 0 to 1
	scaled.data <- as.data.frame(scale(coal2[,2:3], center = mins, scale = maxs - mins))

	## add back in the retire and Energy.Source.1 columns & rename
	data <- cbind(coal2$retire, scaled.data, coal2$Energy.Source.1)
	names(data) <- c('retire', 'Nameplate.Capacity', 'Operating.Year.avg', 'Energy.Source.1')

	head(data)

	## since NN need numeric values, transform the factor variable 'Energy.Source.1' to a list of binaries, note "BIT" is the default like last time
	exp_data <- as.data.frame(model.matrix( ~ Nameplate.Capacity + Operating.Year.avg + Energy.Source.1, data = data))

	head(exp_data)

	## combine 1) all the columns from data, except the last one with 2) all the columns from exp_data except the first 3
	data <- cbind(data[,-dim(data)[2]], exp_data[,-c(1:3)])

	## set seed to whatever, used in the random number generator, if you change this, your answer might vary from mine
	set.seed(2505)

	## just another way to split a dataset into a training and test dataset
	split = sample.split(data$retire, SplitRatio = 0.70)

	head(split)

	train = subset(data, split == TRUE)
	test = subset(data, split == FALSE)

	## auto-generate the formula from the names of the dataset -- this is not necessary, but nice if you have a bunch of columns
	feats <- names(train[,-1])
	f <- paste(feats,collapse=' + ')
	f <- paste('retire ~',f)
	f <- as.formula(f)

	## build the neural net using the training dataset and specify the number of hidden nodes, default: hidden = c(1)
	nn <- neuralnet(f, train, linear.output=T, hidden = c(3,2))

	## use the neural network just created, named "nn" to try to predict the retirement status of the test dataset
	predicted.nn.values <- compute(nn,test[2:7])

	## because we get a number between 0 and 1, here we want to round down to 0 or up to 1
	predicted.nn.values$net.result <- sapply(predicted.nn.values$net.result,round,digits=0)

	## build a table to see how we did in predicting 
	table(test$retire,predicted.nn.values$net.result)

	## test the accuracy % wise
	print(paste('Accuracy NN: ',round((table(test$retire,predicted.nn.values$net.result)[1,1] + table(test$retire,predicted.nn.values$net.result)[2,2])/dim(test)[1], 4)*100, '%', sep = ''))

	## plot the neural network
	plot(nn)

	## use "nn" to predict some other values you make up

	t1 <- test[3,2:7]
	compute(nn,t1)

	t1$Energy.Source.1WC <- 1
	t1$Energy.Source.1SUB <- 0
	compute(nn,t1)










