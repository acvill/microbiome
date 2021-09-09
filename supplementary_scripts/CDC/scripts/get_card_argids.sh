for file in /workdir/users/agk85/CDC/card/metagenomes/*/*_drug_specific_card_hits.txt;
do
IFS="_" read NAME var2 var3 var4 var5 <<< "$file"
cut -f1 $file  > ${NAME}_drug_card_argids.txt
done

