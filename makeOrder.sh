for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i
cat genomic.gff | egrep '	CDS	'| egrep 'Name=[A-Z]P.*\.[0-9].*gene=[A-Z]*[a-z]*[0-9]*;' | sed s'/ID=.*Name=// ; s/;gbkey=CDS;/	/ ; s/gene=// ; s/;l.*// ;s/;Not.*	/	/ ; s/;.*//' | cut -f 1,4,5,7,9,10 | awk '{$7=$3-$2; print $0}' | sort -k6,6 -k7rn | awk '!a[$6]++' | sort -k1,1 -k2,2n -k3,3n | awk '{print $1,$2,$3,$4,$5,$6,"	coding",NR}' | sed s'/ /	/g' > longest.cds.order

cat *.highConfidence.bed | awk 'BEGIN{FS=OFS="	"}{print $1,$2,$3,$6,$4 "	tRNA"}' > trna.order
# get high confidence trna coordinates 

cat longest.cds.order trna.order | sort -k1,1 -k2,2n -k3,3n  > trna_protein_coding_combined.csv
# sort and combine for downstream analysis
cd .. ; done 
