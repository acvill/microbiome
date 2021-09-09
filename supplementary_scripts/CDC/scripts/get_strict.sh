#!/usr/bash/

for i in /workdir/users/agk85/CDC/card/metagenomes/*/*_card.txt; 
do
WRK=/workdir/users/agk85/CDC/card/metagenomes 
NAME=$(echo $i | cut -d'/' -f8); 
echo $NAME; 
grep 'Strict' $i > ${WRK}/${NAME}/${NAME}_card_strict.txt
done

