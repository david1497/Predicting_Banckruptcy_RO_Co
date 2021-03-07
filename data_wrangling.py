#%%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

%matplotlib inline

#%%
data = pd.read_excel('financial_data.xlsx')
data = pd.DataFrame(data)
#%% Getting just the year of establishment
for i in range(0, 34008, 1):
    if len(data.iloc[i, 4]) == 6:
        data.iloc[i, 4] = data.iloc[i, 4][:4]
        print(str(i), data.iloc[i, 4])
    else:
        data.iloc[i, 4] = data.iloc[i, 4][-4:]
        print(str(i), data.iloc[i, 4])
# %%
