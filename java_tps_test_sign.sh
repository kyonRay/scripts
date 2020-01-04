#!/bin/bash

if [ ! -n "$1" ] ; then
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 add 10000 2500 user | tee addTPS
    START=$(date "+%H:%M:%S")
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.precompile.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
    END=$(date "+%H:%M:%S")
    echo "START_TIME $START" >> transferTPS
    echo "END_TIME $END" >> transferTPS
else
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 add 10000 2500 user | tee addTPS
    START=$(date "+%H:%M:%S")
    java -cp ./web3sdk-noParallel-signPackage/dist/conf/:./web3sdk-noParallel-signPackage/dist/lib/*:./web3sdk-noParallel-signPackage/dist/apps/* org.fisco.bcos.channel.test.parallel.parallelok.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
    END=$(date "+%H:%M:%S")
    echo "START_TIME $START" >> transferTPS
    echo "END_TIME $END" >> transferTPS
fi
