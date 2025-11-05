# FOR THE PHOSPHO-SEQ DATA WE COPIED THE ADT-BARCODES FROM THE SUPPLEMENTARY FILE CONTAINING ALL BARCODES
# THRE BARCODES ARE JUST A LIST IN THE EXCEL FILE, WITH THIS SCRIPT WE WRITE IT TO A COMMA SEPERATED LIST
# SAME FOR THE 10X-WHITELIST, WE USE THIS SCRIPT TO WRITE THE BARCODES INTO A COMMA SEPERATED LIST


# Load Biostrings package
if (!requireNamespace("Biostrings", quietly = TRUE)) {
  install.packages("BiocManager")
  BiocManager::install("Biostrings")
}
library(Biostrings)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("Usage: Rscript gunzip_file.R <input.gz> <output>")
}
input_file <- args[1]
output_file <- args[2]

# Read the barcodes
barcodes <- readLines(input_file)

# Convert to DNAStringSet
dna <- DNAStringSet(barcodes)

# Compute reverse complement
revcomp <- as.character(reverseComplement(dna))

# Collapse into comma-separated string
output <- paste(revcomp, collapse = ",")

# Write to a new file
writeLines(output, output_file)
