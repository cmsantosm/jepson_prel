#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=instrain
#SBATCH --nodes=1
#SBATCH -t 124:00:00
#SBATCH --ntasks=6
#SBATCH --mem=64GB
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#activate personal conda env
source /home/csantosm/initconda
conda activate INSTRAIN

sample=${1}
cd /home/csantosm/jepson/instrain

inStrain profile ../bowtie/alignments/${sample}.cdhit.sI.bam \
../bowtie/votu_cdhit.fa \
-o ${sample} \
-p 6 \
-g ../prodigal/votu_cdhit.prodigal.fna \
-s ./votu_cdhit.stb \
--pairing_filter all_reads \
--skip_plot_generation

#getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed