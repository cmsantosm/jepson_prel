#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=cat_zip
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --ntasks=8
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# running commands
sample=${1}

cd /home/csantosm/jepson/reads/

cat rmphix*/${sample}*_R1_rmphix.fq.gz > cat_rmphix/${sample}_R1_rmphix.fq.gz
rm rmphix*/${sample}*_R1_rmphix.fq.gz

cat rmphix_unpaired*/${sample}*_R1_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R1_rmphix_unpaired.fq.gz
rm rmphix_unpaired*/${sample}*_R1_rmphix_unpaired.fq.gz

cat rmphix*/${sample}*_R2_rmphix.fq.gz > cat_rmphix/${sample}_R2_rmphix.fq.gz
rm rmphix*/${sample}*_R2_rmphix.fq.gz

cat rmphix_unpaired*/${sample}*_R2_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R2_rmphix_unpaired.fq.gz
rm rmphix_unpaired*/${sample}*_R2_rmphix_unpaired.fq.gz

# finished commands

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
