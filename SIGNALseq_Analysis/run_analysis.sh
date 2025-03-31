
#run PHP script to map barcodes, align with star, map barcodes back and create sc-gene matrix


##############################
# TEMPORARY
##############################
#RNA-seq data analysis
#run ezgi on the SIGNALseq RNA data
/DATA/t.stohn/SCDemultiplexing/bin/ezgi -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1.fastq -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2.fastq -o /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/output/ezgi -p /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/pattern_RNA.txt -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/formatForEzgi_files/mismatches_RNA.txt -t 70 -f 1

#run STAR
STAR --runThreadN 70 \
     --genomeDir data/GRCh38/GRCh38_STAR_index \
     --readFilesIn ./SIGNALseq_Analysis/output/ezgi/RNA.fastq \
     --outFileNamePrefix ./SIGNALseq_Analysis/output/ezgi/RNA_ \
     --outFilterMultimapNmax 1 \
     --sjdbGTFfile data/GRCh38/gencode.v43.annotation.gtf
#2.) then annotate SAM with those locations
#sort and make bam or make sam bam wo sorting directly
samtools view -bS ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.sam | samtools sort -o ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.bam
#bedtools writes two lines for every gene annotation in ./data/GRCh38/genes.bed, one for the transcript and one for the gene (jsut to keep in mind for subsequent tool calls)
bedtools intersect -wa -wb -bed -abam ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned.out.bam -b ./data/GRCh38/genesFiltered.bed > ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned_annotated.bed

#run BarcodeBedAnnotator: the result bed file from STAR has 12 columns + 4 of the annotation bed file (15th is then the gene after concatenation)
/DATA/t.stohn/SCDemultiplexing/bin/barcodeBedAnn -i ./SIGNALseq_Analysis/output/ezgi/RNA.tsv -b ./SIGNALseq_Analysis/output/ezgi/RNA_Aligned_annotated.bed -f 15


#run zUMI on the RNA seq data



#PROTEIN data analysis
#run ezgi

#run kite
