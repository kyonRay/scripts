#!/bin/bash

NODESNUM=4
PRECOMPILE=false
START_NODE=0

while getopts "n:p" arg
do
    case $arg in
        n)
            NODESNUM=$OPTARG
            echo "nodes number is $NODESNUM"
        ;;
        p)
            PRECOMPILE=true
            echo "precompile=$PRECOMPILE"
        ;;
        ?)
            echo "unknow argument"
            exit 1
        ;;
    esac
done


start_chain()
{
    if [ -d nodes-buildOfficial ] ; then
        ./nodes-buildOfficial/127.0.0.1/stop_all.sh
    fi
    rm -rf nodes-buildOfficial/
    bash ./build_chain.sh -e ./fisco-bcos-buildOfficial  -l "127.0.0.1:$NODESNUM" -o nodes-buildOfficial
    cp nodes-buildOfficial/127.0.0.1/sdk/* ./web3sdk-noParallel-buildOfficial/dist/conf/
    ./nodes-buildOfficial/127.0.0.1/start_all.sh
    
    START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
    LOOP_TIMES=0
    while [  "$START_NODE" -ne "$NODESNUM" ]
    do
        ./nodes-buildOfficial/127.0.0.1/start_all.sh
        sleep 3
        START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
        ((LOOP_TIMES++));
        if [ $LOOP_TIMES -gt 10 ]; then
            exit 1
        fi
    done
    sleep 3
}

start_java(){
    if [  $PRECOMPILE = true ]; then
        echo "precompile test"
        #userAdd
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 add 10000 2500 user
        # transfer
        START=$(date "+%H:%M:%S")
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 transfer 100000 4000 user 2
        END=$(date "+%H:%M:%S")
        bash get_tps.sh nodes-buildOfficial/127.0.0.1/node0/log/log_2*.log $START $END | grep tps | awk '{print $10}' | tee tps_report
    else
        echo "solidity test"
        #userAdd
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 add 10000 2500 user
        # transfer
        START=$(date "+%H:%M:%S")
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 transfer 100000 4000 user 2
        END=$(date "+%H:%M:%S")
        bash get_tps.sh nodes-buildOfficial/127.0.0.1/node0/log/log_2*.log $START $END | grep tps | awk '{print $10}' | tee tps_report
    fi
}

stop_chain(){
    ./nodes-buildOfficial/127.0.0.1/stop_all.sh
    START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
    LOOP_TIMES=0
    while [  "$START_NODE" -ne 0 ]
    do
        ./nodes-buildOfficial/127.0.0.1/stop_all.sh
        sleep 3
        START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
        ((LOOP_TIMES++));
        if [ $LOOP_TIMES -gt 10 ]; then
            exit 1
        fi
    done
    sleep 1
}

start_chain
start_java
stop_chain