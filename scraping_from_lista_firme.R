library(xml2)
library(rvest)
library(tidyverse)
library(Gmedian)
library(tibble)
library(usethis)
library(devtools)
library(stringi)

ListOfUrls = c()

# saving all pages with lists of companies in one list
# there are 16 840 pages with tables containing links to the companies data, 
# each table contains 50 links to a company, therefore, we
# must receive about 16 840 * 50 = 842 000 links
# At this point, we are saving all links to the pages with tables, next step will be to copy the
# links to each company.
z = 16840
for (i in 1:z) {
  a = paste("https://www.listafirme.ro/pagini/p",i,".htm")
  a <- stri_replace_all_charclass(a, "\\p{WHITE_SPACE}", "")
  ListOfUrls = c(ListOfUrls, a)
  percent = i/z * 100
  print(paste0(percent, "%"))
  if(percent == 100) {
    print(paste0("=========================", "Sir, all links were copied :D "))
  }
}

ListOfCompanyUrls = c()
# the next step is to scrap all the links to every company and save it into another list

# Collecting all the links to each company that exists on listafirme
# Because the site can detect if there is an unusual traffic, you have to change the beginning of the range
# It takes few minutes until it stops, but, in the mean time it scraps the links to more than 50 000 companies
# You just have to get back on the website and click that it is a normal traffic, later get back to your working env
# and set the start of the range from the last page processed(i-1)
# Now we will start processing 
for (i in 16607:length(ListOfUrls)) {
  urlOfTheList = ListOfUrls[1]
  theLinks <- urlOfTheList %>%
    read_html() %>%
    html_nodes(".clickable-row a") %>%
    html_attr("href")
  for (y in 1:length(theLinks)){
    theLinks[y] = paste("https://www.listafirme.ro",theLinks[y])
    theLinks[y] = stri_replace_all_charclass(theLinks[y], "\\p{WHITE_SPACE}", "")
    print(paste0(y, " links from the ", i, " page were copied"))
  }
  ListOfCompanyUrls = c(ListOfCompanyUrls, theLinks)
  print(i)
}



# creating a function that will extract the CUI from the company link
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


# Now the party starts. It may take some time until we get all the data :D 

the_data = data.frame()
# Scrapping the bilant table for each company, it means that the algorithm has to run through each link
# and get each table for each company
w = 0
for (link in 57600:length(ListOfCompanyUrls)){
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
  
  # to remember what is the last link that was accessed
  print(link)
  w = w + 1

}

# For more details regarding CUI, check this page
# https://www.onrc.ro/index.php/ro/ce-reprezinta-si-cum-se-obtin-numarul-de-ordine-in-registrul-comertului-cui-ul-si-cif-ul
# Get the CAEN code, matriculation number, city, county, nr_asociati, nr_admin, nr_suc, nr_sedii_sec
