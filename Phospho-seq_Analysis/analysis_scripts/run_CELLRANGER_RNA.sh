LOGFILE_CELLRANGER="Phospho-seq_Analysis/output/CELLRANGER_RNA/CELLRANGER_LOG.txt"
rm -rf  "Phospho-seq_Analysis/output/CELLRANGER_RNA"
mkdir "Phospho-seq_Analysis/output/CELLRANGER_RNA"

/usr/bin/time -v ./cellranger-9.0.1/bin/cellranger count \
  --include-introns=false \
  --id=CELLRANGER \
  --transcriptome=./data/GRCh38/cellranger/GRCh38 \
  --chemistry=ARC-v1 \
  --fastqs=./data/Phospho-seq/raw/RNA \
  --sample=SRR31955816 \
  --create-bam=true \
  --nosecondary \
  --localmem 120 \
  --localcores 20 \
  --output-dir Phospho-seq_Analysis/output/CELLRANGER_RNA/CELLRANGER_DIR 2>> $LOGFILE_CELLRANGER