#!/bin/bash

NODESNUM=4
PRECOMPILE=false

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
	rm -rf nodes-buildOfficial/
	bash ./build_chain.sh -e ./fisco-bcos-buildOfficial  -l "127.0.0.1:$NODESNUM" -o nodes-buildOfficial
	cp ./build_chain.sh nodes-buildOfficial/127.0.0.1/sdk/* ./web3sdk-noParallel-buildOfficial/dist/conf/
	./nodes-buildOfficial/127.0.0.1/start_all.sh
}

start_java(){
	cd ./web3sdk-noParallel-buildOfficial/dist
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
	./nodes-buildOfficial/127.0.0.1/stop_all.sh
}

start_chain
start_java
stop_chain