#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=bt2map
#SBATCH --nodes=1
#SBATCH -t 2:00:00
#SBATCH --ntasks=48
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#load modules
module load bowtie2
module load samtools

path=/home/csantosm/jepson/
sample=${1}

cd ${path}bowtie_tmp/all_ref

bowtie2 -x all_vibrant_drep -p 48 \
-1 ${path}reads/rmphix1/${sample}_R1_rmphix.fq.gz \
-2 ${path}reads/rmphix1/${sample}_R2_rmphix.fq.gz \
-S ${path}bowtie_tmp/sam/${sample}.vib.sam \
--sensitive

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
