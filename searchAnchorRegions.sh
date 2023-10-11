for h in $(ls -D ./* | egrep ':' | sed s'/://g ; s/\.\///') ; do
cd $h
for i in $(ls br*.blastp) ; do

declare -i anchor_num=4
# number of anchor protein orthologs expected 

name=$(echo $i | cut -f 1 -d '.')
gcf=$(ls ../../../$name/ | egrep GCF.*_genomic.fna$)

cut -f 2 $i |\
 egrep -f - ../../../$name/protein.faa -A1 --no-group-separator |\
 blastp -query - -db ../../protdb/br8_Dmel.protdb -outfmt 6 |\
 sort -k1,1 -k12,12nr -k11,11g -k3,3nr |\
 sort -k1,1 -u |\
 awk '{print $2,$1}' |\
 cat - $i |\
 awk '{print $1,$2}' |\
 sort |\
 uniq -c  |\
 sed s'/^ *//' |\
 cut -f 3 -d' ' |\
 egrep -f - ../../../$name/longest.cds.bed |\
 sort -k1,1n -k2,2n > $name.orthologs
 #this output gives the Dmel anchor orthologs in each species. 

num_orthologs=$(cat $name.orthologs | wc -l)

if [[ $num_orthologs -eq $anchor_num ]];then
        if  [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 2 ]] ; then
                awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs |\
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn

        elif [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 3 ]] ; then
                awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs |\
                sed '2d' |\
                # delete middle line and use cordinates encompassing all three orthologs
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn
        
        elif [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 4 ]] ; then
                cat $name.orthologs |\
                # proceed normally if all four orthologs are on the same chromosome
                (awk 'NR==2 ;{a[NR]=$0} END{print a[NR-1]}') |\
                sort -k2,2n |\
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn
        else
                echo $name "Has no anchor orthologs of Dmel's anchor proteins that agree on chromosome location."
        fi

elif [[ $num_orthologs -eq $anchor_num-1 ]]; then
        if  [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 2 ]] ; then
                # if there are three ortholog anchors, select only those two that have the same chr if any
                awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs |\
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn
        elif [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 3 ]] ; then
                awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs |\
                sed '2d' |\
                # delete middle line and use cordinates encompassing all three orthologs
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn
        else
                echo $name "Has no anchor orthologs of Dmel's anchor proteins that agree on chromosome location."
        fi

elif [[ $num_orthologs -eq $anchor_num-2 ]]; then
        if  [[ $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) -eq 2 ]] ; then
                cat $name.orthologs |\
                tr '\n' '       ' |\
                cut -f1,3,6 |\
                bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
                makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn

        elif  [[ -z $(awk 'FNR==NR {a[$1]++; next} a[$1]>1' $name.orthologs $name.orthologs | wc -l) ]] ; then
                echo $name "Has no anchor orthologs of Dmel's anchor proteins that agree on chromosome location."
        fi

elif [[ $num_orthologs -eq $anchor_num-3 ]]; then
        cat $name.orthologs |\
        tr '\n' '      ' |\
        cut -f1,3,6 |\
        bedtools slop -i stdin -g ../../../$name/chromsize -l 0 -r 20000 |\
	# if only one anchor ortholog is present, extend the region of the single gene by 20kb to create the region to search wthin
        bedtools getfasta -fi ../../../$name/$gcf -bed stdin |\
        makeblastdb -title anchor -in - -dbtype nucl -out $name.anchor.db && blastn -query $h.anchors.fna -db $name.anchor.db -outfmt 6 -out $h.$name.regionBetweenAnchors.blastn

else
        echo $name "Has no anchor orthologs of Dmel's anchor proteins."

fi ; done 
cd .. ; done
