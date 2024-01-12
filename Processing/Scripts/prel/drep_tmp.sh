#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=drep
#SBATCH --nodes=1
#SBATCH -t 72:00:00
#SBATCH --ntasks=24
#SBATCH --mem=32GB
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate DREP

treatment=${1}

cd /home/csantosm/jepson/drep_tmp/${treatment}


dRep dereplicate ./${treatment}_dRep \
-g ./split_contigs/*.fa \
--S_algorithm ANImf \
-sa 0.95 \
-nc 0.85 \
-l 10000 \
-N50W 0 \
-sizeW 1 \
--ignoreGenomeQuality \
--clusterAlg single \
-p 24

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed