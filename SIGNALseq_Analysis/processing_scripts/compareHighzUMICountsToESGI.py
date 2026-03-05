import pysam
import pandas as pd
from Bio.Seq import Seq
from Levenshtein import distance as hamming_distance
import re, random

# === INPUT FILES ===
#the zUMI bam file output, contains true BX read barcode sequence as well as zUMI mapped seuqence BC
bam_path = "./SIGNALseq_Analysis/output/zUMI_june25/zUMI_SIGNALseq_June25.filtered.Aligned.GeneTagged.UBcorrected.sorted.bam"
#barcodes mapped by ESGI
barcode_path = "./SIGNALseq_Analysis/output/ezgi_june25/RNA.tsv"
convert_path = "./SIGNALseq_Analysis/background_data/formatForEzgi_files/split_seqv2_rt_bc_sharing.tsv"
barcodeszUMI = ["AGAGTCAAACGCTCGAAATTTCTC", "GAATCTGATGAAGAGAAATTTCTC", "CAGCGTTACGCTGATCAGGCGGCA", "AGATGTACCCAGTTCAATCCGCGA",
            "CCATCCTCTTCACGCAATCGCATA", "TTCACGCAAGATCGCAATCGCATA", "TAGGATGAAACGCTTAATCGCATA", "CACCTTACTCTTCACAATTCATGG",
            "TATCAGCACGGATTGCATTCATGG", "GGTGCGAAACAGCAGAATTCATGG", "CATACCAAGTACGCAAATTCATGG", "GAACAGGCCATACCAAATTCATGG",
            "CAAGACTATGGAACAAATTCATGG", "TGAAGAGAAGATCGCAATTCATGG", "GTACGCAATATCAGCAATTCATGG", "CAACCACAGTCTGTCAATTCATGG",
            "CTGAGCCAAAGACGGAATTCATGG", "ACCACTGTTCCGTCTAATTCATGG", "ACTATGCAGAGTTAGCCATTTGGA", "TATCAGCAGTCGTAGACATTTGGA"]

# === Read barcode file ===
ESGI_result = pd.read_csv(barcode_path, sep="\t")
ESGI_result.columns = ESGI_result.columns.str.strip()

# === Read conversion table ===
convert_df = pd.read_csv(convert_path, sep="\t")
conversion_dict = dict(zip(convert_df["BARCODE"], convert_df["VALUE"]))

# === Function to reverse complement DNA string ===
def reverse_complement(seq):
    return str(Seq(seq).reverse_complement())

# === use random subset of BAM file for runtime reasons ==
print("creating BAM subset")
bamfile  = pysam.AlignmentFile(bam_path,  "rb")
subset = []
k = 1000000
total_reads = bamfile.count()  # fast C‐level count
#compute sampling probability
p = k / total_reads
#one‐pass sampling
for read in bamfile.fetch(until_eof=True):
    if random.random() < p:
        subset.append(read)

# === Store results ===
results = []

count = 0
#iterate through BAM and check if we have a BC of interest
for read in subset:
    tags = dict(read.get_tags())
    
    #small status update
    count = count + 1
    if(count%100 == 0):
        print(f"\rProcessed {count} lines", end="", flush=True)

    if tags.get("BC") in barcodeszUMI:

        # Extract relevant tags
        read_name = read.query_name
        bc = tags.get("BC", None)
        bx = tags.get("BX", None)

        #get the ESGI barcode
        # Match in ESGI_result: find rows where read0name contains read_name
        escaped_read_name = re.escape(read_name)
        pattern = fr".*{escaped_read_name}$"
        matching_rows = ESGI_result[ESGI_result['READNAME'].str.match(pattern, na=False)]
        
        if matching_rows.shape[0] == 1:
            rowESGI = matching_rows.iloc[0]
            barcode_seq = reverse_complement(rowESGI['BC2.txt.1']) + \
                reverse_complement(rowESGI['BC2.txt']) + \
                conversion_dict.get(reverse_complement(rowESGI['BC1.txt']), reverse_complement(rowESGI['BC1.txt']))      
            resultTmp = {
                "read_name": read_name,
                "BC_zUMI": bc,
                "BX": bx,
                "BC_ESGI": barcode_seq,
                "Hamming_to_ZUMI": hamming_distance(bc, bx),
                "Hamming_to_ESGI": hamming_distance(barcode_seq, bx),
            }
        elif matching_rows.shape[0] == 0:
            resultTmp = {
                "read_name": read_name,
                "BC_zUMI": bc,
                "BX": bx,
                "BC_ESGI": "NOT_FOUND",
                "Hamming_to_ZUMI": hamming_distance(bc, bx),
                "Hamming_to_ESGI": pd.NA,
            }
        else:
            raise ValueError(f"Too many matches: {matching_rows.shape[0]}")

        results.append(resultTmp)

# === Save results ===
results_df = pd.DataFrame(results)
results_df.to_csv("barcode_matching_results.tsv", sep="\t", index=False)
print("Done. Results saved to barcode_matching_results.tsv")