for h in $(ls -D ./* | egrep ':' | sed s'/://g ; s/\.\///') ; do
cd $h
cat $h.anchors| cut -f 1-8 | sed s'/	\(N[A-Z]_[0-9]*\.[0-9]\)/	\1	/ ; s/\.t/t/ ; s/		/	/' | awk '{$2 = $7 OFS $2}1' | awk 'NF{NF-=1};1' | sed s'/ /	/g' | awk 'BEGIN{FS=OFS="\t"}{$2 = "tRNAscan-SE" OFS $2}1' | sed s'/coding/CDS/g' | awk 'BEGIN{FS=OFS="\t"}{$7=$1 OFS $7}1' | awk '!($8="")' | sed s'/ /	/g' | sed s'/	\(N[A-Z]_[0-9].*\)\(	.*\)/	ID=\1;Name=\2;start_type=ATG;/ ; s/	;/;/ ; s/=	/=/' | awk 'BEGIN{FS=OFS="\t"}{$6="1.0" OFS $6}1' | awk 'BEGIN{FS=OFS="\t"}{$8=0 OFS $8}1'> $h.anchors.gff

cd .. ; done
