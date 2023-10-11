for i in $(ls -D | egrep br) ; do makeblastdb -in $i/*longest.cds.faa -dbtype prot -out $i/protdb/$i.protdb ; done 
# protdb

for i in $(ls -D | egrep br) ; do makeblastdb -in $i/*.highConfidence.fna  -dbtype nucl -out $i/trnadb/$i.trnadb ; done
