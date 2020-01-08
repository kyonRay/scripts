#!/bin/bash

NODESNUM=4
PRECOMPILE=false
OFFICIAL_TEST=false

while getopts "n:po" arg
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
        o)
            OFFICIAL_TEST=true
            echo "official bin test"
        ;;
        ?)
            echo "unknow argument"
            exit 1
        ;;
    esac
done

if [ $OFFICIAL_TEST = true ]; then
    rm -rf ./web3sdk-noParallel-buildOfficial/dist/conf/applicationContext.xml
    mv ./web3sdk-noParallel-buildOfficial/dist/conf/applicationContext-$NODESNUM.xml ./web3sdk-noParallel-buildOfficial/dist/conf/applicationContext.xml

    if [  $PRECOMPILE = true ]; then
        echo "precompile test"
        #userAdd
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 add 10000 2500 user
        # transfer
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
        cat transferTPS | grep TPS | awk '{print $2}' > tps_report
    else
        echo "solidity test"
        #userAdd
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 add 10000 2500 user
        # transfer
        java -cp ./web3sdk-noParallel-buildOfficial/dist/conf/:./web3sdk-noParallel-buildOfficial/dist/lib/*:./web3sdk-noParallel-buildOfficial/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
        cat transferTPS | grep TPS | awk '{print $2}' > tps_report
    fi
    exit 1
fi


rm -rf ./web3sdk-noParallel-signPackage/dist/conf/applicationContext.xml
mv ./web3sdk-noParallel-signPackage/dist/conf/applicationContext-${NODESNUM}.xml ./web3sdk-noParallel-signPackage/dist/conf/applicationContext.xml

if [  $PRECOMPILE = true ]; then
    echo "precompile test"
    #userAdd
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 add 10000 2500 user
    # transfer
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
    cat transferTPS | grep TPS | awk '{print $2}' > tps_report
else
    echo "solidity test"
    #userAdd
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 add 10000 2500 user
    # transfer
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
    cat transferTPS | grep TPS | awk '{print $2}' > tps_report
fi
