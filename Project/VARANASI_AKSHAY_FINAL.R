	## Using Keras
	library(keras)
  library(DBI)
# 	# #install_keras()
# 	# # library(tcltk)
# 	# # library(OpenImageR)
# 	# 
# 	# # Connecting to database
# 	con<-dbConnect(RPostgreSQL::PostgreSQL(),
# 	               dbname="me397",
# 	               host="db1.wrangler.tacc.utexas.edu",
# 	               port=5432 ,
# 	               user="varanasi",
# 	               password="Krsna@108")
# 
# 	# Listing the tables
# 	dbListTables(con)
# 
# 	# Reading the table
# 	sqldb=dbReadTable(con,"varanasi_akshay_eia_loc")
# 	# 
	
	# Reading the labels file
	df=read.csv('validation-annotations-human-imagelabels.csv')
	print(nrow(df))
	df=data.frame(df)
	df=df[c(1,3,4)]
	df = df[df$Confidence==1,]
	
	classes = c('/m/01g317', '/m/09j2d', '/m/04yx4', '/m/0dzct', '/m/07j7r', '/m/05s2s', '/m/03bt1vf', '/m/07yv9', '/m/0cgh4', '/m/01prls', '/m/09j5n', '/m/0jbk', '/m/0k4j', '/m/05r655', '/m/02wbm', '/m/0c9ph5', '/m/083wq', '/m/0c_jw', '/m/03jm5', '/m/0d4v4')
	
	df=df[df$LabelName %in% classes,]
	labels = as.character(df$LabelName)
	Imageid = as.character(df$ImageID)
	print(nrow(df))
	
	#dl=image_load(path = 'validation2/00a0b916fd5941a3.jpg',target_size = c(100,100))
	#x_train=image_to_array(img = dl,data_format = NULL)
	#df2=flow_images_from_directory(path = 'validation2',generator = image_data_generator(), target_size = c(100, 100))
	x_train=c()
	x_val=c()
	# To read the filenames in the directory into a list
	#jpgFiles <- list.files("validation", pattern="*jpg$", full.name=TRUE)
	
	# For reading the training
	for (filename in Imageid[10001:15000] ){
	  filepath = paste('validation/',filename,'.jpg',sep = "")
	  dl=image_load(path = filepath,grayscale = TRUE,target_size = c(100,100))
	  temp=image_to_array(img = dl,data_format = NULL)
	  x_train=append(x_train,temp)
	}
	
	# For reading the validation
	for (filename in Imageid[1:2000] ){
	  filepath = paste('validation/',filename,'.jpg',sep = "")
	  dl=image_load(path = filepath,grayscale = TRUE,target_size = c(100,100))
	  temp=image_to_array(img = dl,data_format = NULL)
	  x_val=append(x_val,temp)
	}
  
	# Normalizing the images
	x_train=x_train/255
	x_val=x_val/255
	
	# Labels
	y_train = c()
	y_val = c()
	
	# For training
	for(i in labels[10001:15000]){
	  temp=rep(0L,20)
	  temp[match(i,classes)]=1
	  y_train=rbind(y_train,temp)
	  rm(temp)
	}
	# For validation
	for(i in labels[1:2000]){
	  temp=rep(0L,20)
	  temp[match(i,classes)]=1
	  y_val=rbind(y_val,temp)
	  rm(temp)
	}
	
	
	# CNN 
	model <- keras_model_sequential() 
	model %>% 
	  layer_batch_normalization(input_shape = c(100L,100L,1L)) %>% 
	  layer_conv_2d(filters=4,kernel_size = c(2L,2L) ,strides=c(1L,1L))%>%
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>% 
	  layer_conv_2d(filters =8,kernel_size = c(2L,2L) ,strides=c(1L,1L))%>%  
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>% 
	  layer_conv_2d(filters = 16,kernel_size = c(2L,2L) ,strides=c(2L,2L))%>%  
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>% 
	  layer_conv_2d(filters=32,kernel_size = c(2L,2L) ,strides=c(1L,1L))%>%  
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>% 
	  layer_conv_2d(filters=32,kernel_size = c(2L,2L) ,strides=c(2L,2L))%>%  
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>% 
	  layer_flatten() %>%
	  layer_dense(units = 2048) %>%
	  layer_activation_parametric_relu() %>%
	  layer_batch_normalization() %>%
	  layer_dropout(rate = 0.25) %>% 
	  layer_dense(units = 1024)  %>%
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>%
	  layer_dropout(rate = 0.25) %>% 
	  layer_dense(units = 512) %>%
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>%
	  layer_dropout(rate = 0.25) %>%   
	  layer_dense(units = 128) %>%
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>%
	  layer_dropout(rate = 0.25) %>%   
	  layer_dense(units = 50) %>%
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>%
	  layer_dropout(rate = 0.25) %>%
	  layer_dense(units = 25)  %>% 
	  layer_activation_parametric_relu() %>% 
	  layer_batch_normalization() %>% 
	  layer_dropout(rate = 0.25) %>%
	  layer_dense(units = 20) %>%
	  layer_activation_softmax()
  

	
	# Next, compile the model with appropriate loss function, optimizer, and metrics:
	model %>% compile(
	  loss = "categorical_crossentropy",
	  optimizer = optimizer_adam(),
	  metrics = c("accuracy")
	)
  
	
	
	# look at the final model
	summary(model)

	x_train <- array_reshape(x_train, c(5000,100,100,1))
	x_val <- array_reshape(x_val, c(2000,100,100,1))
	
	# To fit the model
	history<-model %>% fit(
	  x=x_train,y=y_train, 
	  validation_data = list(x_val, y_val),
	  epochs = 2, batch_size = 1000,
	  verbose = 2
	)
	
	# To save memory
	rm(x_train,y_train,x_val,y_val)
	
	# df = read.csv('inclusive_images_stage_1_attributions.csv',header = FALSE)
	# df=data.frame(df)
	# im = df$V1
	# head(df)
  #jpgFiles <- list.files("validation", pattern="*jpg$", full.name=TRUE)
	
	x_test=c()
	# For reading the testing data
	for (filename in Imageid[25001:26000] ){
	  filepath = paste('validation/',filename,'.jpg',sep = "")
	  dl=image_load(path = filepath,grayscale = TRUE,target_size = c(100,100))
	  temp=image_to_array(img = dl,data_format = NULL)
	  x_test=append(x_test,temp)
	}
	
	# For evaluation
	y_test=c()
	for(i in labels[25001:26000]){
	  temp=rep(0L,20)
	  temp[match(i,classes)]=1
	  y_test=rbind(y_test,temp)
	  rm(temp)
	}
	
	
	# for (filename in im[1:1000] ){
	#   filepath = paste('inclusive_images_stage_1_images/',filename,'.jpg',sep = "")
	#   dl=image_load(path = filepath,grayscale = TRUE,target_size = c(100,100))
	#   temp=image_to_array(img = dl,data_format = NULL)
	#   x_test=append(x_test,temp)
	# }
	
	x_test<-x_test/255
	x_test <- array_reshape(x_test, c(nrow(y_test),100,100,1))
	 
	# pre = predict(X_test).argsort(1)[:,:5]
	pre=model%>%predict_classes(x_test)
	pre_old=model%>%predict(x_test)
	pre_new=model%>%predict_proba(x_test)
	evaluated=model%>%evaluate(x_test,y_test)
	
	predict_labels=data.frame()
	for(i in 1:nrow(pre_new)){
	  temp=sort(pre_new[i,],index.return=TRUE)$ix
	  predict_labels=rbind(predict_labels,temp)
	}
	colnames(predict_labels)=c('1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th','11th','12th','13th','14th','15th','16th','17th','18th','19th','20th')
	
	# Taking only the first column
	pre_1=predict_labels$`1st`
	# rm(x_test)
	# 
	labels_test =c()

	for (it in 1:length(pre_1)){
	   
	   q=classes[pre_1[it]] 
	#   print(q)
	   labels_test=append(labels_test,q)
	}
	
	ind=which(labels_test==labels[5001:10000])
	acc=length(ind)/length(labels_test)  
	df_test=df[5001:6000,]
	df_test$LabelName=labels_test
	write.csv(df_test,file = 'Labels_test.csv',row.names = FALSE)

	# 
	# #Disconnect the database
	# dbDisconnect(con)
	# 
	
##### Tried things
	
	# li = data.frame()
	# # for(i in classes) {
	#   li=rbind(li,df[df$LabelName == i,])
	# }
	
	# rm(li)
	
	
	## For progress bar
	  # total <- 20
	  # # create progress bar
	  # pb <- tkProgressBar(title = "progress bar", min = 0,
	  #                     max = total, width = 300)
	  # 
	# for(i in 1:total){
	#   Sys.sleep(0.1)
	#   setTkProgressBar(pb, i, label=paste( round(i/total*100, 0),
	#                                        "% done"))
	# }
	# close(pb)
