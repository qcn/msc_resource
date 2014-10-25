#!/bin/bash

for threshold in $(seq 0.3 0.01 0.9)
do
    Rscript rounded_pls.r $threshold > results/rpls_t$threshold.out
    Rscript rounded_pcr.r $threshold > results/rpcr_t$threshold.out
done
