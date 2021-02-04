import urllib.request
from selenium import webdriver
import time
from captcha_solver import CaptchaSolver
import requests

url = 'https://mfinante.gov.ro/apps/agenticod.html?pagina=domenii'
    
print(url)
    
driver = webdriver.Chrome()

driver.get(url)

cui = '13586387'
cui_field = driver.find_element_by_class_name('form2')
cui_field.send_keys(cui)


visualize_btn = driver.find_element_by_class_name('form1')

col_sm_4 = driver.find_elements_by_class_name('col-sm-4')

def access_the_balance():
    
    
    visualize_bs_btn = driver.find_element_by_name('method.bilant')
    visualize_bs_btn.click()


if len(col_sm_4[1].text) > 1:
    print("We need the captcha")
    time.sleep(5)
    visualize_btn.click()
    
    years = driver.find_element_by_xpath('/html/body/font/form/select')#('codfiscalForm')
    print(years.text)
    
else:
    visualize_btn.click()