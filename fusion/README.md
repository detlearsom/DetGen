`test_validation` contains the inputs of the test validation experiments
`test` contains the rest of the experiments, except the wget experiments because the pcap files were larger than 500MB.

`modify_pcap.ipynb` is used to modify the pcap files using Python Scapy, to create the synthetic test validation inputs

`fusion_pipeline.ipynb` includes the log-packet fusion algorithm and all the experiments
