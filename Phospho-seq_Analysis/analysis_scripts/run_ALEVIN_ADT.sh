REPEATS=5

LOGFILE_AB_ALEVIN="Phospho-seq_Analysis/output/ALEVIN_ADT/ALEVIN_ADT_LOG.txt"
rm $LOGFILE_AB_ALEVIN

for ((i=1; i<=REPEATS; i++)); do

  echo "REPEAT: ${i}"
  echo "RUN ALEVIN on repeat ${i}" >> $LOGFILE_AB_ALEVIN

  #index the feature barcodes for mapping
  /usr/bin/time -v  Phospho-seq_Analysis/salmon-latest_linux_x86_64/bin/salmon index \
    -t Phospho-seq_Analysis/background_data/ALEVIN_AB_NAME_TO_BARCODE.tsv \
    -i Phospho-seq_Analysis/background_data/AB_BARCODES_INDEX \
    --features -k7  2>> $LOGFILE_AB_ALEVIN

  #demultiplex the data
  /usr/bin/time -v  Phospho-seq_Analysis/salmon-latest_linux_x86_64/bin/salmon alevin -l ISR \
    -i  Phospho-seq_Analysis/background_data/AB_BARCODES_INDEX \
    -1 data/Phospho-seq/raw/SRR31955815_3.fastq \
    -2 data/Phospho-seq/raw/SRR31955815_2.fastq \
    --read-geometry 1[11-25] --umi-geometry 1[1-10,26-34] \
    --bc-geometry 2[1-16] \
    -o Phospho-seq_Analysis/output/ALEVIN_ADT \
    -p 10 --sketch  2>> $LOGFILE_AB_ALEVIN

  #count the data
  /usr/bin/time -v alevin-fry generate-permit-list -d either\
    -i Phospho-seq_Analysis/output/ALEVIN_ADT \
    -o Phospho-seq_Analysis/output/ALEVIN_ADT/quantification \
    --valid-bc Phospho-seq_Analysis/background_data/737K-arc-v1-revcomp.txt 2>> $LOGFILE_AB_ALEVIN

  /usr/bin/time -v alevin-fry collate -r Phospho-seq_Analysis/output/ALEVIN_ADT \
    -i Phospho-seq_Analysis/output/ALEVIN_ADT/quantification -t 10 2>> $LOGFILE_AB_ALEVIN

  /usr/bin/time -v alevin-fry quant -m Phospho-seq_Analysis/background_data/AB_NAMES_ALEVIN.tsv \
    -i Phospho-seq_Analysis/output/ALEVIN_ADT/quantification \
    -o Phospho-seq_Analysis/output/ALEVIN_ADT/quantification/crlike -r parsimony-em -t 10 --use-mtx 2>> $LOGFILE_AB_ALEVIN
done