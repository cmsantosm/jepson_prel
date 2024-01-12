#!/bin/bash
#SBATCH --job-name=qc_R
#SBATCH -D /home/csantosm/jepson_16s
#SBATCH -o /home/csantosm/jepson_16s/log/dada2.log
#SBATCH -e /home/csantosm/jepson_16s/err/dada2.err
#SBATCH -p bmm
#SBATCH -t 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# Load R
module load R

srun Rscript /home/csantosm/jepson_16s/scripts/dada_2.R

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed

