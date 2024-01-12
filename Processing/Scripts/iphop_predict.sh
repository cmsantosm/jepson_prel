#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=iphop_predict
#SBATCH --nodes=1
#SBATCH -t 24:00:00
#SBATCH --mem=128GB
#SBATCH --ntasks=24
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate IPHOP

batch=${1}

iphop_db=/home/csantosm/databases/IPHOP_db/Sept_2021_pub

cd /home/csantosm/jepson/iphop

iphop predict --fa_file ./split_db/${batch}.fna --out_dir ./results/${batch} --db_dir ${iphop_db} --num_threads 24

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
