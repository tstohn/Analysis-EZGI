LOGFILE_AB="Phospho-seq_Analysis/output/ESGI_ADT/ESGI_ADT_LOG.txt"
rm $LOGFILE_AB

echo "RUN DEMULTIPLEX"
#RUN WITH 1MM in SC-BARCODE and 1MM in AB-BARCODE: results have prefix A_
#/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
#                -i data/Phospho-seq/raw/SRR31955815_3.fastq \
#                -r data/Phospho-seq/raw/SRR31955815_2.fastq \
#                -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ADT \
#                -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
#                -m Phospho-seq_Analysis/background_data/mismatches_1.txt \
#                -n PHOSPHO_1MM -d 1 \
#                -t 30 -f 1 -q 1 2>> $LOGFILE_AB

#RUN ALSO WITH 3MM in AB barcode and see if we map mroe reads
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                -i data/Phospho-seq/raw/SRR31955815_3.fastq \
                -r data/Phospho-seq/raw/SRR31955815_2.fastq \
                -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ADT \
                -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
                -m Phospho-seq_Analysis/background_data/mismatches.txt \
                -n PHOSPHO_AB3MM_BC1MM -d 1 \
                -t 30 -f 1 -q 1 2>> $LOGFILE_AB

#COUNT SC-AB, 
echo "RUN COUNT"
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./Phospho-seq_Analysis/output/ESGI_ADT/PHOSPHO_1MM_ADT.tsv \
                -o ./Phospho-seq_Analysis/output/ESGI_ADT/PHOSPHO_ADT_Counts_MM.tsv \
                -t 30 -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
                -a Phospho-seq_Analysis/background_data/ESGI_AB_NAMES.txt \
                -c 4 -x 2 -u 1,3 -m 1 -H 1 -s 1 2>> $LOGFILE_AB
