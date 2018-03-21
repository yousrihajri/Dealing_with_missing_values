#Types of Missing Values

#Missing values are typically classified into three types 
#- MCAR, MAR, and NMAR.

#MCAR stands for Missing Completely At Random and is the rarest type of missing values
#when there is no cause to the missingness. In other words, the missing values are 
#unrelated to any feature, just as the name suggests.

#MAR stands for Missing At Random and implies that the values which are missing
#can be completely explained by the data we already have. 

#If the missing values are not MAR or MCAR then they fall into the third category
#of missing values known as Not Missing At Random, otherwise abbreviated as NMAR. 





#Loading the mice package
library(mice)

#Loading the following package for looking at the missing values
library(VIM)
library(lattice)
data(nhanes)

nhanes$age=as.factor(nhanes$age)

#understand the missing value pattern
md.pattern(nhanes)

#plot the missing values
nhanes_miss = aggr(nhanes, col=mdc(1:2),
                   numbers=TRUE, sortVars=TRUE,
                   labels=names(nhanes),
                   cex.axis=.7,
                   gap=3,
                   ylab=c("Proportion of missingness","Missingness Pattern"))

#Drawing margin plot
marginplot(nhanes[, c("chl", "bmi")],
           col = mdc(1:2),
           cex.numbers = 1.2, pch = 19)




#Imputing missing values using mice
mice_imputes = mice(nhanes, m=5, maxit = 40)
#I have used three parameters for the package. The first is the dataset,
#the second is the number of times the model should run.
#I have used the default value of 5 here.
#This means that I now have 5 imputed datasets.
#Every dataset was created after a maximum of 40 iterations
#which is indicated by "maxit" parameter.

#What methods were used for imputing and what is the result
mice_imputes$method
mice_imputes$imp

#Imputed dataset
Imputed_data=complete(mice_imputes,5)

#Plotting and comparing values with xyplot()
xyplot(mice_imputes, bmi ~ chl | .imp, pch = 20, cex = 1.4)
#Here again, the blue ones are the observed data and red ones are imputed data.
#The red points should ideally be similar to the blue ones so that the imputed 
#values are similar. We can also look at the density plot of the data.

#make a density plot
densityplot(mice_imputes)
#Just as it was for the xyplot(), the red imputed values should be similar
#to the blue imputed values for them to be MAR here.




