
LOGFILE_AB="SIGNALseq_Analysis/output/ESGI_Protein/ESGI_PROTEIN_LOG.txt"
rm $LOGFILE

#RUN WITH 1MM in SC-BARCODE and 1MM in AB-BARCODE: results have prefix A_
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_Protein \
                -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN.txt \
                -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM.txt \
                -n A \
                -t 10 -f 1 -q 1 2>> $LOGFILE_AB
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN_Counts.tsv \
                -t 10 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 2,4,6 -x 1 -u 7 -m 0 -s 1 2>> $LOGFILE_AB
