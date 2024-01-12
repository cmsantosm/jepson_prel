#!/bin/bash
#SBATCH -D /home/csantosm/jepson/scripts/
#SBATCH --job-name=samview
#SBATCH --nodes=1
#SBATCH -t 24:00:00
#SBATCH --ntasks=10
#SBATCH --partition=bmh

# for calculating the amount of time the job takes
begin=`date +%s`
echo $HOSTNAME

#load modules
module load samtools

sample=${1}
threshold=${2}

factor=$(grep ^$sample$'\t' /home/csantosm/jepson/bowtie/${threshold}_rarefaction_factor.tsv | cut -f2)

cd /home/csantosm/jepson/bowtie/rare_bam

if [[ $factor -eq 1 ]]
then
  cp ../alignments/${sample}.cdhit.sI.bam ./${sample}.rare.${threshold}.cdhit.sI.bam
  cp ../alignments/${sample}.cdhit.sI.bam.bai ./${sample}.rare.${threshold}.cdhit.sI.bam.bai
else
  samtools view -b -s ${factor} -@ 10 ../alignments/${sample}.cdhit.sI.bam | samtools sort > ${sample}.rare.${threshold}.cdhit.sI.bam
  samtools index ${sample}.rare.${threshold}.cdhit.sI.bam
fi

# getting end time to calculate time elapsed
end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed
