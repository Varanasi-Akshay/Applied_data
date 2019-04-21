# linear program example from 
# https://www.r-bloggers.com/linear-programming-in-r-an-lpsolveapi-example/
# solved here using lpSolveAPI
# remember to refer to the lpSolveAPI documentation if you have questions about a function

library(lpSolveAPI)

#define the datasets
train<-data.frame(wagon=c('w1','w2','w3'), weightcapacity=c(10,8,12), spacecapacity=c(5000,4000,8000))
cargo<-data.frame(type=c('c1','c2','c3','c4'), available=c(18,10,5,20), volume=c(400,300,200,500),profit=c(2000,2500,5000,3500))

#create an LP model with 10 constraints and 12 decision variables
lpmodel<-make.lp(2*NROW(train)+NROW(cargo), NROW(train) * NROW(cargo))
#write the lp to a file that we can view in SublimeText or other readers
write.lp(lpmodel,'example_2.lp',type='lp')

#I used this to keep count within the loops, I admit that this could be done a lot neater
column<-0
row<-0

#build the model column per column
for(wg in train$wagon){
  row<-row+1 #tracks our loop progress
  for(type in seq(1,NROW(cargo$type))){
    column<-column+1 #tracks our loop progress
    
    #this takes the arguments 'column','values' & 'indices' (as in where these values should be placed in the column)
    set.column(lpmodel,column,c(1, cargo[type,'volume'],1), indices=c(row,NROW(train)+row, NROW(train)*2+type))
  }}
write.lp(lpmodel,'example_2.lp',type='lp') #see how the linear program looks now

#set rhs constraints for weight capacities
set.rhs(lpmodel, train$weightcapacity, constraints=seq(1,NROW(train)))
write.lp(lpmodel,'example_2.lp',type='lp') #see how the linear program looks now

#set rhs constraints for space capacities
set.rhs(lpmodel, train$spacecapacity, constraints=seq(NROW(train)+1,NROW(train)*2))
write.lp(lpmodel,'example_2.lp',type='lp') #see how the linear program looks now

#set rhs constraints for amount of available cargo
set.rhs(lpmodel, cargo$available, constraints=seq(NROW(train)*2+1,NROW(train)*2+NROW(cargo)))
write.lp(lpmodel,'example_2.lp',type='lp') #see how the linear program looks now

#set objective coefficients
set.objfn(lpmodel, rep(cargo$profit,NROW(train)))

#set objective direction
lp.control(lpmodel,sense='max')
write.lp(lpmodel,'example_2.lp',type='lp') #see how the linear program looks now. We should be done at this point.

#solve the model, if this returns 0 an optimal solution is found
solve(lpmodel)

#this returns the proposed solution
get.objective(lpmodel)
get.variables(lpmodel)
get.constraints(lpmodel)

#we can access the solutions piecemeal to help us keep track of what information is in the solution. This requires some organization, so be careful.
#for example
variable_results = get.variables(lpmodel)
loop_num = 0
for (wag in train$wagon){
  for (crg in cargo$type){
    loop_num <- loop_num+1
    print (paste("Cargo #", crg, " in Wagon #", wag, ": ", variable_results[loop_num], sep=""))
  }
}
#which could be organized into a dataframe or whatever results output you want
