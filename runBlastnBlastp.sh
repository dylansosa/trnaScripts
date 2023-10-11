declare -a trna_arr=($(ls -D ./br*/trnadb/* | egrep /br | egrep .ndb | sed s'/.ndb//' | sed s'/://g ; s:\./:\.\./\.\./\.\./: ; s/^/"/ ; s/$/" /' |  tr -d '\n'))
declare -a prot_arr=($(ls -D ./br*/protdb/* | egrep /br | egrep .pdb | sed s'/.pdb//' | sed s'/://g ; s:\./:\.\./\.\./\.\./: ; s/^/"/ ; s/$/" /' |  tr -d '\n'))
# init database arrays for blast using output below 


for i in $(ls -D ./* | egrep ./GCF | sed s'/://g') ; do cd $i/anchors ; 
	for j in $(ls -D ./* | egrep ':' | sed s'/://g'); do
		cd $j
		name=$(echo trna*.anchors | sed s'/.anchors//')
	
	for k in "${prot_arr[@]}"; do 
		prefix=$(echo $k | egrep -o '/br.*_[A-Z][a-z]{3}*/' | sed s':/::g') ; 
		# this is to get individual spp names in output file name 

		blastp -query *.faa -db $k -max_hsps 1 -max_target_seqs 2 -outfmt "6" -seg yes -out $prefix.$name.blastp
		echo $prefix.$name.blastp ; done
		# for each species' database do blastp with the four protein seqs surrounding a tRNA
	
	for l in "${trna_arr[@]}"; do 
		prefix=$(echo $l | egrep -o '/br.*_[A-Z][a-z]{3}*/' | sed s':/::g') ;
		blastn -task blastn-short -query *.fna -db $l -outfmt "6" -evalue 0.01 -out $prefix.$name.blastn
		echo $prefix.$name.blastn ; done
		# do blastn with each trna in each anchor file 
	cd ../ ; done
cd ../../ ; done
