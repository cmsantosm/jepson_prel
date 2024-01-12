#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=coverm
#SBATCH --nodes=1
#SBATCH -t 10:00:00
#SBATCH --ntasks=1
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

cd /home/csantosm/software/coverm-x86_64-unknown-linux-musl-0.6.1/
path=/home/csantosm/jepson/bowtie/

threshold=${1}

./coverm contig -m trimmed_mean -b ${path}/rare_bam/*rare.${threshold}.cdhit.sI.bam > ${path}/coverm/rare.${threshold}.votu.tmean.tsv
./coverm contig -m trimmed_mean --min-covered-fraction 0.75 -b ${path}/rare_bam/*rare.${threshold}.cdhit.sI.bam > ${path}/coverm/rare.${threshold}.votu.tmean75.tsv

./coverm contig -m count -b ${path}/rare_bam/*rare.${threshold}.cdhit.sI.bam > ${path}/coverm/rare.${threshold}.votu.count.tsv

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
