#!/bin/bash

dir=.
output=${dir}/output
bin=${bin}/bin
java=java

threads="1 2 3 4 5 6 7 8 9 10 11 12"
sizes="100 1000 10000"
writes="0 10 25 50 75 100" # update ratios
duration="2000"
warmup="0"

CP=bin
MAINCLASS=contention.benchmark.Test

if [ ! -d "${output}" ]; then
  mkdir $output
fi
if [ ! -d "${output}/log" ]; then
#  rm -rf ${output}/log
  mkdir ${output}/log
fi

benchs="linkedlists.lockbased.CoarseGrainedListBasedSet linkedlists.lockbased.HandOverHandListBasedSet linkedlists.lockbased.LazyLinkedListSortedSet"

for bench in ${benchs}; do
  for write in ${writes}; do
    for t in ${threads}; do
       for i in ${sizes}; do
#         r=`echo  "2*${i}" | bc`
         r=$((2*${i}))
         out=${output}/log/${bench}-i${i}-u${write}-t${t}-w${warmup}-d${duration}.log
         echo "${java} -cp ${CP} ${MAINCLASS} -W ${warmup} -u ${write} -d ${duration} -t ${t} -i ${i} -r ${r} -b ${bench}"
         ${java} -cp ${CP} ${MAINCLASS} -W ${warmup} -u ${write} -d ${duration} -t ${t} -i ${i} -r ${r} -b ${bench} 2>&1 > ${out}
       done
    done
  done
done
