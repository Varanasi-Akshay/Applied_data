# linear program example from 
# http://lpsolve.sourceforge.net/5.5/formulate.htm
# solved here using lpSolveAPI
# remember to refer to the lpSolveAPI documentation if you have questions about a function

library(lpSolveAPI)

#define the datasets
crops<-data.frame(type=c('wheat','barley'), acre_cost=c(120,210), harvest_bushels_per_acre=c(110,30), harvest_profit_per_bushel=c(1.3, 2.0))

#define the right hand side of the constraints
money <- 15000
harvest_storage_bushels <- 4000
plant_acres <- 75

#create an LP model with 3 constraints and 2 decision variables
lpmodel<-make.lp(3,2)

#fill in the coefficients of the constraints. You could also use "set.row" or other techniques
set.column(lpmodel,1,c(crops$acre_cost[1], crops$harvest_bushels_per_acre[1], 1),c(1,2,3))
set.column(lpmodel,2,c(crops$acre_cost[2], crops$harvest_bushels_per_acre[2], 1),c(1,2,3))
#view the model
lpmodel

#set objective coefficients
set.objfn(lpmodel, c(crops$harvest_bushels_per_acre[1]*crops$harvest_profit_per_bushel[1], crops$harvest_bushels_per_acre[2]*crops$harvest_profit_per_bushel[2]))

#set constraints
set.rhs(lpmodel, c(money, harvest_storage_bushels, plant_acres))
set.constr.type(lpmodel, c("<=", "<=", "<="))

#set objective direction
lp.control(lpmodel,sense='max')

#we can write the model to a text file to visualize how the model object is being written and make sure it aligns with our mathematical equations. This file can be viewed in SublimeText or other readers. 
#you can also just run "lpmodel" (or whatever the name of your linear program object is) and the console will print table of coefficients/information
#however, for larger models, the console will not print everything, and using "write.lp" is the best method for viewing the linear program object
write.lp(lpmodel,'example_1.lp',type='lp')

#solve the model, if this return 0 an optimal solution is found
solve(lpmodel)

#this returns the proposed solution
get.objective(lpmodel) #value of the objective (i.e. the farmer's profit)
get.variables(lpmodel) #value of the variables for achieving the objective (how much wheat and barley to plant)
get.constraints(lpmodel) #value of the constraint equations. If get.constraints = the right hand side of the constraint equation, then that constraint is "binding" and the solution could be better if we could improve that constraint. For example, the money constraint in the solution is $13,781.25 which is less than the $15,000 of money the farmer starts with. So giving the farmer more money up front would not enable them to make more profit. However, the storage constraint is 4,000 which is equal to the farmer's 4000 bushel storage capacity. So giving the farmer more storage capacity might enable them to increase profit.
