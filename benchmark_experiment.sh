#!/bin/bash

rm transferTPS_report addTPS_report

echo -e "# Benchmark Experiment Report\n" > report
### official bin benchmark
echo -e "## official bin benchmark\n" >> report
## 4 nodes, solidity, 100 times
echo -e "### 4 nodes, solidity, 100 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..100}  
do  
    bash official_build_chain.sh -n4
    cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 4 nodes, precompile, 100 times

echo -e "### 4 nodes, precompile, 100 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..100}  
do  
    bash official_build_chain.sh -n4 -p
    cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 8 nodes, precompile ,20 times

echo -e "### 8 nodes, precompile, 20 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..20}
do  
    bash official_build_chain.sh -n8 -p
    cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 16 nodes, precompile ,20 times

echo -e "### 16 nodes, precompile, 20 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..20}
do  
    bash official_build_chain.sh -n16 -p
    cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 32 nodes, precompile ,10 times

echo -e "### 32 nodes, precompile, 10 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..10}
do  
    bash official_build_chain.sh -n32 -p
    cat web3sdk-noParallel-buildOfficial/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-buildOfficial/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report


TPS=0
PRE_BASE=3000
SOLIDITY_BASE=2000

### signPackage bin benchmark
echo -e "## signPackage bin benchmark\n" >> report
## 4 nodes, solidity, 100 times
echo -e "### 4 nodes, solidity, 100 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..100}  
do  
    bash signPackage_build_chain.sh -n4
    cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    TPS=`cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}'`
    if [ `echo "$TPS < $SOLIDITY_BASE" | bc` -eq 1  ]; then
        cp ./nodes-signPackage/127.0.0.1/node0/log/* ./solidity_log_$i.log
    fi
    echo $TPS >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 4 nodes, precompile, 100 times

echo -e "### 4 nodes, precompile, 100 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..100}  
do  
    bash signPackage_build_chain.sh -n4 -p
    cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    TPS=`cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}'`
    if [ `echo "$TPS < $PRE_BASE" | bc` -eq 1  ]; then
        cp ./nodes-signPackage/127.0.0.1/node0/log/* ./precompile_4nodes_$i.log
    fi
    echo $TPS >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 8 nodes, precompile ,20 times

echo -e "### 8 nodes, precompile, 20 times\n" >> report
echo -e "\`\`\`shell\n" >> report
PRE_BASE=1500

for i in {1..20}
do  
    bash signPackage_build_chain.sh -n8 -p
    cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    TPS=`cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}'`
    if [ `echo "$TPS < $PRE_BASE" | bc` -eq 1  ]; then
        cp ./nodes-signPackage/127.0.0.1/node0/log/* ./precompile_8nodes_$i.log
    fi
    echo $TPS >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 16 nodes, precompile ,20 times

echo -e "### 16 nodes, precompile, 20 times\n" >> report
echo -e "\`\`\`shell\n" >> report
PRE_BASE=800

for i in {1..20}
do  
    bash signPackage_build_chain.sh -n16 -p
    cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    TPS=`cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}'`
    if [ `echo "$TPS < $PRE_BASE" | bc` -eq 1  ]; then
        cp ./nodes-signPackage/127.0.0.1/node0/log/* ./precompile_16nodes_$i.log
    fi
    echo $TPS >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

## 32 nodes, precompile ,10 times

echo -e "### 32 nodes, precompile, 10 times\n" >> report
echo -e "\`\`\`shell\n" >> report

for i in {1..10}
do  
    bash signPackage_build_chain.sh -n32 -p
    cat web3sdk-noParallel-signPackage/dist/addTPS | grep TPS | awk '{print $2}' >> addTPS_report
    cat web3sdk-noParallel-signPackage/dist/transferTPS | grep TPS | awk '{print $2}' >> transferTPS_report
done

echo -e "# addTPS\n" >> report
cat addTPS_report >> report
echo -e "\n\n# transferTPS\n" >> report
cat transferTPS_report >> report
echo -e "\n\`\`\`\n" >> report
rm addTPS_report transferTPS_report

