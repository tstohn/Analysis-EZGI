
LOGFILE_AB="SIGNALseq_Analysis/output/ESGI_RNA_HAMLEV_COMPARISON/ESGI_PROTEIN_LOG.txt"
rm $LOGFILE

#HAMMING
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz \
                -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz \
                -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA_HAMLEV_COMPARISON \
                -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA_noLinker.txt \
                -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_1MM.txt \
                -n HAMMING -H 1 \
                -t 10 -f 1 -q 1 2>> $LOGFILE_AB

#LEVENSHTEIN
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex\
                -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz \
                -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz \
                -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA_HAMLEV_COMPARISON \
                -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA_noLinker.txt \
                -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_1MM.txt \
                -n LEVENSHTEIN \
                -t 50 -f 1 -q 1 2>> $LOGFILE_AB
