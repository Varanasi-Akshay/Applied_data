## R code tidbits to go with ME397M Lecture 5: Data structures 
## Joshua D. Rhodes, PhD
## Much of this lecture taken from: http://adv-r.had.co.nz/


## General information or metadata about a object in R

x <- 1
str(x)

y <- c(1,2,4)
str(y)

z <- 1:4000
str(z)

w <- c(1,2,'w', 'day', 0)
str(w) # since a vector is homogeneous (consisting of parts all of the same kind) it assigns everyting to be a character 

p <- list(1,2,'w', 'day', 0)
str(p) # since a list can be heterogeneous (diverse in character or content) it assigns each element to its own type

m <- matrix(1:4, ncol = 2, nrow = 2)
str(m)

m2 <- matrix(c(1,2,'a',5), ncol = 2, nrow = 2)
str(m2) # matrices are homogeneous like vectors

txpuc <- read.csv('RHODES_TXPUC_HWK1_Jun_07.csv')
str(txpuc)

## note that 'Plan' and 'month' are factors, but you can avoid this by using stringsAsFactors = FALSE

txpuc2 <- read.csv('RHODES_TXPUC_HWK1_Jun_07.csv', stringsAsFactors = FALSE)
str(txpuc2)

## typeof() can also give you some info 

typeof(x)
typeof(y)
typeof(p)
typeof(m)
typeof(txpuc2)

################################################## ATOMIC Vectors ##################################################

## Integers vectors
int_var <- 1:50
str(int_var)
typeof(int_var)

is.integer(int_var)

int_var2 <- int_var+1
is.integer(int_var2)

int_var3 <- int_var+1L
is.integer(int_var3)

object.size(int_var)
object.size(int_var2)
object.size(int_var3)

## Doubles vectors
dbl_var <- seq(from = 0, to = 10, by = 0.2) ## seq() builds a uniform sequence
head(dbl_var) # first 6 rows of dbl_var
tail(dbl_var) # last 6 rows of dbl_var
str(dbl_var)
typeof(dbl_var)

is.double(dbl_var) # check status -- is.double(dbl_var) is a logical, so it can be used as a test in an if statement

if(is.double(dbl_var)){
	print("It's a double")
} else{"NOPE! Do not pass go, do not collect $200!"}

is.numeric(int_var) # general test for the “numberliness” of a vector and returns TRUE for both integer and double vectors
is.numeric(dbl_var)

## Logical vectors

log_var <- c(TRUE, FALSE, T, F)
log_var

# for loop that cycles through log_var and prints i if log_var[i] is TRUE
for(i in 1:4){
	if(log_var[i]){
		print(i)
	}
}

as.numeric(log_var) # TRUE = 1, FALSE = 0
sum(log_var)

## Character vectors
chr_var <- c("these are", "some strings") 
is.character(chr_var)

# vectors are flat (hierarchies are dismantled) and mixes are given as characters
g <- c(1, 'A', c(5, 4), c(3, c('e', 't', 4)))
str(g)
typeof(g)

dim(g) # NULL cause vectors just have a length
length(g)

#characters weigh a lot
object.size(g)
g2 <- 1:8
object.size(g2) # integers
object.size(as.double(g2)) # doubles


################################################## Lists ##################################################

x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
str(x)

length(x)
length(x[[1]])
length(x[[2]])
length(x[[3]])
length(x[[4]])

r <- list(list(list(list()))) # you can lists on lists on lists
str(r)

unlist(x) # "flattens" a list, i.e. makes is into an atomic vector


################################################## Matrices and arrays ##################################################

# Two scalar arguments to specify rows and columns
a <- matrix(1:6, ncol = 3, nrow = 2)
# One vector argument to describe all dimensions
b <- array(1:12, c(2, 3, 2))

# You can also modify an object in place by setting dim()
c <- 1:6
dim(c) <- c(3, 2)
c

dim(c) <- c(2, 3)
c

# you can get the dimentions of a matrix by asking
nrow(a)
ncol(a)

# you can set the names of the rows and columns of a matrix as well
rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")

# you can also set the names of the array by sending it a list of names for the y, x, and z directions, etc.
dimnames(b) <- list(c("one", "two"), c("a", "b", "c"), c("A", "B"))
b

## for matrices, all the matrix things apply: https://www.statmethods.net/advstats/matrix.html

t(a) # transpose
diag(a) # get the diagonal values
svd(a) # single value decomposition of a
solve(a) # inverse of a
solve(a[1:2,1:2]) # oops, need a square matrix for inverse...



################################################## Data frames ##################################################

df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)

# data frames like factors, but you might not...
df <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = F)
str(df)

# you can combine dataframes (on columns) using cbind() and (on rows) using rbind()
cbind(df, data.frame(z = 3:1))

rbind(df, data.frame(x = 10, y = "z"))

# data frames can be subsetted into atomic vectors using the atomic operator "$"
df$x


################################################## Factors ##################################################

x <- factor(c("a", "b", "b", "a"))
x # note that only unique values are kept

class(x)
levels(x)

# characters can be coerced to factors if that woudl be helpful for anlaysis
sex_char <- c("m", "m", "m")
table(sex_char)

sex_factor <- factor(sex_char, levels = c("m", "f"))
table(sex_factor)








