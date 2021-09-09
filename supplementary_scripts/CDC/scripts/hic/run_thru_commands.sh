
#this is running through org_v_org stuff to modify something in the annotation of things in the amphora combo_table section

bash run_master_scf_table.sh
bash run_master_scf_table_binary.sh
python hic/hic_org_v_org.py /workdir/users/agk85/CDC 0
python hic/hic_org_v_org.py /workdir/users/agk85/CDC 50
python hic/hic_org_v_org.py /workdir/users/agk85/CDC 90

#then go to the folder on computer /Users/agk/Box\ Sync/Labwork-CDC/hic/org_v_org
scp agk85@cbsubrito2.tc.cornell.edu:~/agk/CDC/newhic/plotting/CDC_org_v_org* .


