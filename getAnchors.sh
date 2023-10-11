for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i

rm -r anchors
mkdir anchors 
cd anchors
egrep -A2 -B2 -wf <(cut -f 5 ../trna.order -d '	') ../trna_protein_coding_combined.csv | csplit -f trna --suffix-format='%03d.anchors' - '/--/' '{*}'
# make individual files per trna and two neighbors 
sed -i s'/--//g' trna*
sed -i '/^$/d' trna*
# remove the delimiter
for i in $(ls | sed s'/.anchors//') ; do mkdir $i && mv $i.anchors $i ; done
# move output to individual directories for downstream alignment
cd ..
# return outside of anchors/
cd .. ; done 
