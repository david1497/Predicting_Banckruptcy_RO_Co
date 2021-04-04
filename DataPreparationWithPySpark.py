#%%
import pyspark
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql.types import *
from data_to_db import *


#%%
spark = SparkSession.builder.appName("DataCleaning").getOrCreate()
spark

#%%
data_file = "financial_data.xlsx"
path_to_data = "C:/Users/citco/OneDrive/Documents/PersonalProject/"

# %%
data = pd.read_excel(data_file, inferSchema=True)

# %%
data = data.drop(data.columns[0], axis=1)
# Removing everything before - (including) to keep the cui pure
data.cui = data.cui.str.split('\-').str[-1].str.strip()
# %%
for i in range(0, len(data)):
    if len(data.establishment_date[i]) == 6:
        data.establishment_date[i] = data.establishment_date[i][:4]
    else:
        data.establishment_date[i] = data.establishment_date[i][-4:]
# %%
data.nr_asociati = data.nr_asociati.str.rstrip(' -')
data.nr_admin = data.nr_admin.str.rstrip(' -')
data.nr_sucursale = data.nr_sucursale.str.rstrip(' -')
data.nr_sedii_secundate = data.nr_sedii_secundate.str.rstrip(' -')
# %%
