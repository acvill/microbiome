
mkdir ~/agk/press2/das/ProxiMeta-1/kraken/finished

for file in ~/agk/press2/das/ProxiMeta-1/kraken/*report.txt ;
do 
echo $file;
outfile=${file}.besttaxid;
mv $file ~/agk/press2/das/ProxiMeta-1/kraken/finished
mv $outfile ~/agk/press2/das/ProxiMeta-1/kraken/finished
mv ${outfile}.krakentaxa ~/agk/press2/das/ProxiMeta-1/kraken/finished
sleep 1s
done


