for file in *rpcr_t*.out
do
    threshold=`tail -15 $file | head -1 | cut -f 2 -d " " | cut -f 2 -d "\""`
    correct=`tail -13 $file | head -1 | cut -f 2 -d " "`
    corr_extras=`tail -11 $file | head -1 | cut -f 2 -d " "`
    incorrect=`tail -9 $file | head -1 | cut -f 2 -d " "`
    nothing=`tail -7 $file | head -1 | cut -f 2 -d " "`
    all_incorrect=`echo "$corr_extras + $incorrect + $nothing" | bc`
    failed_correct=`tail -5 $file | head -1 | cut -f 2 -d " "`
    failed_incorrect=`tail -3 $file | head -1 | cut -f 2 -d " "`
    echo "$threshold,$correct,$all_incorrect,$failed_correct,$failed_incorrect"
done
