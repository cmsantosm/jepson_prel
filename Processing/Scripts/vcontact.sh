#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=vcontact
#SBATCH --nodes=1
#SBATCH -t 168:00:00
#SBATCH --ntasks=16
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

source /home/csantosm/initconda
conda activate VCONTACT2

cd /home/csantosm/jepson/vcontact/

vcontact2 --raw-proteins ../prodigal/votu_cdhit.prodigal.faa \
--rel-mode 'Diamond' \
--db 'ProkaryoticViralRefSeq85-Merged' \
--proteins-fp votu_cdhit.gene2genome.csv \
--pcs-mode MCL \
--vcs-mode ClusterONE \
--threads 16 \
--c1-bin /home/csantosm/miniconda3/bin/cluster_one-1.0.jar \
--output-dir vcontact_out


# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
