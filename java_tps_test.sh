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
javaExecute()
{
    TEST_TYPE="${1}"
    CONTRACT_TYPE="${2}"
    #userAdd
    java -cp ./web3sdk-noParallel-${TEST_TYPE}/dist/conf/:./web3sdk-noParallel-${TEST_TYPE}/dist/lib/*:./web3sdk-noParallel-${TEST_TYPE}/dist/apps/* org.fisco.bcos.channel.test.parallel.${CONTRACT_TYPE}.PerformanceDT 1 add 10000 2500 user
    # transfer
    java -cp ./web3sdk-noParallel-${TEST_TYPE}/dist/conf/:./web3sdk-noParallel-${TEST_TYPE}/dist/lib/*:./web3sdk-noParallel-${TEST_TYPE}/dist/apps/* org.fisco.bcos.channel.test.parallel.${CONTRACT_TYPE}.PerformanceDT 1 transfer 100000 4000 user 2 | tee transferTPS
    cat transferTPS | grep TPS | awk '{print $2}' > tps_report
}
if [ $OFFICIAL_TEST = true ]; then
    
    if [  $PRECOMPILE = true ]; then
        echo "precompile test"
        javaExecute "buildOfficial" "precompile"
    else
        echo "solidity test"
        javaExecute "buildOfficial" "parallelok"
    fi
    exit 1
fi

if [  $PRECOMPILE = true ]; then
    echo "precompile test"
    javaExecute "signPackage" "precompile"
else
    echo "solidity test"
    javaExecute "signPackage" "parallelok"
fi
