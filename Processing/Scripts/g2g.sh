#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=g2g
#SBATCH --nodes=1
#SBATCH -t 1:00:00
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate VCONTACT2

cd /home/csantosm/jepson/vcontact/

vcontact2_gene2genome -p ../prodigal/votu_cdhit.prodigal.faa  \
-o ./votu_cdhit.gene2genome.csv \
-s Prodigal-FAA

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
