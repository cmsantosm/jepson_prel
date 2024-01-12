#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=cdhit
#SBATCH --nodes=1
#SBATCH -t 96:00:00
#SBATCH --ntasks=24
#SBATCH --mem=64GB
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# loading modules
module load cdhit

cd /home/csantosm/software/cdhit-master/psi-cd-hit
./psi-cd-hit.pl -i /home/csantosm/jepson/cdhit/good.vib.contigs.fna \
-o /home/csantosm/jepson/cdhit/votu_cdhit.fa \
-c 0.95 -G 1 -g 1 -prog blastn -circle 1 \
-exec local -para 6 -blp 4 -rs 500

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
