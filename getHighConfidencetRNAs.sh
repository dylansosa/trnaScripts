for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i
# find assembly directories 
cat $i*_genomic.fna.trnascan.gff | egrep 'pseudo|Undet' | cut -f 5 > $i.pseudogeneCoordinates
# get pseudo trna or undetermined trna coordinates for lookup
egrep -wvf $i.pseudogeneCoordinates $i*trnascan.bed > $i.highConfidence.bed 
# remove them from bed and output final trna bed
cd .. ; done
