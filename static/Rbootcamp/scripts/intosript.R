library(tidyverse)
library(xml2)
library(furrr)
future::plan(multisession)
library(tictoc)
tic()

VERB <- "<w[^<]+pos=\"verb\"[^<]+</w>"
INTO <- "<w[^<]+pos=\"prep\">into </w>"
VERBGERUND <- "<w c5=\"v[bdhv]g\"[^<]+</w>"
INBETWEEN <- "<[^<]+<[^<]+" # this is one tag!
SPACE <- "[^<]"

search.expression <- glue::glue("{VERB}(\n  )?{INTO}")

search.expression

se <- glue::glue("{VERB}{SPACE}+({INBETWEEN})+{INTO}{SPACE}+{VERBGERUND}")
se


collexeme.preparer <- function(files) {

  number <- basename(files)
  
  #glue::glue('{number\n}')
  
  xmlread <- read_xml(files) # read in xml
  xmlsentence <- xml_find_all(xmlread, "//s") # find all sentences
  xml.sentencecharacter <- tolower(as.character(xmlsentence)) # turn to lower case after turning every xml to a character string
  
  extracted.modal.verb  <- xml.sentencecharacter %>%
    str_extract(se) %>% # getting modal verb followed by infinitive  
    tibble(.name_repair = ~ "strings") %>%
    mutate(name = number) %>%
    drop_na(strings)
  
  write_csv(extracted.modal.verb, 
            here::here("into.csv"),
            append = TRUE)
  
}


filelist <- fs::dir_ls(here::here("BNC"),
                       recurse = TRUE,
                       regexp = ".xml$")

cat(head(filelist))
length(filelist)

future_walk(filelist, collexeme.preparer, .progress = TRUE)
 

toc()