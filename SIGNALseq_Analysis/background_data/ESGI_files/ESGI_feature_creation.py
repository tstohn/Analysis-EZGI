#rename features (taken from csv file of SIGNALseq),
#so that they are the same as in KITE

input_file = "SIGNALseq_Analysis/background_data/formatForEzgi_files/antibody_names.txt"
output_file = "SIGNALseq_Analysis/background_data/formatForEzgi_files/antibody_names_as_in_KITE.txt"

# Read the single line from the input file
with open(input_file, "r") as f:
    line = f.readline().strip()

# Split into list, clean each entry
cleaned = [
    s.strip().replace(" ", "_").replace("(", "").replace(")", "")
    for s in line.split(",")
]

# Join the cleaned list into a single comma-separated line
output_line = ",".join(cleaned)

# Write to output file
with open(output_file, "w") as f:
    f.write(output_line + "\n")