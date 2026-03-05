THREAD=10
REPEATS=5

#empty files
LOG_ESGI_PROT="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/LOG_FILES/ESGI_PROT_HAMLEV_${THREAD}_LOG.txt"
LOG_KITE="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/LOG_FILES/KITE_HAMLEV_${THREAD}_LOG.txt"
rm -f $LOG_ESGI_PROT
rm -f $LOG_KITE

echo "RUNNING PROTEIN RUNTIME TESTS"
# Loop over each thread count
for ((i=1; i<=REPEATS; i++)); do
  echo "REPEAT: ${i}"

  LOG_ESGI_PROT="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/LOG_FILES/ESGI_PROT_${THREAD}_LOG.txt"

  echo "RUN HAMMING"
  echo "RUN ESGI with HAMMINGDIST on repeat ${i}" >> $LOG_ESGI_PROT
  RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/ESGI_PROT"
  /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                  -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                  -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                  -o ${RESULTS_DIR} \
                  -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN.txt \
                  -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM.txt \
                  -n RUNTIME \
                  -t $THREAD -f 1 -q 1 > /dev/null 2>> $LOG_ESGI_PROT
  rm -r ${RESULTS_DIR}/*

  echo "RUN LEVENSHTEIN"
  echo "RUN ESGI with LEVENSHTEINDIST on repeat ${i}" >> $LOG_ESGI_PROT
  RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/ESGI_PROT"
  /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                  -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                  -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                  -o ${RESULTS_DIR} \
                  -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN.txt \
                  -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM.txt \
                  -n RUNTIME \
                  -H 1 \
                  -t $THREAD -f 1 -q 1 > /dev/null 2>> $LOG_ESGI_PROT
  rm -r ${RESULTS_DIR}/*

  echo "RUN LEVENSHTEIN WITH QGRAMS"
  echo "RUN ESGI with LEVENSHTEINDIST_PLUS_QGRAMS on repeat ${i}" >> $LOG_ESGI_PROT
  RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST_HAMLEV/ESGI_PROT"
  /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                  -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_1.fastq \
                  -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056728_2.fastq \
                  -o ${RESULTS_DIR} \
                  -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/pattern_PROTEIN.txt \
                  -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_PROTEIN_1MM.txt \
                  -n RUNTIME \
                  -l 0 \
                  -t $THREAD -f 1 -q 1 > /dev/null 2>> $LOG_ESGI_PROT
  rm -r ${RESULTS_DIR}/*
done