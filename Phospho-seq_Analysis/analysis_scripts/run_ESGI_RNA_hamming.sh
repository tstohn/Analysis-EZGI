
LOGFILE="Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/ESGI_RNA_LOG.txt"
rm -f $LOGFILE

#DEMULTIPLEX
echo "RUN DEMULTIPLEXING"
#/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
#              -i data/Phospho-seq/raw/SRR31955816_S1_L001_R1_001.fastq.gz \
#              -r data/Phospho-seq/raw/SRR31955816_S1_L001_R2_001.fastq.gz \
#              -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_RNA_HAMMING \
#              -p Phospho-seq_Analysis/background_data/RNA_pattern.txt \
#              -m Phospho-seq_Analysis/background_data/RNA_mismatches.txt \
#              -H 1 -t 20 -f 1 -q 1 2>> $LOGFILE

#STAR-ALIGN
echo "RUN STAR"
#in case we need to initialize the genome with custom overhang length - here 43
#cd data/GRCh38
#STAR --runThreadN 20 \
#     --runMode genomeGenerate \
#     --genomeDir GRCh38_STAR_index_phoshoseq \
#     --genomeFastaFiles GRCh38.primary_assembly.genome.fa \
#     --sjdbGTFfile gencode.v43.annotation.gtf \
#     --sjdbOverhang 43
#cd ../..

/usr/bin/time -v STAR --runThreadN 20 \
     --genomeDir data/GRCh38/GRCh38_STAR_index_phoshoseq \
     --readFilesIn ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA.fastq \
     --outFileNamePrefix ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA_ \
     --sjdbGTFfile /DATA/t.stohn/analyses_ezgi/data/GRCh38/gencode.v43.annotation.gtf \
     --sjdbOverhang 43 \
     --outSAMtype BAM Unsorted \
     --outSAMattributes NH HI AS nM GX GN \
     --quantMode TranscriptomeSAM \
     --outFilterMultimapNmax 50 \
     --outSAMmultNmax 1 --outSAMunmapped Within \
     --limitOutSJcollapsed 2000000 \
     --twopassMode Basic 2>> $LOGFILE

#ANNOTATE & COUNT
echo "RUN COUNTING"
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA.tsv -b ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA_Aligned.out.bam -f GX 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA_annotated.tsv \
               -o ./Phospho-seq_Analysis/output/ESGI_RNA_HAMMING/RNA_Counts_umi1.tsv -t 20 \
               -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
               -c 1 -x 3 -u 2 -m 1 -s 1 -H 1 2>> $LOGFILE
