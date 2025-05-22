make install T=x86_64-native-linux-gcc
export RTE_SDK=/root/dpdk-19.11-0609
echo $(RTE_SDK)
make -C example
