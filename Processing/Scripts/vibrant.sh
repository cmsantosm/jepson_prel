#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=vbrnt
#SBATCH --nodes=1
#SBATCH -t 12:00:00
#SBATCH --ntasks=4
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#activate personal conda env
source /home/csantosm/initconda
conda activate VIBRANT

cd /home/csantosm/jepson/
sample=${1}

VIBRANT_run.py -i ./megahit/renamed_contigs/${sample}.renamed.contigs.fa \
-folder ./vibrant/${sample}_vibrant \
-t 4 -f nucl -virome

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed