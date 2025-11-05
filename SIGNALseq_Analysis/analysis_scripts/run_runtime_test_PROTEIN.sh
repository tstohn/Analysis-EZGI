THREADS=(10 30 50 70)
REPEATS=5

#empty files
for THREAD in "${THREADS[@]}"; do
    LOG_ESGI_PROT="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ESGI_PROT_${THREAD}_LOG.txt"
    LOG_KITE="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/KITE_${THREAD}_LOG.txt"
    rm -f $LOG_ESGI_PROT
    rm -f $LOG_KITE
done

echo "RUNNING PROTEIN RUNTIME TESTS"
# Loop over each thread count
for ((i=1; i<=REPEATS; i++)); do
  echo "REPEAT: ${i}"
  for THREAD in "${THREADS[@]}"; do
    echo "THREADS: ${THREAD}"

    LOG_ESGI_PROT="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ESGI_PROT_${THREAD}_LOG.txt"
    LOG_KITE="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/KITE_${THREAD}_LOG.txt"

    echo "RUN ESGI"
    #RUN ESGI PROTEIN
    echo "RUN ESGI with ${THREAD} threads on repeat ${i}" >> $LOG_ESGI_PROT
    #RUN WITH 1MM in SC-BARCODE and 1MM in AB-BARCODE: results have prefix A_
    RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST/ESGI_PROT"
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                    -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                    -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                    -o ${RESULTS_DIR} \
                    -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN.txt \
                    -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM.txt \
                    -n RUNTIME \
                    -t $THREAD -f 1 -q 1 > /dev/null 2>> $LOG_ESGI_PROT
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count \
                    -i ${RESULTS_DIR}/RUNTIME_PROTEIN.tsv \
                    -o ${RESULTS_DIR}/RUNTIME_PROTEIN_Counts.tsv \
                    -t $THREAD -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                    -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                    -c 1,3,5 -x 0 -u 6 -m 0 -s 1 > /dev/null 2>> $LOG_ESGI_PROT
    rm -r ${RESULTS_DIR}/*

    echo "RUN KITE"
    #RUN KITE
    echo "RUN KITE with ${THREAD} threads on repeat ${i}" >> $LOG_KITE
    RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST/KITE"
    /usr/bin/time -v kb ref -i $RESULTS_DIR/mismatch.idx \
        -f1 $RESULTS_DIR/mismatch.fa \
        -g $RESULTS_DIR/t2g.txt \
        --workflow kite "./SIGNALseq_Analysis/background_data/kite_files/features.tsv" \
        --overwrite > /dev/null 2>> $LOG_KITE
    # create count matrix
    /usr/bin/time -v kb count --h5ad \
              -i $RESULTS_DIR/mismatch.idx \
              -o $RESULTS_DIR/ \
              -w SIGNALseq_Analysis/background_data/kite_files/split_seqv2_barcode_wlist.txt \
              -g $RESULTS_DIR/t2g.txt \
              -x 1,10,18,1,48,56,1,78,86:1,0,10:0,0,0 \
              --workflow kite \
              -t 70 \
              -m 4G\
              --overwrite \
              --tmp SIGNALseq_Analysis/output/RUNTIME_TEST/tmp \
              /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
              /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq > /dev/null 2>> $LOG_KITE
    rm -r $RESULTS_DIR/*
  done
done