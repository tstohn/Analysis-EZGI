import pysam
import pandas as pd
from Bio.Seq import Seq
from Levenshtein import distance as hamming_distance
import re

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
            "CTGAGCCAAAGACGGAATTCATGG", "ACCACTGTTCCGTCTAATTCATGG", "ACTATGCAGAGTTAGCCATTTGGA", "TATCAGCAGTCGTAGACATTTGGA",
            "CCATCCTCATGCCTAACATTTGGA", "ACAGATTCTAGGATGACGTCTAGG", "CTGGCATAATTGGCTCCGTTCGAG", "TCCGTCTACCAGTTCACGTTCGAG",
            "CTAAGGTCAGCAGGAACGTTCGAG", "AGGCTAACAGATGTACCGTTCGAG", "CAAGACTATGAAGAGACGTTCGAG", "CTCAATGACCATCCTCCGTTCGAG",
            "TGGAACAACGAACTTACGTTCGAG", "GCCACATAATTGGCTCCGTTCGAG", "GGTGCGAAACAGCAGACTATTTCA", "GCTCGGTAATCATTCCCTATTTCA",
            "ATCATTCCAAGACGGACTATTTCA", "ACTATGCAGAGTTAGCGACCTTTC", "TGGAACAAAAGGACACGCCTGCAA", "CATACCAAGTACGCAAGCCTGCAA",
            "AGCAGGAAACACGACCGCCTGCAA", "AACAACCAAACTCACCGCCTGCAA", "AATGTTGCGAGTTAGCGCCTGCAA", "CTGGCATAATTGGCTCGCCTGCAA",
            "GAGCTGAACACTTCGAGCCTGCAA", "GACTAGTACACCTTACGCCTGCAA", "CTGTAGCCAACGTGATGGGATCGG", "GACTAGTATTCACGCAGGGATCGG",
            "AAGGTACATCTTCACAGGGATCGG", "TAGGATGAGGAGAACAGGGATCGG", "GTGTTCTAAAGGTACAGGGATCGG", "CCTCTATCAACCGAGAGGTGGAGC",
            "AGTGGTCAATTGGCTCGTCGCGCG", "TCTTCACATGGCTTCAGTGCTAGC", "CAAGGAGCACAGATTCGTGCTAGC", "TGGAACAAGCGAGTAATACTCGAA",
            "AACCGAGAACAGATTCTCTATTAC", "GTCGTAGAAGTACAAGTCTATTAC", "ACTATGCAATGCCTAATCTATTAC", "AAACATCGACCTCCAATCTATTAC",
            "AGAGTCAACAGATCTGTCTATTAC", "CAACCACACAGCGTTATGCTTGGG", "ATCATTCCAAGGACACTGCTTGGG", "ACAGCAGACACCTTACTGCTTGGG",
            "TTCACGCACAGCGTTATGGCGCGC", "AACCGAGACCAGTTCATGGTATAC", "CACCTTACGATGAATCTGGTATAC", "TCTTCACATGGCTTCATGGTATAC",
            "GCTAACGAATCCTGTATGGTATAC", "TAGGATGACGCTGATCTGGTATAC", "AATGTTGCGAGTTAGCTGGTATAC", "GGAGAACAGTCGTAGATGGTATAC",
            "CCTCTATCCGCTGATCTGGTATAC", "AGTGGTCAGCCAAGACTGGTATAC", "CATACCAACTGTAGCCTGGTATAC", "AAGACGGAAGATGTACTGGTATAC",
            "CTCAATGACCATCCTCTGGTATAC", "CCTCTATCAACCGAGATGTCTGAA", "GTGTTCTAATTGAGGATGTCTGAA", "AGCCATGCGTACGCAATGTCTGAA",
            "GACAGTGCACACGACCTGTCTGAA", "AGTGGTCACGAACTTATGTCTGAA", "ACCTCCAATGGAACAATGTCTGAA", "CCGACAACGAATCTGATGTCTGAA",
            "GTGTTCTAACAGATTCTGTCTGAA", "AGCACCTCTCTTCACATGTCTGAA", "AACTCACCTAGGATGATGTCTGAA", "TTCACGCAACAGATTCTGTCTGAA",
            "TCTTCACAAGATCGCATGTCTGAA", "ACCTCCAACAGCGTTATTACCTCG", "CACCTTACAAGACGGATTACCTCG", "GAACAGGCACGTATCATTACCTCG",
            "GACTAGTACCGACAACTTACCTCG", "ACGTATCACCAGTTCATTCCGATC", "ACATTGGCCGCTGATCTTCCGATC", "CAGATCTGGTACGCAATTCGCTAC",
            "TGAAGAGATATCAGCATTCGCTAC", "ACAGCAGATGGCTTCATTGGGAGA"]

# === Read barcode file ===
ESGI_result = pd.read_csv(barcode_path, sep="\t")
ESGI_result.columns = ESGI_result.columns.str.strip()

# === Read conversion table ===
convert_df = pd.read_csv(convert_path, sep="\t")
conversion_dict = dict(zip(convert_df["BARCODE"], convert_df["VALUE"]))

# === Function to reverse complement DNA string ===
def reverse_complement(seq):
    return str(Seq(seq).reverse_complement())

# === Store results ===
results = []

with pysam.AlignmentFile(bam_path, "rb") as bamfile:
    
        count = 0
        #iterate through BAM and check if we have a BC of interest
        for read in bamfile:
            tags = dict(read.get_tags())
            
            #small status update
            count = count + 1
            if(count%1000 == 0):
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
                assert len(matching_rows) == 1, f"Expected one element, got {len(matching_rows)}"
                rowESGI = matching_rows.iloc[0]

                barcode_seq = reverse_complement(rowESGI['BC2.txt.1']) + \
                                reverse_complement(rowESGI['BC2.txt']) + \
                                conversion_dict.get(reverse_complement(rowESGI['BC1.txt']), reverse_complement(rowESGI['BC1.txt']))
                                
                resultTmp = {
                    "read_name": read_name,
                    "BC_zUMI": bc,
                    "BX": bx,
                    "BC_ESGI": barcode_seq,
                    "Hamming_to_ESGI": hamming_distance(bc, bx),
                    "Hamming_to_zUMI": hamming_distance(barcode_seq, bx),
                }
                results.append(resultTmp)

# === Save results ===
results_df = pd.DataFrame(results)
results_df.to_csv("barcode_matching_results.tsv", sep="\t", index=False)
print("Done. Results saved to barcode_matching_results.tsv")