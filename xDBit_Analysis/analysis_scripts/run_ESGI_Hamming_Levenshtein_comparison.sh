LOGFILE="xDBit_Analysis/output/ESGI_LOG.txt"
if [ -e  $LOGFILE ]; then
  rm -rf  $LOGFILE
fi

#HAMMING
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_1.fastq \
              -r /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_2.fastq \
              -o /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/output/hamming \
              -p /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/pattern_flexible.tsv \
              -m /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/mismatches_1.tsv \
              -H 1 \
              -n hamming -t 20 -f 1 -q 1 -d 1 2>> $LOGFILE

# LEVENSHTEIN
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_1.fastq \
              -r /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_2.fastq \
              -o /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/output/levenshtein \
              -p /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/pattern_flexible.tsv \
              -m /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/mismatches_1.tsv \
              -n levenshtein -t 20 -f 1 -q 1 -d 1 2>> $LOGFILE

# LEVENSHTEIN + CONSTANT LINKERS
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_1.fastq \
              -r /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_2.fastq \
              -o /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/output/levenshteinLinker \
              -p /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/pattern_strict.tsv \
              -m /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/mismatchesWithLinker.tsv \
              -n levenshteinPlusLinker -t 20 -f 1 -q 1 -d 1 2>> $LOGFILE