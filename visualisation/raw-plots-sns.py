#-------------------------------------
# This script sets out to reproduce
# the raw data graph made in the 
# original .R data vis file
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
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Use seaborn plotting defaults

import seaborn as sns; sns.set()

#%%

# Import data

d = pd.read_excel("/Users/trenthenderson/Documents/R/abs-postcode-svm/data/two_level.xlsx")

# Log scale population

d['usual_resident_population'] = np.log10(d['usual_resident_population'])

#%%

# Make plot

p = sns.lmplot(x = "usual_resident_population", y = "prop_dwellings_internet_accessed", 
           hue = "grouped_ra", data = d, legend = False)

p.set_axis_labels("Log10 resident population", "Proportion dwellings with internet access (%)")

# Add better legend

plt.legend(title = 'Regionality', loc = 'lower left', labels = ['Major city postcodes', 'Not major city'])
plt.savefig('/Users/trenthenderson/Documents/R/abs-postcode-svm/output/abs_plt.png', dpi = 1000)
plt.show(p)
