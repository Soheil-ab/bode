if [ $# -ne 3 ]
then
    echo "$0 [application] [AQM] [trace]"
    exit
fi
sudo sysctl -w net.ipv4.ip_forward=1
sudo killall google-chrome-stable firefox
sudo killall skypeforlinux
name=$1
queue=$2
trace=$3
qsize=1000
thr=2 #3 pkts
duration=300
down=("downlink-4g-no-cross-times" "downlink-4g-no-cross-subway.pps" "Verizon-LTE-driving.down" "ATT-LTE-driving.down" "uplink-4g-no-cross-times" "uplink-4g-no-cross-subway.pps" "Verizon-LTE-driving.up")

user=`whoami`
anal_script="mm-thr"
if [ "$name" == "amazon" ]
then
    target=20
    #In our tests RTT delay to Amazon/YouTube servers was about 10ms So Additional Unidirectioanl delay: 0ms
    delay=0
    cmd="firefox https://www.amazon.com/gp/video/detail/B01G7UJIVI/ref=atv_dp_pb_core?autoplay=1\& & sleep $duration && killall firefox"
elif [ "$name" == "youtube" ]
then
    target=20
    #In our tests RTT delay to Amazon/YouTube servers was about 10ms So Additional Unidirectioanl delay: 0ms
    delay=0
    cmd="google-chrome-stable  https://www.youtube.com/watch?v=Bey4XXJAqS8 & sleep $duration && killall chrome"
elif [ "$name" == "hangout" ]
then
    target=100
    #Unidirectioanl delay: 5ms
    delay=5
    anal_script="mm-thr-skype"
    cmd="google-chrome-stable  & sleep $duration && killall chrome"
elif [ "$name" == "skype" ]
then
    target=100
    #Unidirectioanl delay: 5ms
    delay=5
    anal_script="mm-thr-skype"
    cmd="skypeforlinux  & sleep $duration && killall chrome"
else
    echo "Please choose a correct application: skype hangout youtube amazon"
    exit
fi

sudo killall chrome google-chrome-stable
sudo rm -r ~/.cache/google-chrome
sudo rm -r ~/.cache/mozila/
sudo rm -r ~/.config/skypeforlinux/Cache/
downlink=${trace}
uplink=wired48
trace_="$uplink-$downlink-$name"
log="$queue-$delay-$trace_-$qsize-$target-$thr-$duration"
if [ $queue -eq 2 ]
then
     sudo -u $user mm-delay $delay mm-link /usr/local/share/mahimahi/traces/$uplink /usr/local/share/mahimahi/traces/$downlink --uplink-log=up-mul-$log --downlink-log=down-mul-$log --uplink-queue=droptail --uplink-queue-args=\"packets=$qsize\" --downlink-queue=droptail --downlink-queue-args=\"packets=$qsize\" --meter-downlink --meter-downlink-delay   -- sh -c "$cmd"
elif [ $queue -eq 4 ]
then
     sudo -u $user mm-delay $delay mm-link /usr/local/share/mahimahi/traces/$uplink /usr/local/share/mahimahi/traces/$downlink --uplink-log=up-mul-$log --downlink-log=down-mul-$log --uplink-queue=drophead --uplink-queue-args=\"packets=$qsize\" --downlink-queue=drophead --downlink-queue-args=\"packets=$qsize\" --meter-downlink --meter-downlink-delay  -- sh -c "$cmd"
elif [ $queue -eq 1 ]
then
    sudo -u $user mm-delay $delay mm-link /usr/local/share/mahimahi/traces/$uplink /usr/local/share/mahimahi/traces/$downlink --uplink-log=up-mul-$log --downlink-log=down-mul-$log --uplink-queue=codel --uplink-queue-args=\"packets=$qsize,target=$((target/2)),interval=50\" --downlink-queue=codel --downlink-queue-args=\"packets=$qsize,target=$((target/2)),interval=50\" --meter-downlink --meter-downlink-delay  -- sh -c "$cmd"
elif [ $queue -eq 5 ]
then
    #We disable passing bursty traffic that causes average delay performance reduction for PIE by setting max_burst to 3ms
    sudo -u $user mm-delay $delay mm-link /usr/local/share/mahimahi/traces/$uplink /usr/local/share/mahimahi/traces/$downlink --uplink-log=up-mul-$log --downlink-log=down-mul-$log --uplink-queue=pie --uplink-queue-args=\"packets=$qsize,qdelay_ref=$target,max_burst=3\" --downlink-queue=pie --downlink-queue-args=\"packets=$qsize,qdelay_ref=$target,max_burst=3\"  --meter-downlink --meter-downlink-delay  -- sh -c "$cmd"
else
   sudo -u $user mm-delay $delay mm-link /usr/local/share/mahimahi/traces/$uplink /usr/local/share/mahimahi/traces/$downlink --uplink-log=up-mul-$log --downlink-log=down-mul-$log --uplink-queue=bode --uplink-queue-args=\"packets=$qsize,target=$target,min_thr=$thr\" --downlink-queue=bode --downlink-queue-args=\"packets=$qsize,target=$target,min_thr=$thr\"  --meter-downlink --meter-downlink-delay  -- sh -c "$cmd"
fi
sudo killall skypeforlinux firefox
echo $log >>summary.tr
./$anal_script 250 down-mul-$log 1>tmp 2>>summary.tr
echo "---------------------------------------">>summary.tr
rm tmp
cat summary.tr

