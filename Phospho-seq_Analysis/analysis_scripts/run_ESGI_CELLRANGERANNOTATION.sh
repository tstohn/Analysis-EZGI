
LOGFILE="./Phospho-seq_Analysis/output/ESGI_RNA_CELLRANGERANNOTATED/ESGI_RNA_CR_ANNOT_LOG.txt"
rm -f $LOGFILE

#DEMULTIPLEX
echo "RUN DEMULTIPLEXING"
#WE USE THE DEMULTI)PLEXING RESULT OF run_ESGI_RNA_hamming
#then rename the readname and compare finally to the cellranger BAM file of starsolo

#STAR-ALIGN
echo "RUN STAR"
#we use the cellranger annotation

#ANNOTATE & COUNT
#BUT we do run our own counting
echo "RUN COUNTING"
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ./Phospho-seq_Analysis/output/ESGI_RNA_CELLRANGERANNOTATED/RNA_renamed.tsv -b ./Phospho-seq_Analysis/output/ESGI_RNA_CELLRANGERANNOTATED/possorted_genome_bam_xf_filtered.bam -f GX 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ./Phospho-seq_Analysis/output/ESGI_RNA_CELLRANGERANNOTATED/RNA_renamed_annotated.tsv \
               -o ./Phospho-seq_Analysis/output/ESGI_RNA_CELLRANGERANNOTATED/RNA_Counts_CELLRANGERANNOTATED_umi1_hamming.tsv -t 20 \
               -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
               -c 1 -x 3 -u 2 -m 1 -s 1 -H 1 2>> $LOGFILE
