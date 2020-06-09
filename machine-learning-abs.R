#-------------------------------------
# This script sets out to visualise
# population size and internet access
# at the postcode level and see if
# a classifier algorithm works on it
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 9 June 2020
#-------------------------------------

library(tidyverse)
library(readxl)
library(caTools)
library(e1071)
library(kernlab)
library(Cairo)
library(ggpubr)

options(scipen = 999)

# Read in and prep data

d <- read_excel("C:/Users/trent.henderson/Desktop/population_data.xlsx")

d1 <- d %>%
  mutate(grouped_ra = case_when(
         ra_name_2016 == "Major Cities of Australia" ~ "Major City postcodes",
         grepl("Regional", ra_name_2016)             ~ "Regional postcodes",
         grepl("Remote", ra_name_2016)               ~ "Remote postcodes")) %>%
  mutate(prop_dwellings_internet_accessed = prop_dwellings_internet_accessed * 100)

d2 <- d %>%
  mutate(grouped_ra = case_when(
    ra_name_2016 == "Major Cities of Australia" ~ "Major City postcodes",
    TRUE                                        ~ "Not Major City")) %>%
  mutate(prop_dwellings_internet_accessed = prop_dwellings_internet_accessed * 100)

#------------------DATA VIS---------------------

# Reusable plotting function

plotter <- function(data){
  ggplot(data = data, aes(x = usual_resident_population, y = prop_dwellings_internet_accessed)) +
    geom_point(aes(colour = grouped_ra), stat = "identity", alpha = 0.5) +
    geom_smooth(aes(group = grouped_ra, colour = grouped_ra), method = "glm", formula = y ~ x) +
    scale_x_log10() +
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    theme_bw() +
    labs(title = "Australian postcode population size and internet access by regionality",
         x = "Log10 resident population",
         y = "Proportion of dwellings with internet access",
         colour = NULL,
         caption = "Source: ABS, Orbisant Analytics analysis.") +
    theme(legend.position = "bottom")
}

p <- plotter(d1)
print(p)

p1 <- plotter(d2)
print(p1)

#------------------MODELLING---------------------

# Recode to [0,1,2] factors

d3 <- d2 %>%
  mutate(grouped_ra = case_when(
         grouped_ra == "Major City postcodes" ~ 1,
         TRUE                                 ~ 0)) %>%
  mutate(grouped_ra = as.factor(grouped_ra)) %>%
  dplyr::select(c(usual_resident_population, prop_dwellings_internet_accessed, grouped_ra)) %>%
  mutate(usual_resident_population = log10(usual_resident_population))

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

#------------------EXPORTS-----------------------

CairoPNG("C:/Users/trent.henderson/Desktop/abs_chart.png", 600, 400)
print(p)
dev.off()

CairoPNG("C:/Users/trent.henderson/Desktop/abs_chart_2_levels.png", 600, 400)
print(p1)
dev.off()

ggarrange()
