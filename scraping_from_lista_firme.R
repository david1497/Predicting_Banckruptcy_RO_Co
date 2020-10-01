library(rvest)
library(tidyverse)
library(Gmedian)
library(tibble)
library(devtools)
library(stringi)

ListOfUrls = c()

# saving all pages with lists of companies in one list
for (i in 1:16487) {
  a = paste("https://www.listafirme.ro/pagini/p",i,".htm")
  a <- stri_replace_all_charclass(a, "\\p{WHITE_SPACE}", "")
  ListOfUrls = c(ListOfUrls, a)
}

ListOfCompanyUrls = c()
# the next step is to scrap all the links to every company and save it into another list

# Collecting all the links to each company that exists on listafirme
# Because the site can detect if there is an unusual traffic, you have to change the beginning of the range
# It takes few minutes until it stops, but, in the mean time it scraps the links to more than 50 000 companies
# You just have to get back on the website and click that it is a normal traffic, later get back to your working env
# and set the start of the range from the last page processed
for (i in 14604:16487) {
  urlOfTheList = ListOfUrls[1]
  theLinks <- urlOfTheList %>%
    read_html() %>%
    html_nodes(".clickable-row a") %>%
    html_attr("href")
  for (i in 1:length(theLinks)){
    theLinks[i] = paste("https://www.listafirme.ro",theLinks[i])
    theLinks[i] = stri_replace_all_charclass(theLinks[i], "\\p{WHITE_SPACE}", "")
  }
  ListOfCompanyUrls = c(ListOfCompanyUrls, theLinks)
}

# creating a function that will extract he CUI from the company link
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


the_data = data.frame()
# Scrapping the bilant table for each company, it means that the algorithm has to run through each link
# and get each table for each company
w = 0
for (link in 7096:length(ListOfCompanyUrls)){
  siteUrl <- ListOfCompanyUrls[link]
  tbl.page <- siteUrl %>%
    read_html() %>%
    html_nodes(xpath='//*[@id="bilant"]/table') %>%
    html_table() %>%
    as_tibble(.name_repair = make.names)

  # Getting just the table from the tibble
  df = tbl.page$X
  
  # Some of the companies don't have any data. Therefore, we have to skip those companies
  # we will check if there are no rows
  if (nrow(df) > 0){
    # Deleting the last row as it contains the graph
    df = df[-nrow(df),]
    df = df[-nrow(df),]
    
    # Converting the columns from char to double
    for (i in 1:8) {
      df[,i] <- stri_replace_all_charclass(df[,i], "\\p{WHITE_SPACE}", "")
      df[,i] <- as.numeric(df[,i])
    }
    
    # Renaming the columns with proper names
    colnames(df) <- c("Anul","CifraAfaceri","ProfitNet","Datorii","ActiveImobilizate","ActiveCirculante","CapitaluriProprii","Angajati")
  
    # Converting the list to data frame for more conveniency
    df = data.frame(df)
    namevector = c("CUI")
    
    # Creating the CUI value of each company to store it as an ID for each company
    for (i in 1:nrow(df)){
      a = substrRight(link, 9)
      a = substr(a, 1, nchar(a)-1)
      df[,namevector] <- a  
    }
    
    the_data = append(the_data, df)
  }
  else {
    print("Upps, empty jar")
  }
  print(link)
  w = w + 1
}
