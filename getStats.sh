for i in *.vcf.gz ; do
	vcftools --gzvcf $i --keep OOA.populationsIDs --recode --out $i.ooa
	vcftools --gzvcf $i --keep AFR.populationsIDs --recode --out $i.afr ; done
	# separate vcf for Fst

for w in {100..1000..300} ; do
        for s in {50..150..50} ; do
	vcftools --gzvcf dmel.dash.vcf.gz.afr.recode.vcf --window-pi $w --window-pi-step $s --out pi/windowed/dmel.afr.$w.$s 
	vcftools --gzvcf dmel.dash.vcf.gz.ooa.recode.vcf --window-pi $w --window-pi-step $s --out pi/windowed/dmel.ooa.$w.$s 
	# compute windowed pi

	vcftools --gzvcf dmel.dash.vcf.gz --weir-fst-pop OOA.populationsIDs --weir-fst-pop AFR.populationsIDs --fst-window-size $w --fst-window-step $s --out fst/windowed/dmel.$w.$s.fst ; done ; done
	# combute windowed Fst
