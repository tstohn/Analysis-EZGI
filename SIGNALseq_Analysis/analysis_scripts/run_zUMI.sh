LOGFILE="SIGNALseq_Analysis/output/zUMI/zUMI_LOG.txt"
rm $LOGFILE

#RUN ZUMIS ANALYSIS WITH THE SAME REFERENCE (we used GENCODE REFERENCE)
/usr/bin/time -v /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/zUMIs/zUMIs.sh \
              -c -y /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/zUMI_files/zUMI_params_SIGNALseq.yaml 2>> $LOGFILE
