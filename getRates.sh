for i in NT_* ; do join  -1 1 -2 1 -a 1 -a 2 -e NA -o 1.1,2.2 <(sort -k1,1 ../../../../br_spp.txt) <(sort -k1,1 $i) | sed s'/br/br /' | sort -k2,2g | sed s'/br /br/' > $i.coverage ; done

for i in *.coverage ; do 

birthBranch=$(cat $i | egrep -m1 -vw NA | cut -f 1 -d '_')
geneName=$(echo $i | cut -f 1-3 -d'.' )
denominator=$(sed '0,/NT_/d' $i | egrep -v "$birthBranch" | wc -l)

sed '0,/NT_/d' $i | egrep -v "$birthBranch" | egrep -w NA  | wc -l | awk -v num="$denominator" -v name="$geneName" '{print ""name" loss rate = "$1/num}' > $i.lossRate ; done
# find first instance of gene birth. Get that branch number and remove all remaining rows with that branch. Count species with NA after origination event. Divide number of species that lost the gene by remaining number of species after removing branch with origination event. This is the loss rate after the origination event. This is dividing the number of species that lost a gene after the origination event divided by the number of species that diverged after the gene origination event. e.g. if a gene originated at branch 1, remove all branch 1 and older rows. Then count NA in remaining rows. Divide the number of NA by total remaining rows. 

cat *lossRate > total.lossRate

join -1 2 -2 1 <(cut -f 1 -d':' ../trna_ages_branches.tsv | sed s'/_N/ N/g' | sort -k2,2) <(sort -k1,1 total.lossRate) | awk '{print $2"_"$1,$3}' > dmel.trna.lossRate
