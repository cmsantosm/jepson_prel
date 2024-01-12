#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=bt2map
#SBATCH --nodes=1
#SBATCH -t 4:00:00
#SBATCH --ntasks=48
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#load modules
module load bowtie2
module load samtools

path=/home/csantosm/jepson/
sample=${1}

cd ${path}bowtie/ref

bowtie2 -x votu_cdhit -p 48 \
-1 ${path}reads/cat_rmphix/${sample}_R1_rmphix.fq.gz \
-2 ${path}reads/cat_rmphix/${sample}_R2_rmphix.fq.gz \
-S ${path}bowtie/alignments/${sample}.cdhit.sam \
--sensitive

cd ../alignments
samtools view -F 4 -bS ${sample}.cdhit.sam | samtools sort > ${sample}.cdhit.sI.bam
samtools index ${sample}.cdhit.sI.bam

rm ${sample}.cdhit.sam

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed