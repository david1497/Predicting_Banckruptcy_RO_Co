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

#for (i in 1:10) {
urlOfTheList = ListOfUrls[1]
theLinks <- urlOfTheList %>%
  read_html() %>%
  html_nodes(".clickable-row a") %>%
  html_attr("href")
theLinks[1] = ""
for (i in 1:length(theLinks)){
  theLinks[i] = paste("https://www.listafirme.ro",theLink[i])
  theLinks[i] = stri_replace_all_charclass(theLinks[i], "\\p{WHITE_SPACE}", "")
}
ListOfCompanyUrls = c(ListOfCompanyUrls, theLinks)
#}


siteUrl <- "https://www.listafirme.ro/rud-florian-rieger-srl-15721889/"
tbl.page <- siteUrl %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="bilant"]/table') %>%
  html_table() %>%
  as_tibble(.name_repair = make.names)

# Getting just the table from the tibble
df = tbl.page$X

# Renaming the columns with proper names
colnames(df) <- c("Anul","CifraAfaceri","ProfitNet","Datorii","ActiveImobilizate","ActiveCirculante","CapitaluriProprii","Angajati")

# Deleting the last row as it contains the graph
df = df[-nrow(df),]

# Converting the columns from char to integer
for (i in 1:8) {
  df[,i] <- stri_replace_all_charclass(df[,i], "\\p{WHITE_SPACE}", "")
  df[,i] <- as.numeric(df[,i])
  print(typeof(df[,i]))
}

