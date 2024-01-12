#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=inSt_compare
#SBATCH --nodes=1
#SBATCH -t 124:00:00
#SBATCH --ntasks=24
#SBATCH --mem=64GB
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#activate personal conda env
source /home/csantosm/initconda
conda activate INSTRAIN

cd /home/csantosm/jepson/instrain

inStrain compare -i *V* \
-o compare_all \
-p 24

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
