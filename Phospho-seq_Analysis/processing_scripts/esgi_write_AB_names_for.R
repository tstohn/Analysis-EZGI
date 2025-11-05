# Define input and output file paths
input_file <- "Phospho-seq_Analysis/background_data/AB_NAMES_ALEVIN.tsv"
output_file <- "Phospho-seq_Analysis/background_data/ESGI_AB_NAMES.txt"

# Read the TSV file
data <- read.delim(input_file, header = FALSE, stringsAsFactors = FALSE)

# Extract the first column
first_column <- data[[1]]
joined <- paste(first_column, collapse = ",")

# Write each string followed by a comma on a new line
cat(joined, file = output_file)
