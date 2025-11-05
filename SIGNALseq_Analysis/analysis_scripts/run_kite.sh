KITELOGFILE="./SIGNALseq_Analysis/output/KITE/KITE_LOG.txt"
RESULTS_DIR="./SIGNALseq_Analysis/output/KITE"
DATA_DIR="./data/SIGNALseq/raw"

#Generate the Kallisto index (per default 1MM hamming dist per barcode)
/usr/bin/time -v kb ref -i $RESULTS_DIR/mismatch.idx \
         -f1 $RESULTS_DIR/mismatch.fa \
         -g $RESULTS_DIR/t2g.txt \
         --workflow kite "./SIGNALseq_Analysis/background_data/kite_files/features.tsv" \
         --overwrite 2>> $KITELOGFILE
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
           --keep-tmp --overwrite \
           $DATA_DIR/SRR28056728_1.fastq \
           $DATA_DIR/SRR28056728_2.fastq 2>> $KITELOGFILE