if [ $# -ne 2 ]
then
    echo "usage $0 [name:skype hangout youtube] [delay]"
    exit
fi

down=("downlink-4g-no-cross-times" "downlink-4g-no-cross-subway.pps" "Verizon-LTE-driving.down" "ATT-LTE-driving.down" "uplink-4g-no-cross-times" "uplink-4g-no-cross-subway.pps" "Verizon-LTE-driving.up")
UPLINKS=("wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48" "wired48")
name=$1
prefix=summary
delay=$3

#downlink=${down[${index}]}
#uplink=${UPLINKS[$index]}
#trace_="$uplink-$downlink-$name"
cp $prefix.tr tmp
sed -i "s/3-$delay.*$name-1000-.*/BoDe/g" tmp
sed -i "s/4-$delay.*$name-1000-.*/HeadDrop/g" tmp
sed -i "s/2-$delay.*$name-1000-.*/TailDrop/g" tmp
sed -i "s/5-$delay.*$name.*/Pie/g" tmp
sed -i "s/1-$delay.*$name-.*/Codel/g" tmp
mv tmp $prefix
python process_log.py $prefix $prefix.tsv
rm $prefix

