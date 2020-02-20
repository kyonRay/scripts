#!/bin/bash

OFFICIAL_BENCHMARK=true
SIGNPACK_BENCHMARK=true
DEBUG=false

TPS=0
TPS_BASE=3000
REMOTE=false

while getopts "n:sort" arg
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
        r)
            REMOTE=true
        ;;
        t)
            DEBUG=true
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
    echo -e "# transferTPS\n" >> report
    cat transferTPS_report >> report
    echo -e "\n\`\`\`\n" >> report
}

officialBinTest()
{
    NODES="${1}"
    TIMES="${2}"
    PRE_COMPILE="${3}"
    
    if [ $PRE_COMPILE = true ]; then
        echo -e "### $NODES nodes, precompile, $TIMES times\n" >> report
    else
        echo -e "### $NODES nodes, solidity, $TIMES times\n" >> report
    fi

    if [ -e transferTPS_report ];then
        rm transferTPS_report
    fi
    
    for i in $(seq 1  $TIMES)
    do
        if [ $PRE_COMPILE = true ]; then
            if [ $REMOTE = true ];then
                if [ $DEBUG = true ];then
                    bash official_build_chain.sh -n $NODES -p -r -t
                else
                    bash official_build_chain.sh -n $NODES -p -r
                fi
            else
                if [ $DEBUG = true ];then
                    bash official_build_chain.sh -n $NODES -p -t
                else
                    bash official_build_chain.sh -n $NODES -p
                fi
            fi
        else
            if [ $REMOTE = true ];then
                if [ $DEBUG = true ];then
                    bash official_build_chain.sh -n $NODES -r -t
                else
                    bash official_build_chain.sh -n $NODES -r
                fi
            else
                if [ $DEBUG = true ];then
                    bash official_build_chain.sh -n $NODES -t
                else
                    bash official_build_chain.sh -n $NODES
                fi
            fi
        fi
        cat tps_report >> transferTPS_report
    done
    
    buildMarkDownCode
}

