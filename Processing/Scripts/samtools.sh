#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=samtools
#SBATCH --nodes=1
#SBATCH -t 10:00:00
#SBATCH --ntasks=48
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#load modules
module load samtools

sample=${1}

cd /home/csantosm/jepson/bowtie/alignments
samtools view -F 4 -bS ${sample}.cdhit.sam | samtools sort > ${sample}.cdhit.sI.bam
samtools index ${sample}.cdhit.sI.bam

rm ${sample}.cdhit.sam

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed