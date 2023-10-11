for w in {100..1000..300} ; do
        for s in {50..150..50} ; do

		join -t '	' <(sed '1d' dmel.ooa.$w.$s.windowed.pi | sort -k1,1 -k2,2h ) <( sed '1d' dmel.afr.$w.$s.windowed.pi | sort -k1,1 -k2,2h ) -1 2 -2 2  -o1.1,1.2,1.3,1.4,1.5,2.1,2.2,2.3,2.4,2.5 -e '0' -a1 -a2 > temp1

		cut -f 1-3,6-8 temp1 | sed s'/^0	0	0//g ; s/^	//g' | cut -f 1-3 > temp2 

		cut -f 4,5,9,10 temp1 > temp3

		paste temp2 temp3 > correctedWindows/dmel.$w.$s.pi.ratio ; done ; done
