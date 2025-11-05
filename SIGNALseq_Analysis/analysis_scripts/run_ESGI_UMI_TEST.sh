/DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/UMI_TEST/COLLAPSE_ALL.tsv \
                -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 1,3,5 -x 0 -u 6 -m 1 -s 1
/DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/UMI_TEST/COLLAPSE_BELOW_TEN_PERC.tsv \
                -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 1,3,5 -x 0 -u 6 -m 1 -s 1  -v 0.1
/DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/UMI_TEST/COLLAPSE_BELOW_TWENTY_PERC.tsv \
                -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 1,3,5 -x 0 -u 6 -m 1 -s 1  -v 0.25
/DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/UMI_TEST/COLLAPSE_BELOW_FIFTY_PERC.tsv \
                -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 1,3,5 -x 0 -u 6 -m 1 -s 1 -v 0.5
/DATA/t.stohn/SCDemultiplexing/bin/count \
                -i ./SIGNALseq_Analysis/output/ESGI_Protein/A_PROTEIN.tsv \
                -o ./SIGNALseq_Analysis/output/UMI_TEST/NO_COLLAPSE.tsv \
                -t 70 -d /DATA/t.stohn/analyses_ezgi/SIGNALseq_Analysis/background_data/ESGI_files \
                -a SIGNALseq_Analysis/background_data/ESGI_files/antibody_names_as_in_KITE.txt \
                -c 1,3,5 -x 0 -u 6 -m 0 -s 1
