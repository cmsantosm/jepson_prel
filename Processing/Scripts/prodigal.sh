#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=prodigal
#SBATCH --nodes=1
#SBATCH -t 24:00:00
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate PRODIGAL

cd /home/csantosm/jepson/prodigal/

prodigal -i /home/csantosm/jepson/cdhit/votu_cdhit.fa -d votu_cdhit.prodigal.fna -a votu_cdhit.prodigal.faa -p meta

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed