
for i in br*_* ; do cd $i 
cut -f1,2 *.fna.fai > chromsize 
cd ..; done
