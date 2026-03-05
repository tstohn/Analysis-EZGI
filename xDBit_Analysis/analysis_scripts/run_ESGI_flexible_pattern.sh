LOGFILE="xDBit_Analysis/output/ESGI_LOG.txt"
if [ -e  $LOGFILE ]; then
  rm -rf  $LOGFILE
fi

/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
              -i /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_1.fastq \
              -r /DATA/t.stohn/analyses_ezgi/data/xDBiT/raw/SRR20073555_2.fastq \
              -o /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/output \
              -p /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/pattern_strict.tsv \
              -m /DATA/t.stohn/analyses_ezgi/xDBit_Analysis/background_data/mismatches_1.tsv \
              -n flexiblePattern -t 40 -f 1 -q 1 -d 1 2>> $LOGFILE

#RUN STAR
/usr/bin/time -v STAR --runThreadN 50 \
     --genomeDir data/GRCm38/GRCm38_STAR_index \
     --readFilesIn xDBit_Analysis/output/flexiblePattern_xDBiT.fastq \
     --outFileNamePrefix xDBit_Analysis/output/RNA_ \
     --outSAMtype BAM Unsorted \
     --outSAMattributes NH HI AS nM GX GN \
     --quantMode TranscriptomeSAM \
     --outFilterMultimapNmax 50 \
     --outSAMmultNmax 1 --outSAMunmapped Within \
     --limitOutSJcollapsed 2000000 \
     --twopassMode Basic 2>> $LOGFILE

#RUN ANNOTATE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i xDBit_Analysis/output/flexiblePattern_xDBiT.tsv -b xDBit_Analysis/output/RNA_Aligned.out.bam -f GN 2>> $LOGFILE

#RUN COUNTING
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i xDBit_Analysis/output/flexiblePattern_xDBiT_annotated.tsv \
               -o xDBit_Analysis/output/RNA_Counts_v10_h1.tsv -t 50 \
               -d xDBit_Analysis/background_data \
               -c 2,4 -x 7 -u 1 -m 1 -v 0.2 -H 1 \
               -y 2 4 -g xDBit_Analysis/background_data/xAnnotation.txt xDBit_Analysis/background_data/yAnnotation.txt  2>> $LOGFILE

