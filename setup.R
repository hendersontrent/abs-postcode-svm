#-------------------------------------
# This script sets out to define
# package loads for the project
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
library(writexl)

options(scipen = 999)

# Create an output folder if none exists:

if(!dir.exists('output')) dir.create('output')
