#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=fastqc
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --ntasks=8
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# loading modules
module load fastqc

# running commands
path=/home/csantosm/jepson/
sample=${1}

fastqc -t 8 -o ${path}fastqc/cat_rmphix/ ${path}reads/cat_rmphix/${sample}_R1_rmphix.fq.gz
fastqc -t 8 -o ${path}fastqc/cat_rmphix/ ${path}reads/cat_rmphix/${sample}_R2_rmphix.fq.gz

# finished commands

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
