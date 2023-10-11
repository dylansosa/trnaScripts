grep "" ../*/*regionBetweenAnchors.blastn | sed s'/:/ / ; s/ /	/ ; s/trna[0-9][0-9][0-9]\.//g' | sort -k2,2 > temp_dating

cat temp_dating | sed s'/..\/trna[0-9][0-9][0-9]\/// ; s/\.regionBetweenAnchors\.blastn//' | cut -f 1,2 -d '	' | sort -k2,2n | awk '!seen[$2]++' | sort -k1.3g > trna_ages.tsv

cat trna_ages.tsv | sed s'/_/	/' | cut -f 1| uniq -c | sed s'/^ *// ;s/ /	/' > trna_ageDistribution.tsv

cat trna_ages.tsv | cut -f 1,2 | sed s'/_[A-Z].*	/_/' | cut -f 1 > trna_ages_branches.tsv

cp /home/sosa/thesis/3_tRNA_evolution/NEW_DROSOPHILID_24_DATA/ncbi_dataset/data/br8_Dmel/GCF_000001215.4.highConfidence.bed trna_ages.bed

cat trna_ages_branches.tsv | sed s'/::/     /' | awk '{print $1,$1}' | sed s'/^br-*[0-9]_// ; s/ /  / ; s:^:s"\/: ; s:      :\/: ;s:$:/":' | sed s"/\"/'/g ; s/^/sed -i / ; s/$/ trna_ages.bed/" | sh
