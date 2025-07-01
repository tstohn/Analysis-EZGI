args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# Simple reverse complement function
rev_comp <- function(seq) 
{
  comp <- chartr("ACGTacgt", "TGCAtgca", seq)
  sapply(strsplit(comp, NULL), function(x) paste(rev(x), collapse = ""))
}

# Read input
data <- read.table(input_file, sep = "\t", stringsAsFactors = FALSE, header = FALSE)

# Compute reverse complements
rev1 <- rev_comp(data[[1]])
rev2 <- rev_comp(data[[2]])

# Add new columns
out <- data.frame(1, rev1, rev2)

# Write output
write.table(out, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)