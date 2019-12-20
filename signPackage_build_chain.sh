#!/bin/bash

NODESNUM=4
PRECOMPILE=false
TEST=false

while getopts "n:pt" arg
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
		?)
			echo "unknow argument"
			exit 1
			;;
	esac
done


start_chain()
{
	rm -rf nodes-signPackage/
	if [ $TEST = true  ]; then
		bash ./build_chain.sh -e ./fisco-bcos-signPackage -T -l "127.0.0.1:$NODESNUM" -o nodes-signPackage
	else
		bash ./build_chain.sh -e ./fisco-bcos-signPackage -l "127.0.0.1:$NODESNUM" -o nodes-signPackage
	fi
	cp ./build_chain.sh nodes-signPackage/127.0.0.1/sdk/* ./web3sdk-noParallel-signPackage/dist/conf/
	./nodes-signPackage/127.0.0.1/start_all.sh
}

start_java(){
	cd ./web3sdk-noParallel-signPackage/dist
	if [  $PRECOMPILE = true ]; then
		echo "precompile test"
		./java_tps_test.sh
	else
		echo "solidity test"
		./java_tps_test.sh 1
	fi
}

stop_chain(){
	cd ../../
	./nodes-signPackage/127.0.0.1/stop_all.sh
}

start_chain
start_java
stop_chain
