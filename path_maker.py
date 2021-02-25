# This file is creating the links to each company on the lista firme 
#%%
import pandas as pd

# %%
#Getting the rough links
file = 'C:\\Users\\citco\\OneDrive\\Documents\\PersonalProject\\merged.csv'

#%%
suffixes = pd.DataFrame(pd.read_csv(file))
suffixes = suffixes.iloc[:,-1]
# Removing all symbols before the comma
suffixes = suffixes.str.split(',').str[1]
# Replacing " with empty space, via this removing the " so that we can create the link
suffixes = suffixes.str.replace('"', '')
# Adding the prefix to each suffix
links = pd.DataFrame('https://www.listafirme.ro/' + suffixes.astype(str))
# Saving the full links to the csv file. It will be taken and used in the next file.
links.iloc[:, -1].to_csv('companies_url.csv')