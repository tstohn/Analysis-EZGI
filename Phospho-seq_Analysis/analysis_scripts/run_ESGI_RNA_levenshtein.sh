
LOGFILE="Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/ESGI_RNA_LOG.txt"
rm -f $LOGFILE

#DEMULTIPLEX
echo "RUN DEMULTIPLEXING"
#/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
#              -i data/Phospho-seq/raw/RNA/SRR31955816_S1_L001_R1_001.fastq.gz \
#              -r data/Phospho-seq/raw/RNA/SRR31955816_S1_L001_R2_001.fastq.gz \
#              -o /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN \
#              -p Phospho-seq_Analysis/background_data/RNA_pattern.txt \
#              -m Phospho-seq_Analysis/background_data/RNA_mismatches_1.txt \
#              -H 0 -t 40 -f 1 -q 1 2>> $LOGFILE

#STAR-ALIGN
echo "RUN STAR"
#in case we need to initialize the genome with custom overhang length - here 43
#cd data/GRCh38

# this is how we d build the genome with cellranger files but cellranger already has a build genome 
#zcat data/GRCh38/cellranger/GRCh38/genes/genes.gtf.gz > data/GRCh38/cellranger/GRCh38/genes/genes.gtf
#STAR --runThreadN 20 \
#   --runMode genomeGenerate \
#   --genomeDir  data/GRCh38/GRCh38_STAR_index_phoshoseq_fromCellrangerFiles \
#   --genomeFastaFiles data/GRCh38/cellranger/GRCh38/fasta/genome.fa \
#   --genomeSAindexNbases 14 \
 #  --genomeChrBinNbits 18 \
#   --genomeSAsparseD 3 \
#   --limitGenomeGenerateRAM 17179869184 \
#    --sjdbGTFfile data/GRCh38/cellranger/GRCh38/genes/genes.gtf

# before ran with      --sjdbGTFfile /DATA/t.stohn/analyses_ezgi/data/GRCh38/gencode.v43.annotation.gtf \
# and sjdbOverhang 43
#now just recreate the genome with cellranger files and for STAR2.7.10b to annotate also GX tags
#/usr/bin/time -v STAR --runThreadN 40 \
#     --genomeDir data/GRCh38/GRCh38_STAR_index_phoshoseq_fromCellrangerFiles \
#     --readFilesIn ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA.fastq \
#     --outFileNamePrefix ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA_ \
#     --outSAMtype BAM Unsorted \
#     --outSAMattributes NH HI AS nM GX GN \
#     --quantMode TranscriptomeSAM \
#     --limitOutSJcollapsed 2000000 \
#     --twopassMode Basic 2>> $LOGFILE

#ANNOTATE & COUNT
echo "RUN COUNTING"
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA.tsv -b ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA_Aligned.out.bam -f GX 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA_annotated.tsv \
               -o ./Phospho-seq_Analysis/output/ESGI_RNA_LEVENSHTEIN/RNA_Counts_umi1.tsv -t 40 \
               -d /DATA/t.stohn/analyses_ezgi/Phospho-seq_Analysis/background_data \
               -c 1 -x 3 -u 2 -m 1 -s 1 -H 1 2>> $LOGFILE
