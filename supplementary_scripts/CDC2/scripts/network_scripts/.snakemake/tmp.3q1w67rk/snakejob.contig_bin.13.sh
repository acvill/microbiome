#!/bin/sh
# properties = {"type": "single", "rule": "contig_bin", "local": false, "input": ["/workdir/users/agk85/CDC2/networks/checkms/US8-3/US8-3.stats"], "output": ["/workdir/users/agk85/CDC2/logs/finals/US8-3_final_contig_bin", "/workdir/users/agk85/CDC2/bins/US8-3_contig_taxa_network_2_fgs"], "wildcards": {"NAME": "US8-3"}, "params": {"n": "contig_bin_US8-3", "script": "/workdir/users/agk85/CDC2/scripts/contig_vs_bin.py", "script2": "/workdir/users/agk85/CDC2/scripts/contig_histogram_prep.py", "j": "1", "HIC": "/workdir/users/agk85/CDC2/hicpro/output/US8-3_output/hic_results/data/US8-3/US8-3_trans_primary_0_ncol_withexcise_noeuks_normalize_2.txt", "OUT": "/workdir/users/agk85/CDC2/networks/clusters/US8-3", "BINS": "/workdir/users/agk85/CDC2/networks/clusters/US8-3/US8-3_network_scaffolds2bin.tsv", "COMBO_TABLE": "/workdir/users/agk85/CDC2/combo_tables/metagenomes/US8-3_master_scf_table.txt", "ARGS": "/workdir/users/agk85/CDC2/args/args_99_nr.fna.clstr.tbl", "KRAKEN_BINS": "/workdir/users/agk85/CDC2/networks/membership/US8-3_mge_count_membership.txt", "KRAKEN_CONTIGS": "/workdir/users/agk85/CDC2/kraken/US8-3/US8-3.kraken.taxonomy.txt", "CUTOFF": "2", "OUTFILE": "/workdir/users/agk85/CDC2/bins/US8-3_network_2_contigs_v_bins.txt"}, "log": [], "threads": 1, "resources": {"mem_mb": 200}, "jobid": 13, "cluster": {}}
cd /local/workdir/users/agk85/CDC2/scripts/network_scripts && \
/usr/bin/python3.6 \
-m snakemake /workdir/users/agk85/CDC2/logs/finals/US8-3_final_contig_bin --snakefile /workdir/users/agk85/CDC2/scripts/network_scripts/snake_network_hist \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.3q1w67rk /workdir/users/agk85/CDC2/networks/checkms/US8-3/US8-3.stats --latency-wait 5 \
 --attempt 2 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules contig_bin --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.3q1w67rk/13.jobfinished" || (touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.3q1w67rk/13.jobfailed"; exit 1)

