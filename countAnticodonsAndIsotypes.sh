for i in br*/*.trnascan ; do
	directory=$(echo $i | sed s'/GCF.*//')
	file=$(echo $i | sed s'/br.*\///g')
	#echo $directory
	cat $i | egrep -v 'Undet|pseudo' | sed '1,3d' | cut -f 5,6 | sort | uniq -c | sort -k2 | sed s'/ *//' | sed s'/ /	/' > $i.temp
	# remove undetermined tRNA types and pseudogenes
	# remove headers
	# get columns of isotypes and anticodons
	# sort and clean up

#	cat $i | egrep -v 'Undet|pseudo' | sed '1,3d' | cut -f 5,6 | sort | uniq -c | sort -k2 | sed s'/ *//' | sed s'/ /	/' | cut -f 2 | uniq -c | sed s'/ *//' | sed s'/ /	/'> $i.isotypeCounts; done

cat $i.temp | datamash -g 2 count 2 > $i.temp1
cat $i.temp | datamash -g 2 sum 1 | cut -f 2 > $i.temp2
# count number of anticodons 
# sum number of genes per isotype

paste -d '	' $i.temp1 $i.temp2 > $i.temp3
# cat $i.temp3 | datamash count 4 > $i.temp4
paste $i.temp $i.temp3 > $i.temp4
# combine counts 
# temp has the conts of anticodons per AA
# temp3 has the counts of 


cat $i.temp4 | datamash sum 1 > $i.temp5
# get total tRNA genes
paste $i.temp4 $i.temp5 | sed '1iNumber of tRNA genes per Anticodon\tIsotype/Amino Acid\tAnticodon\tIsotypes Used in this Species\tNumber of Anticodons Per Isotype\tNumber of tRNA Genes per Isotype\tTotal tRNA genes' > $i.CountsIsotypesAnticodonsNumGenes.tsv 
#echo $i
#cp $i.CountsIsotypesAnticodonsNumGenes.tsv tRNACounts/$file.CountsIsotypesAnticodonsNumGenes.tsv 
# combine for final table and add header 

rm $i*.temp* ; done

ls br*/*tsv | awk '{print $0,$0}'| sed s'/ br-*[0-9]_\([A-Z][a-z][a-z][a-z]\)/	\1_/' | sed s'/_\//_/' | sed s'/^/mv /' | sed s'/	/	tRNACounts\//' | sh


