library(tidyverse)
library(xml2)
library(furrr)
future::plan(multisession)
library(tictoc)
tic()

VERB <- "<w[^<]+pos=\"verb\"[^<]+</w>"

collexeme.preparer <- function(files) {
  number <- basename(files)
  
  xmlread <- read_xml(files) # read in xml
  xmlsentence <- xml_find_all(xmlread, "//s") # find all sentences
  xml.sentencecharacter <- tolower(as.character(xmlsentence)) # turn to lower case after turning every xml to a character string
  
  extracted.modal.verb  <- xml.sentencecharacter %>%
    str_extract(VERB) %>% # getting modal verb followed by infinitive  
    tibble(.name_repair = ~ "strings") %>%
    mutate(name = number) %>%
    mutate(verb = str_extract(strings, '(?<=hw=")\\w+')) %>%
    select(verb) %>%
    drop_na(strings)
  
  write_csv(extracted.modal.verb, 
            here::here("allverbsinBNC.csv"),
            append = TRUE)
  
}


filelist <- fs::dir_ls(here::here("BNC"),
                       recurse = TRUE,
                       regexp = ".xml$")

length(filelist)

future_walk(filelist, collexeme.preparer, .progress = TRUE)
 
toc()