down=("downlink-4g-no-cross-times" "downlink-4g-no-cross-subway.pps" "Verizon-LTE-driving.down" "ATT-LTE-driving.down" "uplink-4g-no-cross-times" "uplink-4g-no-cross-subway.pps" "Verizon-LTE-driving.up")
for index in 0 #1 2 4 5 6 7 #`seq 3 9` #0 1 2 3 4 5 6 7 8 9 #3 4 5 6 7 #1 2 3 4 #0
do
    for scheme in 3 #1 2 3 4 5 #1 2 3 4 5 #1 3 5 #1 2 3 5 #1 2 3 5 4 #1 3 2 4 5
    do
        ./run-exp.sh youtube $scheme ${down[$index]}
    done
done
#./process_log.sh sum youtube
#./process_log.sh sum amazon
#./plot.sh

