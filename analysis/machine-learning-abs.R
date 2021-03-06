#-------------------------------------
# This script sets out to build a 
# Support Vector Machine algorithm
#
# NOTE: This script requires setup.R
# to have been run first
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 9 June 2020
#-------------------------------------

# Load data

d1 <- read_excel("data/three_level.xlsx")
d2 <- read_excel("data/two_level.xlsx")
d3 <- read_excel("data/two_level_factored.xlsx")

#------------------MODELLING---------------------

# Split into test and train data

set.seed(123) 
split = sample.split(d3$grouped_ra, SplitRatio = 0.75) 

train = subset(d3, split == TRUE) 
test = subset(d3, split == FALSE) 

#--------------------
# FEATURE ENGINEERING
#--------------------

# Scale features

train[-3] = scale(train[-3]) 
test[-3] = scale(test[-3]) 

#-----------------------------
# BUILD SUPPORT VECTOR MACHINE
#-----------------------------

# e1071 approach

model <- svm(formula = grouped_ra ~ prop_dwellings_internet_accessed + usual_resident_population, 
                 data = train,
                 kernel = 'radial')

plot(model, train)

# kernlab approach

kern_model <- ksvm(grouped_ra ~ prop_dwellings_internet_accessed + usual_resident_population, 
            data = train,
            type = "C-svc",
            kernel = 'rbfdot')

kernlab::plot(kern_model)

# Evaluate prediction accuracy

ypred <- predict(model, test)
(misclass <- table(predict = ypred, truth = test$grouped_ra))

kern_ypred <- predict(kern_model, test)
(kern_misclass <- table(predict = kern_ypred, truth = test$grouped_ra))
