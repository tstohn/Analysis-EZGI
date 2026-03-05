#LOGFILE_AB="Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/ESGI_ADT_LOG.txt"
#rm $LOGFILE_AB

# ADT
    #HAM
#/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
#                -i data/Phospho-seq/raw/SRR31955815_3.fastq \
#                -r data/Phospho-seq/raw/SRR31955815_2.fastq \
#                -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/ADT_HAM \
#                -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
#                -m Phospho-seq_Analysis/background_data/mismatches_1.txt \
#                -n ADT_HAM -d 1 \
#                -H 1\
#                -t 40 -f 1 -q 1 2>> $LOGFILE_AB
    # LEV
#/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
#                -i data/Phospho-seq/raw/SRR31955815_3.fastq \
#                -r data/Phospho-seq/raw/SRR31955815_2.fastq \
#                -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/ADT_LEV \
#                -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
#                -m Phospho-seq_Analysis/background_data/mismatches_1.txt \
#                -n ADT_LEV -d 1 \
#                -t 40 -f 1 -q 1 2>> $LOGFILE_AB

LOGFILE_RNA="Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/ESGI_ADT_LOG.txt"
rm $LOGFILE_RNA
# RNA
    # HAM
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i data/Phospho-seq/raw/SRR31955816_S1_L001_R1_001.fastq.gz \
              -r data/Phospho-seq/raw/SRR31955816_S1_L001_R2_001.fastq.gz \
              -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/RNA_HAM \
              -p Phospho-seq_Analysis/background_data/RNA_pattern.txt \
              -m Phospho-seq_Analysis/background_data/RNA_mismatches_1.txt \
              -H 1 -n RNA_HAM \
              -t 40 -f 1 -q 1 2>> $LOGFILE_RNA

    # LEV
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i data/Phospho-seq/raw/SRR31955816_S1_L001_R1_001.fastq.gz \
              -r data/Phospho-seq/raw/SRR31955816_S1_L001_R2_001.fastq.gz \
              -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ALL_HAM_LEV_COMPARISON/RNA_LEV \
              -p Phospho-seq_Analysis/background_data/RNA_pattern.txt \
              -m Phospho-seq_Analysis/background_data/RNA_mismatches_1.txt \
              -n RNA_LEV \
              -t 40 -f 1 -q 1 2>> $LOGFILE_RNA