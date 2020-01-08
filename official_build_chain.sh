#!/bin/bash

NODESNUM=4
PRECOMPILE=false
START_NODE=0
REMOTE=false

while getopts "n:pr" arg
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
        r)
            REMOTE=true
            echo "remote mode, remote sdk: 192.168.122.13"
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
    if [ $REMOTE = true ]; then
        scp ./nodes-buildOfficial/127.0.0.1/sdk/* bc@192.168.122.13:~/web3sdk-noParallel-buildOfficial/dist/conf/
    else
        cp nodes-buildOfficial/127.0.0.1/sdk/* ./web3sdk-noParallel-buildOfficial/dist/conf/
    fi
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
    if [ $REMOTE = true ]; then
        if [  $PRECOMPILE = true ]; then
            echo "precompile test"
            ssh bc@192.168.122.13 "bash java_tps_test.sh -n $NODESNUM -p -o"
        else
            echo "solidity test"
            ssh bc@192.168.122.13 "bash java_tps_test.sh -n $NODESNUM -o"
        fi
        scp bc@192.168.122.13:~/tps_report .
        return
    fi
    if [  $PRECOMPILE = true ]; then
        echo "precompile test"
        bash java_tps_test.sh -n $NODESNUM -p -o
    else
        echo "solidity test"
        bash java_tps_test.sh -n $NODESNUM -o
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