my_first_function<-function(file,value){
  
  print('Hello World!')
  data<-read.csv(file)
  print(head(data))
  print(value)
  
}