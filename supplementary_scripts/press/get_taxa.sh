folder='press'
cd ~/agk/${folder}/combo_tables/metagenomes

for file in *_master_scf_table.txt; do echo $file; base=$(echo $file | cut -d'-' -f1); cat ${base}*_master_scf_table.txt | cut -f37| grep 'k__' | sort | uniq >> ${base}.taxa.each.txt; done
for file in *.taxa.each.txt; do echo $file; base=$(echo $file | cut -d'.' -f1); sort $file| uniq > ${base}.taxa.txt; done
cat *.taxa.txt | sort | uniq > all.taxa.txt

for file in *.taxa.txt;
do
	echo $file;
	sed -i -e "s/'/;/g" $file;
	sed -i -e "s/\-/;/g" $file;
	sed -i -e "s/\//;/g" $file;
	sed -i -e "s/\ /;/g" $file;
done

cp *.taxa.txt ~/agk/${folder}/arg_v_org/metagenomes/cliques/



