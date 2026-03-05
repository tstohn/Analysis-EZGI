REPEATS=5

LOGFILE_AB="Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME/ESGI_ADT_LOG.txt"
rm $LOGFILE_AB

for ((i=1; i<=REPEATS; i++)); do

    echo "REPEAT: ${i}"

    echo "RUN ESGI_MM on repeat ${i}" >> $LOGFILE_AB
    #RUN WITH 1MM in SC-BARCODE and 1MM in AB-BARCODE: results have prefix A_
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                    -i data/Phospho-seq/raw/SRR31955815_3.fastq \
                    -r data/Phospho-seq/raw/SRR31955815_2.fastq \
                    -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME \
                    -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
                    -m Phospho-seq_Analysis/background_data/mismatches.txt \
                    -n PHOSPHO_MM -d 1 \
                    -t 10 -f 1 -q 1 2>> $LOGFILE_AB
    #COUNT SC-AB, 
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count \
                    -i ./Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME/PHOSPHO_MM_ADT.tsv \
                    -o ./Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME/PHOSPHO_ADT_Counts_MM.tsv \
                    -t 10 -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
                    -a Phospho-seq_Analysis/background_data/ESGI_AB_NAMES.txt \
                    -c 3 -x 1 -u 0,2 -m 0 -s 1 2>> $LOGFILE_AB

    echo "RUN ESGI_0MM on repeat ${i}" >> $LOGFILE_AB
    #RUN WITH 1MM in SC-BARCODE and 1MM in AB-BARCODE: results have prefix A_
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                    -i data/Phospho-seq/raw/SRR31955815_3.fastq \
                    -r data/Phospho-seq/raw/SRR31955815_2.fastq \
                    -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME \
                    -p Phospho-seq_Analysis/background_data/protein_pattern.txt \
                    -m Phospho-seq_Analysis/background_data/mismatches_0.txt \
                    -n PHOSPHO_0MM -d 1 \
                    -t 10 -f 1 -q 1 2>> $LOGFILE_AB
    #COUNT SC-AB, 
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count \
                    -i ./Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME/PHOSPHO_0MM_ADT.tsv \
                    -o ./Phospho-seq_Analysis/output/ESGI_ADT_RUNTIME/PHOSPHO_ADT_Counts_0MM.tsv \
                    -t 10 -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
                    -a Phospho-seq_Analysis/background_data/ESGI_AB_NAMES.txt \
                    -c 4 -x 2 -u 1,3 -m 0 -s 1 2>> $LOGFILE_AB
done