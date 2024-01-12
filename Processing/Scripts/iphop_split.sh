#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=iphop_split
#SBATCH --nodes=1
#SBATCH -t 1:00:00
#SBATCH --ntasks=1
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate IPHOP

set=${1}

full_db=/home/csantosm/jepson/cdhit/votu_cdhit.fa
split_db=/home/csantosm/jepson/iphop/split_db

iphop split --input_file ${full_db} --split_dir ${split_db}

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
