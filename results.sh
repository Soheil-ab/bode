if [ $# -ne 1 ]
then
    echo "usage: $0 [name: skype hangout]"
    exit
fi
./process_log.sh $1 summary
./power.sh summary
./norm.sh $1 summary 99
./plot.norm.sh $1 avg_norm.$1.99 1
