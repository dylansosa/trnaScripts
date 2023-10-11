for f in ./*/GCF*_genomic.fna ; do
d=$(echo $f | cut -f 1,2 -d '/')
echo $d
cd $d
gff=$(echo $f | cut -f 3 -d '/')
echo $gff
#tRNAscan-SE -E -d -o -b $gff.trnascan.bed $gff.trnascan.gff $gff 
tRNAscan-SE -E -d -o $gff.trnascan -a $gff.trnascan.fa -b $gff.trnascan.bed -f $gff.trnascan.struct -j $gff.trnascan.gff $gff 
cd .. ; done

