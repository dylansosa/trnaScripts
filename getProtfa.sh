for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i ; 
cut -f 1,2,3,5 longest.cds.order > longest.cds.bed

cut -f 4 longest.cds.bed | egrep -f - protein.faa -A1 --no-group-separator > $i.longest.cds.faa

cd .. ; done
