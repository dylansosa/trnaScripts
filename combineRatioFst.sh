for w in {100..1000..300} ; do
        for s in {50..150..50} ; do

	join -t '	' <(sort -k1,1 -k2,2h ../../pi/windowed/correctedWindows/dmel.$w.$s.pi.ratio) <(sed '1d' dmel.$w.$s.windowed.weir.fst | sort -k1,1 -k2,2h) -1 2 -2 2 -o1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.4,2.5,2.6 -e 'NULL' -a1 -a2 > combinedFinalStats/dmel.$w.$s.pi.ratio.fst ; done ; done
