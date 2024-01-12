#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=megahit
#SBATCH --nodes=1
#SBATCH -t 12:00:00
#SBATCH --ntasks=24
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# loading modules
module load megahit

# move to rawreads folder
cd /home/csantosm/jepson/reads/
sample=${1}

megahit -1 ./rmphix1/${sample}_R1_rmphix.fq.gz \
-2 ./rmphix1/${sample}_R2_rmphix.fq.gz \
-r ./rmphix_unpaired1/${sample}_R1_rmphix_unpaired.fq.gz,./rmphix_unpaired1/${sample}_R2_rmphix_unpaired.fq.gz \
-o ../megahit_tmp/${sample} \
--out-prefix ${sample} \
--min-contig-len 10000 --presets meta-large \
-t 24 --continue

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
