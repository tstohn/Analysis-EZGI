# count barcode occurences in RNA data for ESGI in the demultiplexed output file

library(tidyverse)
library(tidyverse)
library(Matrix)
library(dplyr)
library(Biostrings)
library(ggplot2)
library(data.table)

ESGI_RAW <- read_tsv("/DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA/RNA.tsv")
ESGI_RAW$scID <- paste0(ESGI_RAW$`BC1.txt`, ESGI_RAW$`BC2.txt...4`, ESGI_RAW$`BC2.txt...6`)
ESGI_RAW$BC1 <- ESGI_RAW$BC1.txt
ESGI_RAW$BC2 <- ESGI_RAW$BC2.txt...4
ESGI_RAW$BC3 <- ESGI_RAW$BC2.txt...6
ESGI_RAW <- ESGI_RAW %>%
  mutate(BC1 = as.character(reverseComplement(DNAStringSet(BC1)))) %>%
  mutate(BC2 = as.character(reverseComplement(DNAStringSet(BC2)))) %>%
  mutate(BC3 = as.character(reverseComplement(DNAStringSet(BC3))))
#assign the merge-barcodes
convert_df <- read_tsv("/DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/split_seqv2_rt_bc_sharing.tsv")
ESGI_RAW <- ESGI_RAW %>%
  left_join(convert_df, by = c("BC1" = "BARCODE"))
ESGI_RAW <- ESGI_RAW %>%
  mutate(
    BC1_FIXED = if_else(
      is.na(VALUE),
      BC1,       # keep original if no mapping
      VALUE     # replace if mapping exists
    )
  ) 
ESGI_RAW$scID <- paste0(ESGI_RAW$BC3, ESGI_RAW$BC2, ESGI_RAW$BC1_FIXED)

ESGI <- ESGI_RAW %>%
  group_by(scID) %>%
  mutate(n = n()) %>%
  dplyr::select(n, scID) %>%
  unique()

# Save the tibble as an RDS file
saveRDS(ESGI, "/DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA/ESGI_BARCODES.rds")