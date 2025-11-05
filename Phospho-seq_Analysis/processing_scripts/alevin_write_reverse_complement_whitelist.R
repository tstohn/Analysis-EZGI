# Function to get reverse complement of a DNA sequence
reverse_complement <- function(seq) 
{
  # Complement bases
  comp_bases <- chartr("ACGTacgt", "TGCAtgca", seq)
  # Reverse the complemented sequence
  return(paste0(rev(strsplit(comp_bases, NULL)[[1]]), collapse = ""))
}

# File paths
input_file <- "Phospho-seq_Analysis/background_data/737K-arc-v1.txt"
output_file <- "Phospho-seq_Analysis/background_data/737K-arc-v1-revcomp.txt"

# Read the whitelist (assuming one barcode per line)
barcodes <- readLines(input_file)

# Compute reverse complement for each barcode
revcomp_barcodes <- sapply(barcodes, reverse_complement)

# Write output file
writeLines(revcomp_barcodes, con = output_file)

cat("Reverse complemented barcodes saved to:", output_file, "\n")