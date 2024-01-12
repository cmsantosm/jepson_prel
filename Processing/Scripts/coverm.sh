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
path=/home/csantosm/jepson/bowtie/alignments/

./coverm contig -m trimmed_mean -b ${path}*.bam > ${path}votu.tmean.tsv
./coverm contig -m trimmed_mean --min-covered-fraction 0.75 -b ${path}*.bam > ${path}votu75.tmean.tsv

./coverm contig -m count -b ${path}*.bam > ${path}votu.count.tsv
./coverm contig -m count --min-covered-fraction 0.75 -b ${path}*.bam > ${path}votu75.count.tsv

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed