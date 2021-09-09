#!/bin/sh
# properties = {"type": "single", "rule": "checkm", "local": false, "input": ["/workdir/users/agk85/CDC2/networks/membership/US8-4_mge_count_membership.txt"], "output": ["/workdir/users/agk85/CDC2/networks/logs/US8-4_final_network_checkm_2_0", "/workdir/users/agk85/CDC2/networks/checkms/US8-4/US8-4.stats"], "wildcards": {"NAME": "US8-4"}, "params": {"n": "checkm_US8-4", "j": "8", "reference": "/workdir/users/agk85/CDC2/prodigal_excise/metagenomes/US8-4/US8-4_scaffold.fasta", "script": "/workdir/users/agk85/CDC2/scripts/network_scripts/split_clusters_hic.py", "fasta_folder": "/workdir/users/agk85/CDC2/networks/clusters/US8-4", "lineage": "/workdir/users/agk85/CDC2/networks/checkms/US8-4/lineage.ms", "checkm_folder": "/workdir/users/agk85/CDC2/networks/checkms/US8-4", "checkm_qa": "/workdir/users/agk85/CDC2/networks/checkms/US8-4/US8-4.qa", "name": "US8-4"}, "log": [], "threads": 1, "resources": {"mem_mb": 35}, "jobid": 163, "cluster": {}}
cd /local/workdir/users/agk85/CDC2/scripts/network_scripts && \
/usr/bin/python3.6 \
-m snakemake /workdir/users/agk85/CDC2/networks/logs/US8-4_final_network_checkm_2_0 --snakefile /workdir/users/agk85/CDC2/scripts/network_scripts/snake_trans_network \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.5zy7c1g2 /workdir/users/agk85/CDC2/networks/membership/US8-4_mge_count_membership.txt --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules checkm --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.5zy7c1g2/163.jobfinished" || (touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.5zy7c1g2/163.jobfailed"; exit 1)

