#!/bin/bash
#SBATCH --job-name=qc_R
#SBATCH -D /home/csantosm/jepson_16s
#SBATCH -o /home/csantosm/jepson_16s/qual_plots/log/qc_R.log
#SBATCH -e /home/csantosm/jepson_16s/qual_plots/err/qc_R.err
#SBATCH -p bmm
#SBATCH -t 1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# Load R
module load R

srun Rscript /home/csantosm/jepson_16s/scripts/qc_raw.R

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed

