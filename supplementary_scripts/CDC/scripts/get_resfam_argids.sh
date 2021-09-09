for file in /workdir/users/agk85/CDC/resfams/metagenomes/*/*_resfams.txt;
do
IFS="_" read NAME var2 <<< "$file"
cut -d',' -f3 $file  > ${NAME}_resfam_argids.txt
done

