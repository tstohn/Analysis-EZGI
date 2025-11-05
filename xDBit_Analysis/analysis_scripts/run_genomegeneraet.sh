STAR \
  --runThreadN 50 \
  --runMode genomeGenerate \
  --genomeDir ./data/GRCm38/GRCm38_STAR_index \
  --genomeFastaFiles ./data/GRCm38/GRCm38.primary_assembly.genome.fa \
  --sjdbGTFfile ./data/GRCm38/gencode.vM25.annotation.gtf \
  --sjdbOverhang 100