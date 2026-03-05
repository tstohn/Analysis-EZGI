
LOGFILE_AB="SIGNALseq_Analysis/output/ESGI_PROTEIN_WLINKER/ESGI_PROTEIN_WITH_LINKER_LOG.txt"
rm $LOGFILE

#RUN WITH MISMATCHES: PREFIX WLINKER
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_PROTEIN_WLINKER \
                -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN_with_linker.txt \
                -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM_WLINKER.txt \
                -n WLINKER \
                -t 10 -f 1 -q 1 2>> $LOGFILE_AB

#for comparison: RUN WITH 0MM: PREFIX ZEROMM
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_PROTEIN_WLINKER \
                -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN_with_linker.txt \
                -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_0MM.txt \
                -n ZEROMM \
                -t 10 -f 1 -q 1 2>> $LOGFILE_AB
