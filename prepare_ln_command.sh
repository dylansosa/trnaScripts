cat data_summary.tsv | cut -f 1,2,6 |sed '1d' | sed s'/fruit fly// ;s/Drosophila/D/g ; s/Scaptodrosophila/S/ ; s/ //' | cut -f 1 - | colrm 5 > 4letterName
# getting Spp name in 4 letter form

cat data_summary.tsv | cut -f 1,2,6 |sed '1d' | sed s'/fruit fly// ;s/Drosophila/D/g ; s/Scaptodrosophila/S/ ; s/ //' | sed s'/	//; s/[A-Z][a-z]*	//'  > assemblyID
# get assembly matching spp

paste 4letterName assemblyID  | awk '{print "ln -s ./"$2,"br_"$1}' > ln_command
# combine and prepare ln command without branch num
#manually add branch num and execute 
