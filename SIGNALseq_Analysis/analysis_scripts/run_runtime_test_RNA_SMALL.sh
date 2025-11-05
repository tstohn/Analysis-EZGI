THREADS=(1 5 10)
REPEATS=5

#empty files
for THREAD in "${THREADS[@]}"; do
    LOG_ESGI_RNA="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ESGI_RNA_SMALL_${THREAD}_LOG.txt"
    LOG_ZUMI="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ZUMI_SMALL_${THREAD}_LOG.txt"
    rm -f $LOG_ESGI_RNA
    rm -f $LOG_ZUMI
done

echo "RUNNING RNA RUNTIME TESTS"
for ((i=1; i<=REPEATS; i++)); do
  echo "REPEAT: ${i}"
  for THREAD in "${THREADS[@]}"; do
    echo "THREADS: ${THREAD}"

    LOG_ESGI_RNA="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ESGI_RNA_SMALL_${THREAD}_LOG.txt"
    LOG_ZUMI="./SIGNALseq_Analysis/output/RUNTIME_TEST/LOG_FILES/ZUMI_SMALL_${THREAD}_LOG.txt"

    echo "RUN ESGI"
    #RUN ESGI RNA
    RESULTS_DIR="./SIGNALseq_Analysis/output/RUNTIME_TEST/ESGI_RNA"
    echo "RUN ESGI with ${THREAD} threads on repeat ${i}" >> $LOG_ESGI_RNA
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/demultiplex \
                  -i /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_1subset1M.fastq.gz \
                  -r /DATA/t.stohn/analyses_ezgi/data/SIGNALseq/raw/SRR28056729_2subset1M.fastq.gz \
                  -o ${RESULTS_DIR} \
                  -p SIGNALseq_Analysis/background_data/ESGI_files/pattern_RNA_noLinker.txt \
                  -m /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files/mismatches_RNA_1MM.txt \
                  -t $THREAD -f 1 -q 1 > /dev/null 2>> $LOG_ESGI_RNA
    /usr/bin/time -v STAR --runThreadN $THREAD \
        --genomeDir data/GRCh38/GRCh38_STAR_index \
        --readFilesIn ${RESULTS_DIR}/RNA.fastq \
        --outFileNamePrefix ${RESULTS_DIR}/RNA_ \
        --sjdbGTFfile data/GRCh38/gencode.v43.annotation.gtf \
        --sjdbOverhang 73 \
        --outSAMtype BAM Unsorted \
        --outSAMattributes NH HI AS nM GX GN \
        --quantMode TranscriptomeSAM \
        --outFilterMultimapNmax 50 \
        --outSAMmultNmax 1 --outSAMunmapped Within \
        --limitOutSJcollapsed 2000000 \
        --twopassMode Basic > /dev/null 2>> $LOG_ESGI_RNA
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/annotate -i ${RESULTS_DIR}/RNA.tsv \
                  -b ${RESULTS_DIR}/RNA_Aligned.out.bam \
                  -f GX > /dev/null 2>> $LOG_ESGI_RNA
    /usr/bin/time -v /DATA/t.stohn/SCDemultiplexing/bin/count -i ${RESULTS_DIR}/RNA_annotated.tsv \
                  -o ${RESULTS_DIR}/RNA_Counts.tsv -t $THREAD \
                  -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                  -c 1,3,5 -x 7 -u 6 -m 1 -s 1 \
                  -w SIGNALseq_Analysis/background_data/ESGI_files/bc_sharing_revComp.tsv > /dev/null 2>> $LOG_ESGI_RNA
    rm -r ${RESULTS_DIR}/*

    echo "RUN zUMI"
    #RUN zUMI
    #before: index STAR with the STAR version of zUMI environment
    #SIGNALseq_Analysis/zUMIs/zUMIs-env/bin/STAR --runThreadN 70 \
    # --runMode genomeGenerate \
    # --genomeDir GRCh38_STAR_index_zUMIenv \
    # --genomeFastaFiles GRCh38.primary_assembly.genome.fa \
    # --sjdbGTFfile gencode.v43.annotation.gtf \
    # --sjdbOverhang 73
    echo "RUN zUMI with ${THREAD} threads on repeat ${i}" >> $LOG_ZUMI
    /usr/bin/time -v /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/zUMIs/zUMIs.sh \
                  -c \
                  -y "/DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/zUMI_files/zUMI_params_SIGNALseq_${THREAD}threads_small.yaml" > /dev/null 2>> $LOG_ZUMI
    rm -r ./SIGNALseq_Analysis/output/RUNTIME_TEST/zUMI/*

  done
done
