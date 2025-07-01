
#run PHP script to map barcodes, align with star, map barcodes back and create sc-gene matrix
##############################
# TEMPORARY
##############################
#RNA-seq data analysis
#run ezgi on the SIGNALseq RNA data
#/DATA/t.stohn/SCDemultiplexing/bin/demultiplex -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ezgi -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/pattern_RNA_test.txt -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/mismatches_RNA_withError.txt -t 70 -f 1 -q 1

#RUNS ONLY FOR THIS ANALYSIS;
#run with UMI-pattern for constant regions to cut them out
# /DATA/t.stohn/SCDemultiplexing/bin/ezgi -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1.fastq -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2.fastq -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ezgi -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/pattern_RNA_test.txt -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/mismatches_RNA.txt -t 70 -f 1
# RUN THE TEST FASTQs
# /DATA/t.stohn/SCDemultiplexing/bin/ezgi -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/test/test1.fastq -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/test/test2.fastq -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ezgi -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/pattern_RNA_test.txt -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/mismatches_RNA.txt -t 70 -f 1

#run STAR

#STAR --runThreadN 70 \
#     --genomeDir data/GRCh38/GRCh38_STAR_index \
#     --readFilesIn ./TEST_SIGNALseq/output/ezgi/RNA.fastq \
#     --outFileNamePrefix ./TEST_SIGNALseq/output/ezgi/RNA_ \
#     --sjdbGTFfile data/GRCh38/gencode.v43.annotation.gtf \
#     --sjdbOverhang 73 \
#     --outFilterMultimapNmax 50 \
#     --outSAMmultNmax 1 --outSAMunmapped Within \
#     --outSAMtype SAM \
#      --quantMode TranscriptomeSAM

#2.) then annotate SAM with those locations
#sort and make bam or make sam bam wo sorting directly
#samtools view -bS ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.sam | samtools sort -o ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.bam
#we supply a very simple file to bedtools that contains one additional fourth annotation (make your own file if you need e.g., gene ids) e.g., genesFiltered.bed
#awk '{match($0, /gene_id "([^"]+)"/, arr); print $1"\t"$2"\t"$3"\t"arr[1];}' genes.bed > genes_simple.bed
#bedtools intersect -wa -wb -bed -abam ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.bam -b ./data/GRCh38/genes_simple.bed > ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned_annotated.bed
#run BarcodeBedAnnotator: the result bed file from STAR has 12 columns + 4 of the annotation bed file (15th is then the gene after concatenation)
#/DATA/t.stohn/SCDemultiplexing/bin/barcodeBedAnn -i ./SIGNALseq_Analysis/output/ezgi/RNA.tsv -b ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned_annotated.bed -f 15
#CONTINUE HERE TOMORROW, ALSO CHANGE THE 22X, 30X and keep first line in awk command
#remove all UNMAPPED reads (except first line TODO)
#awk -F'\t' 'NR==1 ||$8 != "UNMAPPED"' ./SIGNALseq_Analysis/output/ezgi/RNA_annotated.tsv > ./SIGNALseq_Analysis/output/ezgi/RNA_annotated_mapped.tsv
#gzip -f ./SIGNALseq_Analysis/output/ezgi/RNA_annotated_mapped.tsv
#Run counting of features
#NO UMI CORRECTION
#/DATA/t.stohn/SCDemultiplexing/bin/count -i ./SIGNALseq_Analysis/output/ezgi/RNA_annotated_mapped.tsv.gz -o ./SIGNALseq_Analysis/output/ezgi/RNA_Counts_umi0.tsv -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files -c 1,3,5 -x 7 -u 6 -m 0 -s 1



LOGFILE="SIGNALseq_Analysis_LOG.txt"
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1Processed.fastq.gz -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2Processed.fastq.gz -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ezgi_june25 -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/pattern_RNA_test.txt -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/mismatches_RNA_1MM.txt -t 70 -f 1 -q 1 2>> $LOGFILE
/usr/bin/time -v STAR --runThreadN 70 \
     --genomeDir data/GRCh38/GRCh38_STAR_index \
     --readFilesIn ./SIGNALseq_Analysis/output/ezgi_june25/RNA.fastq \
     --outFileNamePrefix ./SIGNALseq_Analysis/output/ezgi_june25/RNA_ \
     --sjdbGTFfile data/GRCh38/gencode.v43.annotation.gtf \
     --sjdbOverhang 73 \
     --outSAMtype BAM Unsorted \
     --outSAMattributes NH HI AS nM GX GN \
     --quantMode TranscriptomeSAM \
     --outFilterMultimapNmax 50 \
     --outSAMmultNmax 1 --outSAMunmapped Within \
     --limitOutSJcollapsed 2000000 \
     --twopassMode Basic 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ./SIGNALseq_Analysis/output/ezgi_june25/RNA.tsv -b ./SIGNALseq_Analysis/output/ezgi_june25/RNA_Aligned.out.bam -f GX 2>> $LOGFILE
/usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ./SIGNALseq_Analysis/output/ezgi_june25/RNA_annotated.tsv -o ./SIGNALseq_Analysis/output/ezgi_june25/RNA_Counts_umi0.tsv -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files -c 1,3,5 -x 7 -u 6 -m 1 -s 1 -w SIGNALseq_Analysis/background_data/formatForEzgi_files/bc_sharing_revComp.txt 2>> $LOGFILE

#RUN ZUMIS ANALYSIS WITH THE SAME REFERENCE (we used GENCODE REFERENCE)
/usr/bin/time -v /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/zUMIs/zUMIs.sh -y /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/zUMI_files/zUMI_params_SIGNALseq.yaml 2>> $LOGFILE
