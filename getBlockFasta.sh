for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i/anchors ; 
	for j in $(ls -D ./* | egrep ':' | sed s'/://g'); do
	cd $j
	name=$(echo trna*.anchors)
	# cut -f 5 trna*.anchors | egrep -f - ../../*.longest.cds.faa -A1 --no-group-separator > $name.anchors.faa
	# cut -f 5 trna*.anchors 	| egrep -f - ../../*longest.cds.order | cut -f 5 - | egrep -f - ../../*.longest.cds.faa -A1 --no-group-separator > $name.anchors.faa
	cut -f 5 trna*.anchors  | egrep -f - ../../*longest.cds.order | cut -f 5 - | egrep -f - ../../*.longest.cds.faa -A1 --no-group-separator >> $name.faa
	cut -f 5 trna*.anchors | egrep -f - ../../*.highConfidence.fna -A1 --no-group-separator >> $name.fna
	cd ../ ; done
cd ../../ ; done

