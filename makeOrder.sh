for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i
# excluding melanogaster as it has a differnt ID pattern so I did it separately:
# cat genomic.gff | egrep '      gene    ' | egrep gene_biotype=protein_coding | sed s'/\(ID=gene-Dmel_CG[0-9]*\).*/\1/' | sed s'/ID=gene-Dmel_//g' |cut -f 1,4,5,7,9 | awk 'BEGIN{FS=OFS="   "}{print $0 "   coding"}' > protein_coding.order
# ignore above comments

# cat genomic.gff | egrep '	gene	' | egrep gene_biotype=protein_coding | sed s'/\(Name=.*;gb\).*/\1/' | sed s'/ID=gene-.*;Name//g' | sed s'/=//g ; s/;gb//g ; s/;.*//g' | cut -f 1,4,5,7,9 | awk 'BEGIN{FS=OFS="	"}{print $0 "	coding"}' > protein_coding.order 
# get protein coding gene cooridinates 
# older version that only gets CG. This was problematic when using protein.faa

# cat genomic.gff | egrep '	gene	' | egrep gene_biotype=protein_coding | egrep 'Name=[A-Z]*[a-z]*[0-9]*;' | sed s'/ID=.*Name=// ; s/;.*//' | cut -f 1,4,5,7,9 | awk 'BEGIN{FS=OFS="	"}{print $0 "	coding"}' > protein_coding.order
# this is now unviversal for all spp and gets names as well as CG numbers so I can extract from protein.faa

#cat genomic.gff | egrep '	CDS	'| egrep 'Name=[A-Z]P.*\.[0-9].*gene=[A-Z]*[a-z]*[0-9]*;' | sed s'/ID=.*Name=// ; s/;gbkey=CDS;/ / ; s/gene=// ; s/;l.*// ;s/;Not.*	/	/ ;s/;.*//' | cut -f 1,4,5,7,9,10 | awk '{$7=$3-$2; print $0}' | sort -k6,6 -k7rn | awk '!a[$6]++' | sed s'/ /	/' | sort -k1,1 -k2,2n -k3,3n | awk '{print $1,$2,$3,$4,$5,$6}' | sed s'/ /	/g' > longest.cds.order
#cat genomic.gff | egrep '	CDS	'| egrep 'Name=[A-Z]P.*\.[0-9].*gene=[A-Z]*[a-z]*[0-9]*;' | sed s'/ID=.*Name=// ; s/;gbkey=CDS;/ / ; s/gene=// ; s/;l.*// ;s/;Not.*	/	/ ;s/;.*//' | cut -f 1,4,5,7,9,10 | awk '{$7=$3-$2; print $0}' | sort -k6,6 -k7rn | awk '!a[$6]++' | sed s'/ /	/' | sort -k1,1 -k2,2n -k3,3n | awk '{print $1,$2,$3,$4,$5,$6}' | sed s'/ /	/g' > longest.cds.order

cat genomic.gff | egrep '	CDS	'| egrep 'Name=[A-Z]P.*\.[0-9].*gene=[A-Z]*[a-z]*[0-9]*;' | sed s'/ID=.*Name=// ; s/;gbkey=CDS;/	/ ; s/gene=// ; s/;l.*// ;s/;Not.*	/	/ ; s/;.*//' | cut -f 1,4,5,7,9,10 | awk '{$7=$3-$2; print $0}' | sort -k6,6 -k7rn | awk '!a[$6]++' | sort -k1,1 -k2,2n -k3,3n | awk '{print $1,$2,$3,$4,$5,$6,"	coding",NR}' | sed s'/ /	/g' > longest.cds.order

cat *.highConfidence.bed | awk 'BEGIN{FS=OFS="	"}{print $1,$2,$3,$6,$4 "	tRNA"}' > trna.order
# get high confidence trna coordinates 

cat longest.cds.order trna.order | sort -k1,1 -k2,2n -k3,3n  > trna_protein_coding_combined.csv
# sort and combine for downstream analysis
cd .. ; done 
