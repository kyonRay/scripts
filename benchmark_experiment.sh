#!/bin/bash

OFFICIAL_BENCHMARK=true
SIGNPACK_BENCHMARK=true

TPS=0
PRE_BASE=3300
SOLIDITY_BASE=2500


while getopts "n:so" arg
do
	case $arg in
		n)
			NODESNUM=$OPTARG
			;;
		s)
			SIGNPACK_BENCHMARK=true
            OFFICIAL_BENCHMARK=false
			echo "SIGNPACK_BENCHMARK = $SIGNPACK_BENCHMARK"
            echo "OFFICIAL_BENCHMARK = $OFFICIAL_BENCHMARK"
			;;
        o)
            SIGNPACK_BENCHMARK=false
            OFFICIAL_BENCHMARK=true
			echo "SIGNPACK_BENCHMARK = $SIGNPACK_BENCHMARK"
            echo "OFFICIAL_BENCHMARK = $OFFICIAL_BENCHMARK"
            ;;
		?)
			echo "unknow argument"
			exit 1
			;;
	esac
done

buildMarkDownCode()
{
    echo -e "\`\`\`shell\n" >> report
    echo -e "# addTPS\n" >> report
    cat addTPS_report >> report
    echo -e "\n\n# transferTPS\n" >> report
    cat transferTPS_report >> report
    echo -e "\n\`\`\`\n" >> report
    rm addTPS_report transferTPS_report
}

officialBinTest()
{
    NODES="${1}"
    TIMES="${2}"
    PRE_COMPILE="${3}"
    
    if [ $PRE_COMPILE = true ]; then
        echo -e "### $NODES nodes, solidity, $TIMES times\n" >> report
    else
        echo -e "### $NODES nodes, precompile, $TIMES times\n" >> report
    fi

    for i in $(seq 1  $TIMES)
    do  
        if [ $PRE_COMPILE = true ]; then
            bash official_build_chain.sh -n $NODES -p
        else
            bash official_build_chain.sh -n $NODES
        fi
        cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
        cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
    done

    buildMarkDownCode
}

signPackBinTest()
{
    NODES="${1}"
    TIMES="${2}"
    PRE_COMPILE="${3}"
    
    if [ $PRE_COMPILE = true ]; then
        echo -e "### $NODES nodes, solidity, $TIMES times\n" >> report
    else
        echo -e "### $NODES nodes, precompile, $TIMES times\n" >> report
    fi

    for i in $(seq 1  $TIMES)
    do  
        if [ $PRE_COMPILE = true ]; then
            bash signPackage_build_chain.sh -n $NODES -p
        else
            bash signPackage_build_chain.sh -n $NODES
        fi
        cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
        cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
    done

    buildMarkDownCode
}

officialBenchmark()
{
    ### official bin benchmark
    echo -e "## official bin benchmark\n" >> report
    ## 4 nodes, solidity, 50 times

    officialBinTest 4 50 false

    ## 4 nodes, precompile, 50 times

    officialBinTest 4 50 true

    ## 8 nodes, precompile ,20 times

    officialBinTest 8 20 true

    ## 16 nodes, precompile ,20 times

    officialBinTest 16 20 true

    ## 32 nodes, precompile ,10 times

    officialBinTest 32 10 true
}

signPackageBenchmark()
{
    ### signPackage bin benchmark
    echo -e "## signPackage bin benchmark\n" >> report
    ## 4 nodes, solidity, 50 times

    signPackBinTest 4 50 false

    ## 4 nodes, precompile, 50 times

    signPackBinTest 4 50 true

    ## 8 nodes, precompile ,20 times

    signPackBinTest 8 20 true

    ## 16 nodes, precompile ,20 times

    signPackBinTest 16 20 true

    ## 32 nodes, precompile ,10 times

    signPackBinTest 32 10 true
}


rm transferTPS_report addTPS_report

echo -e "# Benchmark Experiment Report\n" > report

if [ $OFFICIAL_BENCHMARK = true ] ; then
    officialBenchmark
fi

if [ $SIGNPACK_BENCHMARK = true ] ; then
    signPackageBenchmark
fi
