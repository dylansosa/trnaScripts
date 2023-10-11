bedtools getfasta -fi ../../../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna -bed trna_ages.bed -fo trna.fa -name

cat trna.fa | egrep 'br[1-8]' -A1 --no-group-separator > trna.sophophora.fa 

cat trna.sophophora.fa | egrep '>' | cut -f 1 -d ':' | sed s'/>//g' | egrep  -f - trna_ages.bed > trna.sophophora.bed

bedtools slop -i trna_ages.bed -g ../../../chromsize -b 1000 > trna_ages.1kb.bed

bedtools slop -i trna.sophophora.bed -g ../../../chromsize -b 1000 > trna.sophophora.1kb.bed                                           

bedtools getfasta -fi ../../../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna -bed trna_ages.1kb.bed -fo trna_ages.1kb.fa -name

bedtools getfasta -fi ../../../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna -bed trna.sophophora.1kb.bed -fo trna.sophophora.1kb.fa -name

makeblastdb -dbtype nucl -in trna_ages.1kb.fa -out blastOut/db

blastn -task blastn-short -db db -query ../trna.sophophora.1kb.fa -outfmt 7 -out trna.sophpora.short.blastn7.tsv
# for extra evidence if it is unclear what the reciprocal alignment is between genes

blastn -db db -query ../trna.sophophora.1kb.fa -outfmt 7 -out trna.sophpora.blastn7.tsv
# primary alignment evidence

cat /home/sosa/thesis/3_tRNA_evolution/NEW_DROSOPHILID_24_DATA/ncbi_dataset/data/br8_Dmel/GCF_000001215.4.highConfidence.intron.bed | cut -f 4 | egrep -f - trna_ages.bed > trna_ages.intron.bed
# collecting intron containing genes

cat blastOut/putativeOrphans.txt  | egrep br | cut -f 1 | cut -f 1 -d ':' | egrep -f - trna_ages.bed  > trna_ages.orphans.be
# collecting genes that did not align to any other trna genes; e.g. putative orphans

cat duplicateRelationship.tsv | sed s'/NT_037436.4/3L/g ; s/NT_033777.3/3R/g; s/NT_033778.4/2R/g ; s/NT_033779.5/2L/g ; s/NC_004354.4/X/g ; s/NC_004353.4/4/g ; s/NC_024512.1/Y/g' > duplicateRelationship.chr.tsv
# manually made second column for orphans == '-'

cat duplicateRelationship.chr.tsv | sed '1,2d' | cut -f 1,2 | awk -F '[.]' '{print $1,$2}' | cut -f 1,2 | awk -F '[_]' '{print $2,$3}' | sed s'/ /	/g' | cut -f 1,4 | awk '$1!~/X/ && $2!~/X/{print "auto","<- auto"};$1~/X/ && $2!~/X/ {print "X","<- auto"};$1~/X/ && $2~/X/{print "X", "<- X"}; $1!~/X/ && $2 ~/X/ {print "auto", "<- X"}; $1!~/X/ && !$2 {print "orphan"}' |sort -k1,1 -k2,2|uniq -c > movementResults.txt

cat duplicateRelationship.chr.tsv | sed '1,2d' | cut -f 1 | cut -f 1 -d '.' | cut -f 2 -d '_' | sort | uniq -c  > chr.distrbution.txt