collectLogs()
{
    NODE_NUM="${1}"
    TPS="${2}"
    mkdir -p "logs_${NODE_NUM}nodes_${TPS}"
    ((NODE_NUM--))
    for i in $(seq 0 $NODE_NUM)
    do
        mkdir -p ./"logs_${1}nodes_${TPS}"/"node$i"
        cp ./nodes-signPackage/127.0.0.1/node$i/log/* ./"logs_${1}nodes_${TPS}"/"node$i"/
        sed -i "/Send transaction to peer/d;/Receive peer txs packet/d;/Import peer transactions/d;/Receive packet from/d" ./"logs_${1}nodes_${TPS}"/"node$i"/*
    done
}

signPackBinTest()
{
    NODES="${1}"
    TIMES="${2}"
    PRE_COMPILE="${3}"
    
    if [ $PRE_COMPILE = true ]; then
        echo -e "### $NODES nodes, precompile, $TIMES times\n" >> report
    else
        echo -e "### $NODES nodes, solidity, $TIMES times\n" >> report
    fi

    if [ -e transferTPS_report ];then
        rm transferTPS_report
    fi

    for i in $(seq 1  $TIMES)
    do
        if [ $PRE_COMPILE = true ]; then
            if [ $REMOTE = true ]; then
                if [ $DEBUG = true ];then
                    bash signPackage_build_chain.sh -n $NODES -p -r -t
                else
                    bash signPackage_build_chain.sh -n $NODES -p -r
                fi
            else
                if [ $DEBUG = true ];then
                    bash signPackage_build_chain.sh -n $NODES -p -t
                else
                    bash signPackage_build_chain.sh -n $NODES -p
                fi
            fi
        else
            if [ $REMOTE = true ]; then
                if [ $DEBUG = true ];then
                    bash signPackage_build_chain.sh -n $NODES -r -t
                else
                    bash signPackage_build_chain.sh -n $NODES -r
                fi
            else
                if [ $DEBUG = true ];then
                    bash signPackage_build_chain.sh -n $NODES -t
                else
                    bash signPackage_build_chain.sh -n $NODES
                fi
            fi
        fi
        TPS=`cat tps_report`
        if [ `echo "$TPS < $TPS_BASE" | bc` -eq 1  ]; then
            collectLogs $NODES $TPS
        fi
        echo $TPS >> transferTPS_report
    done
    
    buildMarkDownCode
}

officialBenchmark()
{
    ### official bin benchmark
    echo -e "## official bin benchmark\n" >> report
    ## 4-8 nodes, solidity, 50 times
    
    officialBinTest 4 50 false
    officialBinTest 5 50 false
    officialBinTest 6 50 false
    officialBinTest 7 50 false
    officialBinTest 8 50 false
    ## 4-8 nodes, precompile, 50 times
    
    officialBinTest 4 50 true
    officialBinTest 5 50 true
    officialBinTest 6 50 true
    officialBinTest 7 50 true
    officialBinTest 8 50 true
    
}

signPackageBenchmark()
{
    ### signPackage bin benchmark
    echo -e "## signPackage bin benchmark\n" >> report
    TPS_BASE=2000
    ## 4-8 nodes, solidity, 50 times
    signPackBinTest 4 50 false
    cat transferTPS_report | mutt -s "signPackBinTest 4 50 false finished"  -- 787622351@qq.com

    TPS_BASE=1500
    signPackBinTest 5 50 false
    cat transferTPS_report | mutt -s "signPackBinTest 5 50 false finished"  -- 787622351@qq.com

    TPS_BASE=1100
    signPackBinTest 6 50 false
    cat transferTPS_report | mutt -s "signPackBinTest 6 50 false finished"  -- 787622351@qq.com

    TPS_BASE=1000
    signPackBinTest 7 50 false
    cat transferTPS_report | mutt -s "signPackBinTest 7 50 false finished"  -- 787622351@qq.com

    TPS_BASE=900
    signPackBinTest 8 50 false
    cat transferTPS_report | mutt -s "signPackBinTest 8 50 false finished"  -- 787622351@qq.com
    ## 4 nodes, precompile, 50 times
    TPS_BASE=2200
    signPackBinTest 4 50 true
    cat transferTPS_report | mutt -s "signPackBinTest 4 50 true finished"  -- 787622351@qq.com

    TPS_BASE=1800
    signPackBinTest 5 50 true
    cat transferTPS_report | mutt -s "signPackBinTest 5 50 true finished"  -- 787622351@qq.com

    TPS_BASE=1500
    signPackBinTest 6 50 true
    cat transferTPS_report | mutt -s "signPackBinTest 6 50 true finished"  -- 787622351@qq.com

    TPS_BASE=1100
    signPackBinTest 7 50 true
    cat transferTPS_report | mutt -s "signPackBinTest 7 50 true finished"  -- 787622351@qq.com
    
    TPS_BASE=1000
    signPackBinTest 8 50 true
    cat transferTPS_report | mutt -s "signPackBinTest 8 50 true finished"  -- 787622351@qq.com
}

echo -e "# Benchmark Experiment Report\n" > report

if [ $SIGNPACK_BENCHMARK = true ] ; then
    signPackageBenchmark
fi

if [ $OFFICIAL_BENCHMARK = true ] ; then
    officialBenchmark
fi

cat << EOF > README
OFFICIAL_BENCHMARK=$OFFICIAL_BENCHMARK
SIGNPACK_BENCHMARK=$SIGNPACK_BENCHMARK
DEBUG=$DEBUG

REMOTE=$REMOTE
EOF

TIME=$(date "+%Y%m%d_%H%M%S")
mkdir -p "tps_logs_$TIME"
mv ./logs_* ./"tps_logs_$TIME"
mv report ./"tps_logs_$TIME"
mv README ./"tps_logs_$TIME"
tar -czf ./tps.tar.gz ./"tps_logs_$TIME"
cat ./"tps_logs_$TIME"/report | mutt -s "tps test finished" -a /home/bc/consensus/tps.tar.gz -- 787622351@qq.com
rm -rf tps.tar.gz
