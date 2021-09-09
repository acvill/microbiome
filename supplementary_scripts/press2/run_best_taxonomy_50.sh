
mkdir ~/agk/press2/das/ProxiMeta-1/kraken/finished

for file in ~/agk/press2/das/ProxiMeta-1/kraken/*report.txt ;
do 
echo $file;
outfile=${file}.besttaxid;
python /workdir/users/agk85/press2/scripts/best_taxonomy_50.py -i $file -o $outfile
#mv $file ~/agk/press2/das/ProxiMeta-1/kraken/finished
#mv $outfile ~/agk/press2/das/ProxiMeta-1/kraken/finished
#mv ${outfile}.krakentaxa ~/agk/press2/das/ProxiMeta-1/kraken/finished

done


