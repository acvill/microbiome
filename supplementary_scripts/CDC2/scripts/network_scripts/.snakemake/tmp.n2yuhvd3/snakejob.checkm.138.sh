#!/bin/sh
# properties = {"type": "single", "rule": "checkm", "local": false, "input": ["/workdir/users/agk85/CDC2/networks/membership/B331-3_mge_count_membership.txt"], "output": ["/workdir/users/agk85/CDC2/networks/logs/B331-3_final_network_checkm_2_0", "/workdir/users/agk85/CDC2/networks/checkms/B331-3/B331-3.stats"], "wildcards": {"NAME": "B331-3"}, "params": {"n": "checkm_B331-3", "j": "16", "reference": "/workdir/users/agk85/CDC2/prodigal_excise/metagenomes/B331-3/B331-3_scaffold.fasta", "script": "/workdir/users/agk85/CDC2/scripts/network_scripts/split_clusters_hic.py", "fasta_folder": "/workdir/users/agk85/CDC2/networks/clusters/B331-3", "lineage": "/workdir/users/agk85/CDC2/networks/checkms/B331-3/lineage.ms", "checkm_folder": "/workdir/users/agk85/CDC2/networks/checkms/B331-3", "checkm_qa": "/workdir/users/agk85/CDC2/networks/checkms/B331-3/B331-3.qa", "name": "B331-3"}, "log": [], "threads": 1, "resources": {"mem_mb": 35}, "jobid": 138, "cluster": {}}
cd /local/workdir/users/agk85/CDC2/scripts/network_scripts && \
/usr/bin/python3.6 \
-m snakemake /workdir/users/agk85/CDC2/networks/logs/B331-3_final_network_checkm_2_0 --snakefile /workdir/users/agk85/CDC2/scripts/network_scripts/snake_trans_network \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.n2yuhvd3 /workdir/users/agk85/CDC2/networks/membership/B331-3_mge_count_membership.txt --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --allowed-rules checkm --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.n2yuhvd3/138.jobfinished" || (touch "/local/workdir/users/agk85/CDC2/scripts/network_scripts/.snakemake/tmp.n2yuhvd3/138.jobfailed"; exit 1)
