# BoDe v1.0
BoDe: Bounded Delay Queue

Installation Guide
==================

Here we will provide you with detailed instructions to test BoDe over Mahimahi.

### Getting the Source Code:

    ```
    cd ~
    git clone https://bitbucket.org/BoDe-Queue/bode.git
    cd bode
    ```

### Installing Required Tools

1. Install Mahimahi (http://mahimahi.mit.edu/#getting)

    ```
    cd ~/BoDe/
    sudo apt-get install build-essential git debhelper autotools-dev dh-autoreconf iptables protobuf-compiler libprotobuf-dev pkg-config libssl-dev dnsmasq-base ssl-cert libxcb-present-dev libcairo2-dev libpango1.0-dev iproute2 apache2-dev apache2-bin iptables dnsmasq-base gnuplot iproute2 apache2-api-20120211 libwww-perl
    git clone https://github.com/ravinet/mahimahi 
    ```
    
2. Patch Mahimahi and add BoDe to it
    
    ```
    cd ~/bode/mahimahi/
    patch -p1 < ../mahimahi.bode.release.v1.5.patch 
    ./autogen.sh && ./configure && make
    sudo make install
    sudo sysctl -w net.ipv4.ip_forward=1
    ```
    
3. Install firefox, google-chrome, skype
    
    ```
    sudo apt-get install firefox
    sudo apt-get install google-chrome-stable
    sudo apt-get install skypforlinux
    ```
    
Notes: For Hangout, we used hangout addon on top of Chrome browser. For Skype, we used a source machine with Windows 10 installed on it. Getting Skype's highest resolution performance depends on having a Windows OS! Check this for the details: https://docs.microsoft.com/en-us/skypeforbusiness/plan-your-deployment/clients-and-devices/video-resolutions
    Also, for Skype and Hangout tests, we considered the first 30 seconds of the tests for setting up the apps/calls (which should be done manually) and later skipped the first 30 seconds of the results.

### Cellular Traces
We used the cellular traces provided by two sources: 1-Mahimahi/Sprout papers 2-C2TCP paper. Mahimahi's source code already includes their trace files. To install the traces from c2tcp paper, we used the following:

    ```
    git clone https://github.com/Soheil-ab/Cellular-Traces-2018.git    
    sudo cp Cell*/* /usr/local/share/maimahi/traces/
    ```

### Run The Evaluation

As a sample run, here, we run YouTube application with BoundedDelay of 20ms over Times Square trace file. You can simply use this script as the base for adding your own applications.

    ```
    cd ~/BoDe/
    ./run.sh
    ```

After 5 minutes you will see a summary of the statistics. 

