#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=bt2ref
#SBATCH --nodes=1
#SBATCH -t 12:00:00
#SBATCH --ntasks=1
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

module load bowtie2

cd /home/csantosm/jepson/bowtie/ref/

bowtie2-build ../votu_cdhit.fa votu_cdhit

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed