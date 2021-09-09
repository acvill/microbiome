for file in /workdir/users/agk85/CDC/card/metagenomes/*/*_card_strict.txt;
do
IFS="_" read NAME var2 var3 <<< "$file"
cut -f1 $file  > ${NAME}_card_strict_argids.txt
done

