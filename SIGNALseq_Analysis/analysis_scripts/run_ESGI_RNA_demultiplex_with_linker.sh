
LOGFILE="SIGNALseq_Analysis/output/ESGI_RNA_WLINKER/ESGI_RNA_LOG.txt"
rm $LOGFILE

/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz \
              -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz \
              -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA_WLINKER \
              -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA.txt \
              -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_1MM_WLINKER_10.txt \
              -n WLINKER_10 \
              -t 70 -f 1 -q 1 2>> $LOGFILE

/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz \
              -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz \
              -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA_WLINKER \
              -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA.txt \
              -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_1MM_WLINKER.txt \
              -n WLINKER \
              -t 70 -f 1 -q 1 2>> $LOGFILE