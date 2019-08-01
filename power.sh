if [ $# -ne 1 ]
then
    echo "usage: $0 prefix"
    exit
fi

for i in $1*.tsv
do
    cat $i | awk '{out="";for(i=1;i<=NF;i++){out=out" "$i};if($1!="protocol"){out=out" "$3/$4" "$3/$6;}else{out=out" p99 p"}print out}' > f.$i;#rm $i;
    column -t f.$i > $i
    rm f.$i
#    mv f.$i $i
done

