#!/bin/bash

NODESNUM=4
PRECOMPILE=false
TEST=false
REMOTE=false

while getopts "n:ptr" arg
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
        t)
            TEST=true
            echo "test mode, log(DEBUG)"
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
    if [ -d nodes-signPackage ] ; then
        ./nodes-signPackage/127.0.0.1/stop_all.sh
    fi
    rm -rf nodes-signPackage/
    if [ $TEST = true  ]; then
        bash ./build_chain.sh -e ./fisco-bcos-signPackage -T -l "127.0.0.1:$NODESNUM" -o nodes-signPackage
    else
        bash ./build_chain.sh -e ./fisco-bcos-signPackage -l "127.0.0.1:$NODESNUM" -o nodes-signPackage
    fi
    if [ $REMOTE = true ]; then
        scp ./nodes-signPackage/127.0.0.1/sdk/* bc@192.168.122.13:~/web3sdk-noParallel-signPackage/dist/conf/
    else
        cp nodes-signPackage/127.0.0.1/sdk/* ./web3sdk-noParallel-signPackage/dist/conf/
    fi
    ./nodes-signPackage/127.0.0.1/start_all.sh
    
    START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
    LOOP_TIMES=0
    while [  "$START_NODE" -ne "$NODESNUM" ]
    do
        ./nodes-signPackage/127.0.0.1/start_all.sh
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
            ssh bc@192.168.122.13 "bash java_tps_test.sh -n $NODESNUM -p"
        else
            echo "solidity test"
            ssh bc@192.168.122.13 "bash java_tps_test.sh -n $NODESNUM"
        fi
        scp bc@192.168.122.13:~/tps_report .
        return
    fi
    if [  $PRECOMPILE = true ]; then
        echo "precompile test"
        bash java_tps_test.sh -n $NODESNUM -p
    else
        echo "solidity test"
        bash java_tps_test.sh -n $NODESNUM
    fi
}

stop_chain(){
    ./nodes-signPackage/127.0.0.1/stop_all.sh
    START_NODE=`ps -ef | grep fisco-bcos | grep -v grep | wc -l`
    LOOP_TIMES=0
    while [  "$START_NODE" -ne 0 ]
    do
        ./nodes-signPackage/127.0.0.1/stop_all.sh
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
