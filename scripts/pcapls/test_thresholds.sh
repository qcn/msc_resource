#!/bin/bash

for threshold in $(seq 0.3 0.01 0.9)
do
    Rscript singleplsmodel.r $threshold > results/scoredplsmodel_t$threshold.out
    Rscript singlepcamodel.r $threshold > results/scoredpcamodel_t$threshold.out
done
