if [ $# -ne 3 ]
then
    echo "$0 [skype hangout] [prefix: results sum new-results] [output:post]"
    exit
fi

rm bode head pie codel fifo

for i in $2*$1*tsv
#for i in final*;
do
    thr=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $3}'`
    del=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $6}'`
    del_95=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $5}'`
    del_95_s=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $4}'`
    p_avg=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $8}'`
    p_95=`cat $i | sed "/protocol.*/d" | grep "BoDe " | awk '{print $9}'`
    echo $i
#    echo "$thr $del $del_95 $del_95s $p_avg $p95"
    echo "p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95""
    cat $i | sed "/protocol.*/d" | awk -v p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95" '{ print $1" "$2" "$3/thr" "$4/del_95_s" "$5/del_95" "$6/del" "p_avg/$8" "p_95/$9}' | column -t | grep "BoDe " >> bode
    cat $i | sed "/protocol.*/d" | awk -v p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95" '{ print $1" "$2" "$3/thr" "$4/del_95_s" "$5/del_95" "$6/del" "p_avg/$8" "p_95/$9}' | column -t | grep "TailDrop" >> fifo
    cat $i | sed "/protocol.*/d" | awk -v p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95" '{ print $1" "$2" "$3/thr" "$4/del_95_s" "$5/del_95" "$6/del" "p_avg/$8" "p_95/$9}' | column -t | grep "HeadDrop" >> head
    cat $i | sed "/protocol.*/d" | awk -v p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95" '{ print $1" "$2" "$3/thr" "$4/del_95_s" "$5/del_95" "$6/del" "p_avg/$8" "p_95/$9}' | column -t | grep "Pie" >> pie
    cat $i | sed "/protocol.*/d" | awk -v p_95="$p_95" -v p_avg="$p_avg" -v del_95_s="$del_95_s" -v thr="$thr" -v del="$del" -v del_95="$del_95" '{ print $1" "$2" "$3/thr" "$4/del_95_s" "$5/del_95" "$6/del" "p_avg/$8" "p_95/$9}' | column -t | grep "Codel" >> codel
done

cat bode | awk 'BEGIN{out="BoDe";for(i=1;i<9;i++)s[i]=0}{for(i=1;i<9;i++)if( NF!=2)s[i]+=$i;}END{for(i=1;i<9;i++) out=out" "s[i]/NR;print out}' > avg_norm
cat fifo | awk 'BEGIN{out="TailDrop";for(i=1;i<9;i++)s[i]=0}{for(i=1;i<9;i++)if( NF!=2)s[i]+=$i;}END{for(i=1;i<9;i++) out=out" "s[i]/NR;print out}' >> avg_norm
cat codel | awk 'BEGIN{out="Codel";for(i=1;i<9;i++)s[i]=0}{for(i=1;i<9;i++)if( NF!=2)s[i]+=$i;}END{for(i=1;i<9;i++) out=out" "s[i]/NR;print out}' >> avg_norm
cat head | awk 'BEGIN{out="HeadDrop";for(i=1;i<9;i++)s[i]=0}{for(i=1;i<9;i++)if( NF!=2)s[i]+=$i;}END{for(i=1;i<9;i++) out=out" "s[i]/NR;print out}' >> avg_norm
cat pie | awk 'BEGIN{out="PIE";for(i=1;i<9;i++)s[i]=0}{for(i=1;i<9;i++)if( NF!=2)s[i]+=$i;}END{for(i=1;i<9;i++) out=out" "s[i]/NR;print out}' >> avg_norm

cat avg_norm | awk 'BEGIN{for(i=1;i<10;i++)s[i]=0}{out="";for(i=1;i<10;i++)if(i!=2 && i!=3)out=out""$i" ";print out}' > avg_norm2
echo "protocol throughput 99th_pkt_del 95th_pkt_del avg_del power_99_del power_avg_del" > avg_norm
cat avg_norm2 >> avg_norm

column -t avg_norm > avg_norm.$1.$3

rm avg_norm avg_norm2
