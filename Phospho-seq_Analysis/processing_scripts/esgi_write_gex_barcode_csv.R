# Define input and output file paths
input_file <- "Phospho-seq_Analysis/background_data/gex_737K-arc-v1.txt"
output_file <- "Phospho-seq_Analysis/background_data/esgi_gex_737K-arc-v1.txt"

# Read the file (one barcode per line)
barcodes <- readLines(input_file)
# Write them as a single line, comma-separated
write(paste(barcodes, collapse = ","), file = output_file)