#-------------------------------------
# This script sets out to build a 
# Support Vector Machine algorithm
# and visualise results
#
# NOTE: This script requires the .R
# scripts to have been run first as
# most of the preprocessing was done
# there
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 9 June 2020
#-------------------------------------

#%%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import classification_report, confusion_matrix
from mlxtend.plotting import plot_decision_regions

# Use seaborn plotting defaults

import seaborn as sns; sns.set()

#%%

# Import data

d = pd.read_excel("/Users/trenthenderson/Documents/R/abs-postcode-svm/data/two_level_factored.xlsx")

#%%
# Split into X and y

X = d.drop('grouped_ra', axis=1)
y = d['grouped_ra']

#%%

# Scale data

scaler = MinMaxScaler(feature_range=(0, 1))
X = scaler.fit_transform(X)

# Split into train and test

xTrain, xTest, yTrain, yTest = train_test_split(X, y, test_size = 0.2, random_state = 0)

#%%

# Fit model using a Radial Basis Function for nonlinearity

model = SVC(kernel = 'rbf', C = 1E6)
model.fit(xTrain, yTrain)


#%%
# Visualise model

plot_decision_regions(X = xTrain, 
                      y = yTrain.values,
                      clf = model, 
                      legend = 2)

# Update plot object with X/Y axis labels and Figure Title

plt.xlabel("Usual resident population", size = 12)
plt.ylabel("Proportion dwellings with internet access", size = 12)
plt.title("Population and internet access predict regionality", size = 14)
plt.savefig('/Users/trenthenderson/Documents/R/abs-postcode-svm/output/svm_plt.png', dpi = 1000)
plt.show()

#%%

# Evaluate model accuracy

y_pred = model.predict(xTest)
print(confusion_matrix(yTest, y_pred))
print(classification_report(yTest, y_pred))