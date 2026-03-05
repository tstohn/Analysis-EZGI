
LOGFILE="SIGNALseq_Analysis/output/ESGI_RNA_TEST/ESGI_RNA_LOG.txt"
rm $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex -i  /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1subset1M.fastq.gz \
              -r  /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2subset1M.fastq.gz \
              -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ESGI_RNA_TEST \
              -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA_noLinker.txt \
              -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_2MM.txt \
              -t 70 -f 1 -q 1 2>> $LOGFILE
/usr/bin/time -v STAR --runThreadN 70 \
     --genomeDir data/GRCh38/GRCh38_STAR_index \
     --readFilesIn ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA.fastq \
     --outFileNamePrefix ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA_ \
     --sjdbGTFfile data/GRCh38/gencode.v43.annotation.gtf \
     --sjdbOverhang 73 \
     --outSAMtype BAM Unsorted \
     --outSAMattributes NH HI AS nM GX GN \
     --outFilterMultimapNmax 50 \
     --limitOutSJcollapsed 2000000 \
     --twopassMode Basic 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA.tsv -b ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA_Aligned.out.bam -f GX 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA_annotated.tsv \
               -o ./SIGNALseq_Analysis/output/ESGI_RNA_TEST/RNA_Counts_umi0.tsv -t 70 \
               -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
               -c 1,3,5 -x 7 -u 6 -m 1 -s 1 -H 1 \
               -w SIGNALseq_Analysis/background_data/ESGI_files/bc_sharing_revComp.tsv 2>> $LOGFILE
