#!/bin/sh
# properties = {"type": "single", "rule": "checkm", "local": false, "input": ["/workdir/users/agk85/CDC2/networks/membership/B335-3_5_mge_count_membership.txt"], "output": ["/workdir/users/agk85/CDC2/networks/logs/B335-3_final_network_checkm_5_0", "/workdir/users/agk85/CDC2/networks/checkms_5/B335-3/B335-3.stats"], "wildcards": {"NAME": "B335-3"}, "params": {"n": "checkm_B335-3", "j": "8", "reference": "/workdir/users/agk85/CDC2/prodigal_excise/metagenomes/B335-3/B335-3_scaffold.fasta", "script": "/workdir/users/agk85/CDC2/scripts/network_scripts/split_clusters_hic.py", "fasta_folder": "/workdir/users/agk85/CDC2/networks/clusters_5/B335-3", "lineage": "/workdir/users/agk85/CDC2/networks/checkms_5/B335-3/lineage.ms", "checkm_folder": "/workdir/users/agk85/CDC2/networks/checkms_5/B335-3", "checkm_qa": "/workdir/users/agk85/CDC2/networks/checkms_5/B335-3/B335-3.qa", "name": "B335-3"}, "log": [], "threads": 1, "resources": {"mem_mb": 40}, "jobid": 152, "cluster": {}}
cd /local/workdir/users/agk85/CDC2/scripts/network_scripts && \
/usr/bin/python3.6 \
-m snakemake /workdir/users/agk85/CDC2/networks/logs/B335-3_final_network_checkm_5_0 --snakefile /workdir/users/agk85/CDC2/scripts/network_scripts/snake_trans_network \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.kgee9stk /workdir/users/agk85/CDC2/networks/membership/B335-3_5_mge_count_membership.txt --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules checkm --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.kgee9stk/152.jobfinished" || (touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.kgee9stk/152.jobfailed"; exit 1)

