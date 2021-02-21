#%%
import pandas as pd
import numpy as np
import urllib.request
from selenium import webdriver
import time

#%%
file = "C:\\Users\\citco\\OneDrive\\Documents\\PersonalProject\\companies_url.csv"

df = pd.read_csv(file)

driver = webdriver.Chrome()

data = pd.DataFrame(columns = ['cui', 'name', 'nr_matriculare', 'establishment_date', 'obs', 'county', 'place', 'nr_asociati', 'nr_admin', 'nr_sucursale', 'nr_sedii_secundate', 'financial_data'])
#balance = pd.DataFrame()
#%% 
data2 = pd.DataFrame(columns = ['cui', 'name', 'nr_matriculare', 'establishment_date', 'obs', 'county', 'place', 'nr_asociati', 'nr_admin', 'nr_sucursale', 'nr_sedii_secundate', 'financial_data'])
#%%
data1 = pd.DataFrame(columns = ['cui', 'name', 'nr_matriculare', 'establishment_date', 'obs', 'county', 'place', 'nr_asociati', 'nr_admin', 'nr_sucursale', 'nr_sedii_secundate', 'financial_data'])
#%%
for i in range(19587, 25000, 1):
    link = df.loc[i,'x']
    driver.get(link)
    date_de_identificare = driver.find_element_by_id("date-de-identificare")
    cui = link[-9:-1]
    name = driver.find_element_by_xpath('//*[@id="date-de-identificare"]/tbody/tr[2]/td[2]').text
    nr_matriculare = driver.find_element_by_xpath('//*[@id="date-de-identificare"]/tbody/tr[4]/td[2]').text[:-1]
    establishment_date = driver.find_element_by_xpath('//*[@id="date-de-identificare"]/tbody/tr[6]/td[2]').text
    obs = driver.find_element_by_xpath('//*[@id="date-de-identificare"]/tbody/tr[7]/td[2]/span').text
    county = driver.find_element_by_xpath('//*[@id="contact"]/tbody/tr[2]/td[2]').text
    place = driver.find_element_by_xpath('//*[@id="contact"]/tbody/tr[3]/td[2]').text
    nr_asociati = driver.find_element_by_xpath('//*[@id="informatii-statistice"]/tbody/tr[2]/td[2]').text
    nr_admin = driver.find_element_by_xpath('//*[@id="informatii-statistice"]/tbody/tr[3]/td[2]').text
    nr_sucursale = driver.find_element_by_xpath('//*[@id="informatii-statistice"]/tbody/tr[4]/td[2]').text
    nr_sedii_secundate = driver.find_element_by_xpath('//*[@id="informatii-statistice"]/tbody/tr[5]/td[2]').text
    
    table = driver.find_element_by_xpath('//*[@id="bilant"]/table/tbody')
    rows = table.find_elements_by_tag_name('tr')
    #print(len(rows))
    #print(str(len(rows)-14))
    
    all_rows = pd.DataFrame()
    for y in range(1,len(rows)-14,1):
        yearly_row = []
        for z in range(8):
            value = driver.find_element_by_xpath('//*[@id="bilant"]/table/tbody/tr[' + str(y+1) + ']/td[' + str(z+1) + ']').text.replace(" ", "")
            yearly_row.append(value)
        all_rows[y] = yearly_row
    #all_rows.columns = ['id','year', 'cifra_de_afaceri', 'net_profit', 'debts', 'long_term_assets', 'short_term_assests', 'capitals', 'nr_employees']
    data1.loc[i] = [cui, name, nr_matriculare, establishment_date, obs, county, place, nr_asociati, nr_admin, nr_sucursale, nr_sedii_secundate, all_rows.transpose()]
    if i%100 == 0:
        print('Got another hundred', i)
        print(i/len(df) * 100, "%")
    if i%500 == 0:
        time.sleep(300)
        print('I took a nap at', i, ' now I am ready to move forward')
data1.to_excel('general_data3.xlsx')
# %%
