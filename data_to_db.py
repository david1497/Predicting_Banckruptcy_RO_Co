#%%
import pyodbc
import pandas as pd 
#%%
data = pd.read_excel('clean_financial_data.xlsx')
data = pd.DataFrame(data)
#%%
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=LAPTOP-TTIP97EM\SQLEXPRESS;Database=CompaniesData;Truested_Connection=yes')
cursor = conn.cursor()
# %%
def data_insertion(cursor, cui, name, mat_numb, est_year, obs, county, place, assoc, admin, branches, offices):
    cursor.execute('''
                    INSERT INTO CompaniesData.dbo.Companies
                    VALUES (cui, name, mat_numb, est_year, obs, county, place, assoc, admin, branches, offices),
                    ''')
    conn.commit()
    print('Data was inserted successfully!')

for i in range(0, len(data)):
    #data_insertion(cursor, data.cui[i], data.name[i], data.nr_matriculare[i], data.establishment_date[i], data.obs[i], data.county[i], data.place[i], data.nr_asociati[i], data.nr_admin[i], data.nr_sucursale[i], data.nr_sedii_secundate[i])
    cursor.execute('''
                    INSERT INTO CompaniesData.dbo.Companies
                    VALUES (?,?,?,?,?,?,?,?,?,?,?)
                    ''', 
                    (data.cui[i], data.name[i], data.nr_matriculare[i], data.establishment_date[i], data.obs[i], data.county[i], data.place[i], data.nr_asociati[i], data.nr_admin[i], data.nr_sucursale[i], data.nr_sedii_secundate[i]))
    conn.commit()
    if i%500 == 0: 
        print(str(i/len(data)*100) + " % of data was inserted successfully!")