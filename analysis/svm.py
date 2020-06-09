#-------------------------------------
# This script sets out to build a 
# Support Vector Machine algorithm
# and visualise results
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

# Use seaborn plotting defaults

import seaborn as sns; sns.set()

#%%

# Import data

d = pd.read_excel("/Users/trenthenderson/Documents/R/abs-postcode-svm/data/two_level_factored.xlsx")

#%%

# Reusable SVM plotting function
# From https://jakevdp.github.io/PythonDataScienceHandbook/05.07-support-vector-machines.html

def plot_svc_decision_function(model, ax=None, plot_support=True):
    """Plot the decision function for a 2D SVC"""
    if ax is None:
        ax = plt.gca()
    xlim = ax.get_xlim()
    ylim = ax.get_ylim()
    
    # create grid to evaluate model
    x = np.linspace(xlim[0], xlim[1], 30)
    y = np.linspace(ylim[0], ylim[1], 30)
    Y, X = np.meshgrid(y, x)
    xy = np.vstack([X.ravel(), Y.ravel()]).T
    P = model.decision_function(xy).reshape(X.shape)
    
    # plot decision boundary and margins
    ax.contour(X, Y, P, colors='k',
               levels=[-1, 0, 1], alpha=0.5,
               linestyles=['--', '-', '--'])
    
    # plot support vectors
    if plot_support:
        ax.scatter(model.support_vectors_[:, 0],
                   model.support_vectors_[:, 1],
                   s=300, linewidth=1, facecolors='none');
    ax.set_xlim(xlim)
    ax.set_ylim(ylim)


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

plt.scatter(xTrain[:, 0], xTrain[:, 1], c = yTrain, cmap = 'coolwarm')
plot_svc_decision_function(model)
plt.scatter(model.support_vectors_[:, 0], model.support_vectors_[:, 1],
            lw = 1, facecolors = 'none');
