#!/bin/bash
#SBATCH -D /home/csantosm/jepson_16s/scripts/
#SBATCH --job-name=dmx2
#SBATCH --nodes=1
#SBATCH -t 12:00:00
#SBATCH --ntasks=1
#SBATCH --partition=bmm

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

# loading conda env
source /home/csantosm/initconda
conda activate PYTHON2.7

# running commands

cd /home/csantosm/jepson_16s/reads/raw_j2
python ~/BananaStand/demultiplex.py \
-f ./J16S2_S1_R1_001.fastq.gz \
-r ./J16S2_S1_R4_001.fastq.gz \
--I1 ./J16S2_S1_R2_001.fastq.gz \
--I2 ./J16S2_S1_R3_001.fastq.gz \
-m dmx2.map -p j2 -a "dada2"

# finished commands

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed

