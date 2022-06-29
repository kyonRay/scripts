address=${1}
prompt="/apps>"
while true
do
 expect <<EOF
        set timeout 6000
             spawn bash start.sh group0 -pem account/ecdsa/${address}.pem

                expect "${prompt}" {send "getCommitteeInfo \r"}
                expect "${prompt}" {send "getProposalInfo 1 \r"}
                expect "${prompt}" {send "getDeployAuth \r"}
                expect "${prompt}" {send "setDeployAuthTypeProposal white_list \r"}
                expect "${prompt}" {send "deploy  HelloWorld\r"}
                expect "${prompt}" {send "getDeployAuth \r"}
                expect "${prompt}" {send "openDeployAuthProposal ${address} \r"}
                expect "${prompt}" {send "deploy  HelloWorld \r"}
                expect "${prompt}" {send "closeDeployAuthProposal  ${address} \r"}
                expect "${prompt}" {send "deploy  HelloWorld  \r"}
                expect "${prompt}" {send "openDeployAuthProposal  ${address}  \r"}
                expect "${prompt}" {send "deploy  HelloWorld  \r"}
                expect "${prompt}" {send "getContractAdmin 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 \r"}
                expect "${prompt}" {send "setDeployAuthTypeProposal black_list  \r"}
                expect "${prompt}" {send "openDeployAuthProposal ${address} \r"}
                expect "${prompt}" {send "deploy  HelloWorld \r"}
                expect "${prompt}" {send "setDeployAuthTypeProposal  white_list  \r"}
                expect "${prompt}" {send "closeDeployAuthProposal  ${address} \r"}
                expect "${prompt}" {send "deploy  HelloWorld  \r"}
                expect "${prompt}" {send "setDeployAuthTypeProposal black_list \r"}
                expect "${prompt}" {send "openDeployAuthProposal  ${address}  \r"}
                expect "${prompt}" {send "deploy  HelloWorld  \r"}
                expect "${prompt}" {send "setDeployAuthTypeProposal  white_list \r"}
                expect "${prompt}" {send "deploy HelloWorld \r"}
                expect "${prompt}" {send "resetAdminProposal  0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 ${address} \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "freezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "setMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" white_list  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "unfreezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "freezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "openMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "unfreezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "closeMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "unfreezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "setMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" black_list  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "freezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "closeMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "openMethodAuth 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "unfreezeContract 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 "set(string)" ${address}  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
                expect "${prompt}" {send "call HelloWorld 0x6849F21D1E455e9f0712b1e99Fa4FCD23758E8F1 set 123123  \r"}
        expect "${prompt}" {send "q\r"}
        expect eof

EOF
done



