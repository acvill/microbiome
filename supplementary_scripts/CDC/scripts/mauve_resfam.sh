for file in /workdir/users/agk85/CDC/resfams/metagenomes/patients/clusters/*.fna
do
infile=$(echo $file | cut -d'.' -f1)
IFS='_' read -a cluster <<<"$infile"
temp=${cluster[0]}
IFS='/' read -a patient <<<"$temp"
clusternum=${patient[9]}"_cluster_"${cluster[2]}
echo $clusternum
LOG=/workdir/users/agk85/CDC/resfams/log/mauve_log.out
/programs/mauve_2.4.0/linux-x64/progressiveMauve --output=/workdir/users/agk85/CDC/resfams/metagenomes/mauve/${clusternum} $file >> $LOG 2>&1
done
