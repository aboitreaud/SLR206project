#!/bin/bash
dir=.
output=${dir}/output
bin=${bin}/bin
java=java
filename=extracted_data.csv
threads="1 2 3 4 5 6 7 8 9 10 11 12"
sizes="100 1000 10000"
writes="0 10 25 50 75 100" # update ratios
duration="2000"
warmup="0"

if [ ! -d "${output}" ]; then
  mkdir $output
fi
if [ ! -d "${output}/data" ]; then
  mkdir ${output}/data
fi

benchs="linkedlists.lockbased.CoarseGrainedListBasedSet linkedlists.lockbased.HandOverHandListBasedSet linkedlists.lockbased.LazyLinkedListSortedSet"
for bench in ${benchs}; do
  touch ${output}/data/${bench:22}_${filename}
  echo "throughput,threads,uratio,lsize" > ${output}/data/${bench:22}_${filename}
  for write in ${writes}; do
    for t in ${threads}; do
       for i in ${sizes}; do
         grep Throughput ${output}/log/${bench}-i${i}-u${write}-t${t}-w${warmup}-d${duration}.log | awk -v ORS="," '{print $3}' >> ${output}/data/${bench:22}_${filename}
         echo -n ${t} >> ${output}/data/${bench:22}_${filename}
         echo -n ',' >> ${output}/data/${bench:22}_${filename}
         echo -n ${write} >> ${output}/data/${bench:22}_${filename}
         echo -n ',' >> ${output}/data/${bench:22}_${filename}
         echo ${i} >> ${output}/data/${bench:22}_${filename}
       done
    done
  done
done
