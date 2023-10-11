for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i ; 
bedtools getfasta -fi GCF*_genomic.fna -bed *.highConfidence.bed -fo $i.highConfidence.fna -name
cd .. ; done
