## Organizing files
I had originally saved the raw reads from the two sequencing batches separately. To make life easier, I am going to compile them in the same raw directories so that they can be processes simultaneously. However, I'll save the info of the batch identity in case it becomes necessary

```bash
cd /home/csantosm/jepson/
mkdir seq_batch_info
cd seq_batch_info

ls -1 ../reads/batch1/raw1/ > batch1_raw1.txt
ls -1 ../reads/batch1/raw2/ > batch1_raw2.txt
ls -1 ../reads/batch1/raw3/ > batch1_raw3.txt
ls -1 ../reads/batch1/raw4/ > batch1_raw4.txt
ls -1 ../reads/batch1/raw5/ > batch1_raw5.txt
ls -1 ../reads/batch1/raw6/ > batch1_raw6.txt

ls -1 ../reads/batch2/raw1/ > batch2_raw1.txt
ls -1 ../reads/batch2/raw2/ > batch2_raw2.txt
ls -1 ../reads/batch2/raw3/ > batch2_raw3.txt
```
Some of the raw directories have extra files (e.g. md5 files) that need to be moved somewhere else

```bash
cd /home/csantosm/jepson/reads
mv batch1/raw3/laneBarcode* other_batch1/other3/
mv batch1/raw4/laneBarcode* other_batch1/other4/
mv batch1/raw5/laneBarcode* other_batch1/other5/
mv batch1/raw6/laneBarcode* other_batch1/other6/

mv batch1/raw3/*md5 other_batch1/other3/
mv batch1/raw4/*md5 other_batch1/other4/
mv batch1/raw5/*md5 other_batch1/other5/
mv batch1/raw6/*md5 other_batch1/other6/

mv batch1/raw3/Undetermined* other_batch1/other3/
mv batch1/raw4/Undetermined* other_batch1/other4/
mv batch1/raw5/Undetermined* other_batch1/other5/
mv batch1/raw6/Undetermined* other_batch1/other6/

mv batch2/raw1/laneBarcode* other_batch2/other1/
mv batch2/raw2/laneBarcode* other_batch2/other2/
mv batch2/raw3/laneBarcode* other_batch2/other3/

mv batch2/raw1/*md5 other_batch2/other1/
mv batch2/raw2/*md5 other_batch2/other2/
mv batch2/raw3/*md5 other_batch2/other3/

mv batch2/raw1/Undetermined* other_batch2/other1/
mv batch2/raw2/Undetermined* other_batch2/other2/
mv batch2/raw3/Undetermined* other_batch2/other3/
```

Moving files to centralized raw folders

```bash
cd /home/csantosm/jepson/reads
mkdir raw1 raw2 raw3 raw4 raw5 raw6

mv -v batch1/raw1/* raw1
mv -v batch2/raw1/* raw1

mv -v batch1/raw2/* raw2
mv -v batch2/raw2/* raw2

mv -v batch1/raw3/* raw3
mv -v batch2/raw3/* raw3

mv -v batch1/raw4/* raw4

mv -v batch1/raw5/* raw5

mv -v batch1/raw6/* raw6
```

## Generating ID files

```bash
cd /home/csantosm/jepson/reads/

ls -1 raw1/ | cut -f1,2,3 -d_ | sort | uniq > ../jep1_libIDs.txt
ls -1 raw2/ | cut -f1,2,3 -d_ | sort | uniq > ../jep2_libIDs.txt
ls -1 raw3/ | cut -f1,2,3 -d_ | sort | uniq > ../jep3_libIDs.txt
ls -1 raw4/ | cut -f1,2,3 -d_ | sort | uniq > ../jep4_libIDs.txt
ls -1 raw5/ | cut -f1,2,3 -d_ | sort | uniq > ../jep5_libIDs.txt
ls -1 raw6/ | cut -f1,2,3 -d_ | sort | uniq > ../jep6_libIDs.txt
```
## Generating folder structure for quality Filtering

```bash
cd /home/csantosm/jepson/reads/
mkdir log err
mkdir trimmed1 unpaired1 rmphix1 rmphix_unpaired1 stats1
mkdir trimmed2 unpaired2 rmphix2 rmphix_unpaired2 stats2
mkdir trimmed3 unpaired3 rmphix3 rmphix_unpaired3 stats3
mkdir trimmed4 unpaired4 rmphix4 rmphix_unpaired4 stats4
mkdir trimmed5 unpaired5 rmphix5 rmphix_unpaired5 stats5
mkdir trimmed6 unpaired6 rmphix6 rmphix_unpaired6 stats6
```

## Running quality Filtering

The strategy to run the program is to provide both the number of sequencing batch and the libraryID to the script. That way, there's no need to write a script per sequencing batch

```bash
cd /home/csantosm/jepson/scripts/

for sample in $(<../jep1_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf1.log --error=../reads/err/${sample}.qf1.err qual_filter.sh 1 $sample
done

for sample in $(<../jep2_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf2.log --error=../reads/err/${sample}.qf2.err qual_filter.sh 2 $sample
done

for sample in $(<../jep3_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf3.log --error=../reads/err/${sample}.qf3.err qual_filter.sh 3 $sample
done

for sample in $(<../jep4_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf4.log --error=../reads/err/${sample}.qf4.err qual_filter.sh 4 $sample
done

for sample in $(<../jep5_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf5.log --error=../reads/err/${sample}.qf5.err qual_filter.sh 5 $sample
done

for sample in $(<../jep6_libIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qf6.log --error=../reads/err/${sample}.qf6.err qual_filter.sh 6 $sample
done

#Rerunning with longer requested time
sbatch --output=../reads/log/JVD208_S431_L004.qf3.log --error=../reads/err/JVD208_S431_L004.qf3.err qual_filter.sh 3 JVD208_S431_L004
```

## Concatentating filtered reads
```bash
cd /home/csantosm/jepson/reads
mkdir cat_rmphix cat_rmphix_unpaired

for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../reads/log/${sample}.cat.log --error=../reads/err/${sample}.cat.err cat_rmphix.sh $sample
done
```

## Running fastQC on concatenated filtered reads
```bash
cd /home/csantosm/jepson/
mkdir fastqc
cd fastqc
mkdir err log cat_rmphix parsed

for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../fastqc/log/${sample}.cat.log --error=../fastqc/err/${sample}.cat.err fastqc.sh $sample
done
```

Some samples failed when running fastqc because the file was likely truncated. I'm rerunning the quality filtering just to make sure that nothing weird happen when concatenating the rmphix files

```bash
for sample in $(<./redoIDs.txt)
do
  grep ${sample}_ jep*libIDs.txt >> redolibIDs.txt
done
```


```bash
sbatch --output=../reads/log/qf1.JVD20_S260_L002.log --error=../reads/err/qf1.JVD20_S260_L002.err qual_filter.sh 1 JVD20_S260_L002
sbatch --output=../reads/log/qf2.JVD20_S324_L004.log --error=../reads/err/qf2.JVD20_S324_L004.err qual_filter.sh 2 JVD20_S324_L004
sbatch --output=../reads/log/qf3.JVD20_S231_L003.log --error=../reads/err/qf3.JVD20_S231_L003.err qual_filter.sh 3 JVD20_S231_L003
sbatch --output=../reads/log/qf4.JVD20_S231_L002.log --error=../reads/err/qf4.JVD20_S231_L002.err qual_filter.sh 4 JVD20_S231_L002
sbatch --output=../reads/log/qf5.JVD20_S231_L001.log --error=../reads/err/qf5.JVD20_S231_L001.err qual_filter.sh 5 JVD20_S231_L001
sbatch --output=../reads/log/qf1.JVD21_S33_L002.log --error=../reads/err/qf1.JVD21_S33_L002.err qual_filter.sh 1 JVD21_S33_L002
sbatch --output=../reads/log/qf2.JVD21_S97_L004.log --error=../reads/err/qf2.JVD21_S97_L004.err qual_filter.sh 2 JVD21_S97_L004
sbatch --output=../reads/log/qf3.JVD21_S4_L003.log --error=../reads/err/qf3.JVD21_S4_L003.err qual_filter.sh 3 JVD21_S4_L003
sbatch --output=../reads/log/qf4.JVD21_S4_L002.log --error=../reads/err/qf4.JVD21_S4_L002.err qual_filter.sh 4 JVD21_S4_L002
sbatch --output=../reads/log/qf5.JVD21_S4_L001.log --error=../reads/err/qf5.JVD21_S4_L001.err qual_filter.sh 5 JVD21_S4_L001
sbatch --output=../reads/log/qf1.JVD22_S261_L002.log --error=../reads/err/qf1.JVD22_S261_L002.err qual_filter.sh 1 JVD22_S261_L002
sbatch --output=../reads/log/qf2.JVD22_S325_L004.log --error=../reads/err/qf2.JVD22_S325_L004.err qual_filter.sh 2 JVD22_S325_L004
sbatch --output=../reads/log/qf3.JVD22_S232_L003.log --error=../reads/err/qf3.JVD22_S232_L003.err qual_filter.sh 3 JVD22_S232_L003
sbatch --output=../reads/log/qf4.JVD22_S232_L002.log --error=../reads/err/qf4.JVD22_S232_L002.err qual_filter.sh 4 JVD22_S232_L002
sbatch --output=../reads/log/qf5.JVD22_S232_L001.log --error=../reads/err/qf5.JVD22_S232_L001.err qual_filter.sh 5 JVD22_S232_L001
sbatch --output=../reads/log/qf1.JVN1_S132_L002.log --error=../reads/err/qf1.JVN1_S132_L002.err qual_filter.sh 1 JVN1_S132_L002
sbatch --output=../reads/log/qf2.JVN1_S196_L004.log --error=../reads/err/qf2.JVN1_S196_L004.err qual_filter.sh 2 JVN1_S196_L004
sbatch --output=../reads/log/qf3.JVN1_S103_L003.log --error=../reads/err/qf3.JVN1_S103_L003.err qual_filter.sh 3 JVN1_S103_L003
sbatch --output=../reads/log/qf4.JVN1_S103_L002.log --error=../reads/err/qf4.JVN1_S103_L002.err qual_filter.sh 4 JVN1_S103_L002
sbatch --output=../reads/log/qf5.JVN1_S103_L001.log --error=../reads/err/qf5.JVN1_S103_L001.err qual_filter.sh 5 JVN1_S103_L001
sbatch --output=../reads/log/qf1.JVN11_S142_L002.log --error=../reads/err/qf1.JVN11_S142_L002.err qual_filter.sh 1 JVN11_S142_L002
sbatch --output=../reads/log/qf2.JVN11_S206_L004.log --error=../reads/err/qf2.JVN11_S206_L004.err qual_filter.sh 2 JVN11_S206_L004
sbatch --output=../reads/log/qf3.JVN11_S113_L003.log --error=../reads/err/qf3.JVN11_S113_L003.err qual_filter.sh 3 JVN11_S113_L003
sbatch --output=../reads/log/qf4.JVN11_S113_L002.log --error=../reads/err/qf4.JVN11_S113_L002.err qual_filter.sh 4 JVN11_S113_L002
sbatch --output=../reads/log/qf5.JVN11_S113_L001.log --error=../reads/err/qf5.JVN11_S113_L001.err qual_filter.sh 5 JVN11_S113_L001
sbatch --output=../reads/log/qf1.JVN12_S143_L002.log --error=../reads/err/qf1.JVN12_S143_L002.err qual_filter.sh 1 JVN12_S143_L002
sbatch --output=../reads/log/qf2.JVN12_S207_L004.log --error=../reads/err/qf2.JVN12_S207_L004.err qual_filter.sh 2 JVN12_S207_L004
sbatch --output=../reads/log/qf3.JVN12_S114_L003.log --error=../reads/err/qf3.JVN12_S114_L003.err qual_filter.sh 3 JVN12_S114_L003
sbatch --output=../reads/log/qf4.JVN12_S114_L002.log --error=../reads/err/qf4.JVN12_S114_L002.err qual_filter.sh 4 JVN12_S114_L002
sbatch --output=../reads/log/qf5.JVN12_S114_L001.log --error=../reads/err/qf5.JVN12_S114_L001.err qual_filter.sh 5 JVN12_S114_L001
sbatch --output=../reads/log/qf6.JVN12_S325_L001.log --error=../reads/err/qf6.JVN12_S325_L001.err qual_filter.sh 6 JVN12_S325_L001
sbatch --output=../reads/log/qf1.JVN14_S145_L002.log --error=../reads/err/qf1.JVN14_S145_L002.err qual_filter.sh 1 JVN14_S145_L002
sbatch --output=../reads/log/qf2.JVN14_S209_L004.log --error=../reads/err/qf2.JVN14_S209_L004.err qual_filter.sh 2 JVN14_S209_L004
sbatch --output=../reads/log/qf3.JVN14_S116_L003.log --error=../reads/err/qf3.JVN14_S116_L003.err qual_filter.sh 3 JVN14_S116_L003
sbatch --output=../reads/log/qf4.JVN14_S116_L002.log --error=../reads/err/qf4.JVN14_S116_L002.err qual_filter.sh 4 JVN14_S116_L002
sbatch --output=../reads/log/qf5.JVN14_S116_L001.log --error=../reads/err/qf5.JVN14_S116_L001.err qual_filter.sh 5 JVN14_S116_L001
sbatch --output=../reads/log/qf1.JVN15_S146_L002.log --error=../reads/err/qf1.JVN15_S146_L002.err qual_filter.sh 1 JVN15_S146_L002
sbatch --output=../reads/log/qf2.JVN15_S210_L004.log --error=../reads/err/qf2.JVN15_S210_L004.err qual_filter.sh 2 JVN15_S210_L004
sbatch --output=../reads/log/qf3.JVN15_S117_L003.log --error=../reads/err/qf3.JVN15_S117_L003.err qual_filter.sh 3 JVN15_S117_L003
sbatch --output=../reads/log/qf4.JVN15_S117_L002.log --error=../reads/err/qf4.JVN15_S117_L002.err qual_filter.sh 4 JVN15_S117_L002
sbatch --output=../reads/log/qf5.JVN15_S117_L001.log --error=../reads/err/qf5.JVN15_S117_L001.err qual_filter.sh 5 JVN15_S117_L001
sbatch --output=../reads/log/qf1.JVN17_S148_L002.log --error=../reads/err/qf1.JVN17_S148_L002.err qual_filter.sh 1 JVN17_S148_L002
sbatch --output=../reads/log/qf2.JVN17_S212_L004.log --error=../reads/err/qf2.JVN17_S212_L004.err qual_filter.sh 2 JVN17_S212_L004
sbatch --output=../reads/log/qf3.JVN17_S119_L003.log --error=../reads/err/qf3.JVN17_S119_L003.err qual_filter.sh 3 JVN17_S119_L003
sbatch --output=../reads/log/qf4.JVN17_S119_L002.log --error=../reads/err/qf4.JVN17_S119_L002.err qual_filter.sh 4 JVN17_S119_L002
sbatch --output=../reads/log/qf5.JVN17_S119_L001.log --error=../reads/err/qf5.JVN17_S119_L001.err qual_filter.sh 5 JVN17_S119_L001
sbatch --output=../reads/log/qf1.JVN18_S149_L002.log --error=../reads/err/qf1.JVN18_S149_L002.err qual_filter.sh 1 JVN18_S149_L002
sbatch --output=../reads/log/qf2.JVN18_S213_L004.log --error=../reads/err/qf2.JVN18_S213_L004.err qual_filter.sh 2 JVN18_S213_L004
sbatch --output=../reads/log/qf3.JVN18_S120_L003.log --error=../reads/err/qf3.JVN18_S120_L003.err qual_filter.sh 3 JVN18_S120_L003
sbatch --output=../reads/log/qf4.JVN18_S120_L002.log --error=../reads/err/qf4.JVN18_S120_L002.err qual_filter.sh 4 JVN18_S120_L002
sbatch --output=../reads/log/qf5.JVN18_S120_L001.log --error=../reads/err/qf5.JVN18_S120_L001.err qual_filter.sh 5 JVN18_S120_L001
sbatch --output=../reads/log/qf6.JVN18_S320_L001.log --error=../reads/err/qf6.JVN18_S320_L001.err qual_filter.sh 6 JVN18_S320_L001
sbatch --output=../reads/log/qf1.JVN19_S150_L002.log --error=../reads/err/qf1.JVN19_S150_L002.err qual_filter.sh 1 JVN19_S150_L002
sbatch --output=../reads/log/qf2.JVN19_S214_L004.log --error=../reads/err/qf2.JVN19_S214_L004.err qual_filter.sh 2 JVN19_S214_L004
sbatch --output=../reads/log/qf3.JVN19_S121_L003.log --error=../reads/err/qf3.JVN19_S121_L003.err qual_filter.sh 3 JVN19_S121_L003
sbatch --output=../reads/log/qf4.JVN19_S121_L002.log --error=../reads/err/qf4.JVN19_S121_L002.err qual_filter.sh 4 JVN19_S121_L002
sbatch --output=../reads/log/qf5.JVN19_S121_L001.log --error=../reads/err/qf5.JVN19_S121_L001.err qual_filter.sh 5 JVN19_S121_L001
sbatch --output=../reads/log/qf6.JVN19_S333_L001.log --error=../reads/err/qf6.JVN19_S333_L001.err qual_filter.sh 6 JVN19_S333_L001
sbatch --output=../reads/log/qf1.JVN2_S133_L002.log --error=../reads/err/qf1.JVN2_S133_L002.err qual_filter.sh 1 JVN2_S133_L002
sbatch --output=../reads/log/qf2.JVN2_S197_L004.log --error=../reads/err/qf2.JVN2_S197_L004.err qual_filter.sh 2 JVN2_S197_L004
sbatch --output=../reads/log/qf3.JVN2_S104_L003.log --error=../reads/err/qf3.JVN2_S104_L003.err qual_filter.sh 3 JVN2_S104_L003
sbatch --output=../reads/log/qf4.JVN2_S104_L002.log --error=../reads/err/qf4.JVN2_S104_L002.err qual_filter.sh 4 JVN2_S104_L002
sbatch --output=../reads/log/qf5.JVN2_S104_L001.log --error=../reads/err/qf5.JVN2_S104_L001.err qual_filter.sh 5 JVN2_S104_L001
sbatch --output=../reads/log/qf1.JVN20_S151_L002.log --error=../reads/err/qf1.JVN20_S151_L002.err qual_filter.sh 1 JVN20_S151_L002
sbatch --output=../reads/log/qf2.JVN20_S215_L004.log --error=../reads/err/qf2.JVN20_S215_L004.err qual_filter.sh 2 JVN20_S215_L004
sbatch --output=../reads/log/qf3.JVN20_S122_L003.log --error=../reads/err/qf3.JVN20_S122_L003.err qual_filter.sh 3 JVN20_S122_L003
sbatch --output=../reads/log/qf4.JVN20_S122_L002.log --error=../reads/err/qf4.JVN20_S122_L002.err qual_filter.sh 4 JVN20_S122_L002
sbatch --output=../reads/log/qf5.JVN20_S122_L001.log --error=../reads/err/qf5.JVN20_S122_L001.err qual_filter.sh 5 JVN20_S122_L001
sbatch --output=../reads/log/qf1.JVN45_S176_L002.log --error=../reads/err/qf1.JVN45_S176_L002.err qual_filter.sh 1 JVN45_S176_L002
sbatch --output=../reads/log/qf2.JVN45_S240_L004.log --error=../reads/err/qf2.JVN45_S240_L004.err qual_filter.sh 2 JVN45_S240_L004
sbatch --output=../reads/log/qf3.JVN45_S147_L003.log --error=../reads/err/qf3.JVN45_S147_L003.err qual_filter.sh 3 JVN45_S147_L003
sbatch --output=../reads/log/qf4.JVN45_S147_L002.log --error=../reads/err/qf4.JVN45_S147_L002.err qual_filter.sh 4 JVN45_S147_L002
sbatch --output=../reads/log/qf5.JVN45_S147_L001.log --error=../reads/err/qf5.JVN45_S147_L001.err qual_filter.sh 5 JVN45_S147_L001
sbatch --output=../reads/log/qf1.JVN5_S136_L002.log --error=../reads/err/qf1.JVN5_S136_L002.err qual_filter.sh 1 JVN5_S136_L002
sbatch --output=../reads/log/qf2.JVN5_S200_L004.log --error=../reads/err/qf2.JVN5_S200_L004.err qual_filter.sh 2 JVN5_S200_L004
sbatch --output=../reads/log/qf3.JVN5_S107_L003.log --error=../reads/err/qf3.JVN5_S107_L003.err qual_filter.sh 3 JVN5_S107_L003
sbatch --output=../reads/log/qf4.JVN5_S107_L002.log --error=../reads/err/qf4.JVN5_S107_L002.err qual_filter.sh 4 JVN5_S107_L002
sbatch --output=../reads/log/qf5.JVN5_S107_L001.log --error=../reads/err/qf5.JVN5_S107_L001.err qual_filter.sh 5 JVN5_S107_L001
sbatch --output=../reads/log/qf1.JVN6_S137_L002.log --error=../reads/err/qf1.JVN6_S137_L002.err qual_filter.sh 1 JVN6_S137_L002
sbatch --output=../reads/log/qf2.JVN6_S201_L004.log --error=../reads/err/qf2.JVN6_S201_L004.err qual_filter.sh 2 JVN6_S201_L004
sbatch --output=../reads/log/qf3.JVN6_S108_L003.log --error=../reads/err/qf3.JVN6_S108_L003.err qual_filter.sh 3 JVN6_S108_L003
sbatch --output=../reads/log/qf4.JVN6_S108_L002.log --error=../reads/err/qf4.JVN6_S108_L002.err qual_filter.sh 4 JVN6_S108_L002
sbatch --output=../reads/log/qf5.JVN6_S108_L001.log --error=../reads/err/qf5.JVN6_S108_L001.err qual_filter.sh 5 JVN6_S108_L001

 
for sample in $(<../redoIDs.txt)
do
  rm cat_rmphix/${sample}_R1_rmphix.fq.gz
  rm cat_rmphix/${sample}_R2_rmphix.fq.gz
  rm cat_rmphix_unpaired/${sample}_R1_rmphix_unpaired.fq.gz
  rm cat_rmphix_unpaired/${sample}_R2_rmphix_unpaired.fq.gz
  
  cat rmphix*/${sample}*_R1_rmphix.fq.gz > cat_rmphix/${sample}_R1_rmphix.fq.gz
  cat rmphix_unpaired*/${sample}*_R1_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R1_rmphix_unpaired.fq.gz
  cat rmphix*/${sample}*_R2_rmphix.fq.gz > cat_rmphix/${sample}_R2_rmphix.fq.gz
  cat rmphix_unpaired*/${sample}*_R2_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R2_rmphix_unpaired.fq.gz
done
 
 
for sample in $(<../redoIDs.txt)
do
  rm -v ../fastqc/cat_rmphix/${sample}_R*
done
 
for sample in $(<../redoIDs.txt)
do
  sbatch --output=../fastqc/log/re.${sample}.cat.log --error=../fastqc/err/re.${sample}.cat.err fastqc.sh $sample
done

```

#Parsing fastqc files
```bash
cd /home/csantosm/jepson/fastqc/cat_rmphix
mkdir html zip unzip
mv *.html html
mv *.zip unzip
cd unzip
for file in *
do
  unzip $file
done
mv *.zip ../zip

source /home/csantosm/initconda
cd /home/csantosm/jepson/
python ~/general_scripts/fastqc_parser.py fastqc/cat_rmphix/unzip/ fastqc/ cat_rmphix

cd fastqc
mkdir parsed
mv *txt parsed

cd cat_rmphix
rm html/*
rm -r unzip/*
```

## Running megahit
```bash
cd /home/csantosm/jepson/
mkdir megahit
cd megahit
mkdir err log contigs

cd /home/csantosm/jepson/scripts/

for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../megahit/log/${sample}.mh.log --error=../megahit/err/${sample}.mh.err megahit.sh  $sample
done

for sample in $(<../finalIDs.txt)
do
  sbatch --output=../megahit/log/${sample}.mh.log --error=../megahit/err/${sample}.mh.err megahit_bmm.sh  $sample
done

JVN64 - time limit
JVN36 - time limit
JVN25 - time limit
JVN165 - time limit
JVN7 - input error
JVN4 - input error
JVN3- input error
JVN16 - input error
JVD23 - input error


sbatch --output=../megahit/log/JVN64.mh.c1.log --error=../megahit/err/JVN64.mh.c1.err megahit_bmm.sh  JVN64
sbatch --output=../megahit/log/JVN36.mh.c1.log --error=../megahit/err/JVN36.mh.c1.err megahit_bmm.sh  JVN36
sbatch --output=../megahit/log/JVN25.mh.c1.log --error=../megahit/err/JVN25.mh.c1.err megahit_bmm.sh  JVN25
sbatch --output=../megahit/log/JVN165.mh.c1.log --error=../megahit/err/JVN165.mh.c1.err megahit_bmm.sh  JVN165
```

##Redoing assemblies with input error
```bash
cd /home/csantosm/jepson/reads
mv ncbi/ rawA
mkdir rmphixA rmphix_unpairedA trimmedA statsA unpairedA
cd /home/csantosm/jepson/
ls -1 reads/rawA/ | grep "JVN7_" | cut -f1,2,3 -d_ | sort | uniq >> redoIDs.txt
ls -1 reads/rawA/ | grep "JVN4_" | cut -f1,2,3 -d_ | sort | uniq >> redoIDs.txt
ls -1 reads/rawA/ | grep "JVN3_" | cut -f1,2,3 -d_ | sort | uniq >> redoIDs.txt
ls -1 reads/rawA/ | grep "JVN16_" | cut -f1,2,3 -d_ | sort | uniq >> redoIDs.txt
ls -1 reads/rawA/ | grep "JVD23_" | cut -f1,2,3 -d_ | sort | uniq >> redoIDs.txt

cd /home/csantosm/jepson/scripts/

for sample in $(<../redoIDs.txt)
do
  sbatch --output=../reads/log/${sample}.qfA.log --error=../reads/err/${sample}.qfA.err qual_filter_redo.sh A $sample
done

cd /home/csantosm/jepson/reads

for sample in $(<../SredoIDs.txt)
do
  mv cat_rmphix*/${sample}_* cat_tmp
  cat rmphixA/${sample}*_R1_rmphix.fq.gz > cat_rmphix/${sample}_R1_rmphix.fq.gz
  cat rmphix_unpairedA/${sample}*_R1_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R1_rmphix_unpaired.fq.gz
  cat rmphixA/${sample}*_R2_rmphix.fq.gz > cat_rmphix/${sample}_R2_rmphix.fq.gz
  cat rmphix_unpairedA/${sample}*_R2_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R2_rmphix_unpaired.fq.gz
done

mv cat_rmphix*//${sample}_* cat_tmp
cat rmphixA/${sample}*_R1_rmphix.fq.gz > cat_rmphix/${sample}_R1_rmphix.fq.gz
cat rmphix_unpairedA/${sample}*_R1_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R1_rmphix_unpaired.fq.gz
cat rmphixA/${sample}*_R2_rmphix.fq.gz > cat_rmphix/${sample}_R2_rmphix.fq.gz
cat rmphix_unpairedA/${sample}*_R2_rmphix_unpaired.fq.gz > cat_rmphix_unpaired/${sample}_R2_rmphix_unpaired.fq.gz

cd /home/csantosm/jepson/scripts 

sbatch --output=../megahit/log/JVN7.mh.re.log --error=../megahit/err/JVN7.mh.re.err megahit_bmm.sh  JVN7
sbatch --output=../megahit/log/JVN4.mh.re.log --error=../megahit/err/JVN4.mh.re.err megahit_bmm.sh  JVN4
sbatch --output=../megahit/log/JVN3.mh.re.log --error=../megahit/err/JVN3.mh.re.err megahit_bmm.sh  JVN3
sbatch --output=../megahit/log/JVN16.mh.re.log --error=../megahit/err/JVN16.mh.re.err megahit_bmm.sh  JVN16
sbatch --output=../megahit/log/JVD23.mh.re.log --error=../megahit/err/JVD23.mh.re.err megahit_bmm.sh  JVD23

sbatch --output=../megahit/log/JVN1.mh.c1.log --error=../megahit/err/JVN1.mh.c1.err megahit.sh  JVN1
```


## Renaming

```bash
cd /home/csantosm/jepson/megahit
mkdir renamed_contigs

cd contigs

module load bbmap

for sample in $(<../../sampleIDs.txt)
do
  rename.sh in=${sample}.contigs.fa out=${sample}.renamed.contigs.fa prefix=${sample}_contig_
done

rename.sh in=JVD89.contigs.fa out=JVD89.renamed.contigs.fa prefix=JVD89_contig_
rename.sh in=JVD88.contigs.fa out=JVD88.renamed.contigs.fa prefix=JVD88_contig_
rename.sh in=JVN1.contigs.fa out=JVN1.renamed.contigs.fa prefix=JVN1_contig_

cd ..
mv contigs/*renamed* renamed_contigs/
```

## Getting assembly stats 
```bash
cd /home/csantosm/jepson/megahit/renamed_contigs
module load bbmap

statswrapper.sh *.fa out=all.megahit.summary format=6
```

## VIBRANT

```bash
cd /home/csantosm/jepson
mkdir vibrant
cd vibrant
mkdir err log

cd /home/csantosm/jepson/scripts

for sample in $(grep -v JVN1$ <../sampleIDs.txt)
do
  sbatch --output=../vibrant/log/${sample}.vbrnt.log --error=../vibrant/err/${sample}.vbrnt.err vibrant.sh $sample
done

for sample in $(<../vibrant_redoIDs.txt)
do
  rm -r ../vibrant/${sample}_vibrant
done

for sample in $(<../vibrant_redoIDs.txt)
do
  sbatch --output=../vibrant/log/${sample}.vbrnt.log --error=../vibrant/err/${sample}.vbrnt.err vibrant.sh $sample
done

sbatch --output=../vibrant/log/JVN1.vbrnt.log --error=../vibrant/err/JVN1.vbrnt.err vibrant.sh JVN1

sbatch --output=../vibrant/log/JVN116.vbrnt.log --error=../vibrant/err/JVN116.vbrnt.err vibrant.sh JVN116
sbatch --output=../vibrant/log/JVN150.vbrnt.log --error=../vibrant/err/JVN150.vbrnt.err vibrant.sh JVN150
sbatch --output=../vibrant/log/JVN15.vbrnt.log --error=../vibrant/err/JVN15.vbrnt.err vibrant.sh JVN15

sbatch --output=../vibrant/log/JVN116.vbrnt.log --error=../vibrant/err/JVN116.vbrnt.err vibrant.sh JVN116
sbatch --output=../vibrant/log/JVN15.vbrnt.log --error=../vibrant/err/JVN15.vbrnt.err vibrant.sh JVN15


sbatch --output=../vibrant/log/JVD54.vbrnt.log --error=../vibrant/err/JVD54.vbrnt.err vibrant.sh JVD54
sbatch --output=../vibrant/log/JVD56.vbrnt.log --error=../vibrant/err/JVD56.vbrnt.err vibrant.sh JVD56
sbatch --output=../vibrant/log/JVN147.vbrnt.log --error=../vibrant/err/JVN147.vbrnt.err vibrant.sh JVN147
```

## Aggregating vibrant annotations
```bash
cd /home/csantosm/jepson/vibrant

cat *_vibrant/VIBRANT*.renamed.contigs/VIBRANT_results*.renamed.contigs/VIBRANT_genbank_table*.renamed.contigs.tsv | grep -v ^protein > all_genbank_table.tsv
cat *_vibrant/VIBRANT*.renamed.contigs/VIBRANT_results*.renamed.contigs/VIBRANT_genome_quality*.renamed.contigs.tsv | grep -v ^scaffold > all_genome_quality.tsv
```


## Getting good quality viral contigs

```bash
cd /home/csantosm/jepson/vibrant

cat */VIBRAN*/VIBRANT_phages*/*phages_combined.fna > all.vib.contigs.fna
grep 'circular\|high\|medium' */*/VIBRANT_results*/VIBRANT_genome_quality_* | cut -f1 | cut -f2 -d: | sort | uniq > good.vib.ids
grep ">" all.vib.contigs.fna > all.vib.ids

source /home/csantosm/initconda
conda activate BIOPYTHON
python /home/csantosm/general_scripts/filter_fasta_by_list_of_headers.py all.vib.contigs.fna good.vib.ids > good.vib.contigs.fna
```

#Splitting the database into batches to run dRep
```bash
cd /home/csantosm/jepson
mkdir drep
cd drep
mkdir err log ALL B00 B01 B02 B03 B04 B05 B06 B07 
cp ../vibrant/good.vib.contigs.fna .

cd /home/csantosm/jepson/drep/ALL
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' ../good.vib.contigs.fna
mkdir split_contigs
mv *J* split_contigs

sbatch --output=../drep/log/ALL.drep.log --error=../drep/err/ALL.drep.log drep.sh ALL

source /home/csantosm/initconda
conda activate IPHOP
iphop split --input_file ./good.vib.contigs.fna --split_dir . --n_seq 11000

mv batch_00000.fna B00
mv batch_00001.fna B01
mv batch_00002.fna B02
mv batch_00003.fna B03
mv batch_00004.fna B04
mv batch_00005.fna B05
mv batch_00006.fna B06
mv batch_00007.fna B07

cd /home/csantosm/jepson/drep/B00
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B01
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B02
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B03
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B04
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B05
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B06
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs

cd /home/csantosm/jepson/drep/B07
awk '/^>/ {OUT=substr($0,2) ".fa"}; OUT {print >OUT}' *.fna
mkdir split_contigs
mv *J* split_contigs
```

## Running drep (first batches)

```bash
cd /home/csantosm/jepson/scripts
sbatch --output=../drep/log/B00.drep.log --error=../drep/err/B00.drep.log drep.sh B00
sbatch --output=../drep/log/B01.drep.log --error=../drep/err/B01.drep.log drep.sh B01
sbatch --output=../drep/log/B02.drep.log --error=../drep/err/B02.drep.log drep.sh B02
sbatch --output=../drep/log/B03.drep.log --error=../drep/err/B03.drep.log drep.sh B03
sbatch --output=../drep/log/B04.drep.log --error=../drep/err/B04.drep.log drep.sh B04
sbatch --output=../drep/log/B05.drep.log --error=../drep/err/B05.drep.log drep.sh B05
sbatch --output=../drep/log/B06.drep.log --error=../drep/err/B06.drep.log drep.sh B06
sbatch --output=../drep/log/B07.drep.log --error=../drep/err/B07.drep.log drep.sh B07
```

#drep second batch
```bash
cd /home/csantosm/jepson/drep/
mkdir B10 B11 B12 B13
mkdir B10/split_contigs B11/split_contigs B12/split_contigs B13/split_contigs

cp B00/*dRep/dereplicated_genomes/* B10/split_contigs
cp B01/*dRep/dereplicated_genomes/* B10/split_contigs

cp B02/*dRep/dereplicated_genomes/* B11/split_contigs
cp B03/*dRep/dereplicated_genomes/* B11/split_contigs

cp B04/*dRep/dereplicated_genomes/* B12/split_contigs
cp B05/*dRep/dereplicated_genomes/* B12/split_contigs

cp B06/*dRep/dereplicated_genomes/* B13/split_contigs
cp B07/*dRep/dereplicated_genomes/* B13/split_contigs

cd /home/csantosm/jepson/scripts
sbatch --output=../drep/log/B10.drep.log --error=../drep/err/B10.drep.log drep.sh B10
sbatch --output=../drep/log/B11.drep.log --error=../drep/err/B11.drep.log drep.sh B11
sbatch --output=../drep/log/B12.drep.log --error=../drep/err/B12.drep.log drep.sh B12
sbatch --output=../drep/log/B13.drep.log --error=../drep/err/B13.drep.log drep.sh B13
```

#drep third batch
```bash
cd /home/csantosm/jepson/drep/
mkdir B20 B21 
mkdir B20/split_contigs B21/split_contigs 

cp B10/*dRep/dereplicated_genomes/* B20/split_contigs
cp B11/*dRep/dereplicated_genomes/* B20/split_contigs

cp B12/*dRep/dereplicated_genomes/* B21/split_contigs
cp B13/*dRep/dereplicated_genomes/* B21/split_contigs

cd /home/csantosm/jepson/scripts
sbatch --output=../drep/log/B20.drep.log --error=../drep/err/B20.drep.log drep.sh B20
sbatch --output=../drep/log/B21.drep.log --error=../drep/err/B21.drep.log drep.sh B21
```

#drep final batch
```bash
cd /home/csantosm/jepson/drep/
mkdir B30
mkdir B30/split_contigs

cp B20/*dRep/dereplicated_genomes/* B30/split_contigs
cp B21/*dRep/dereplicated_genomes/* B30/split_contigs

cd /home/csantosm/jepson/scripts
sbatch --output=../drep/log/B30.drep.log --error=../drep/err/B30.drep.log drep.sh B30

sbatch --output=../drep/log/B30.drep.multi.log --error=../drep/err/B30.drep.multi.log drep_multi.sh B30
sbatch --output=../drep/log/ALL.drep.multi.log --error=../drep/err/ALL.drep.multi.log drep_multi.sh ALL

```

##cdhit v4.7
```bash
cd /home/csantosm/jepson/
mkdir cdhit
cd cdhit
mkdir err log
cd ..
cp drep/good.vib.contigs.fna cdhit/

cd /home/csantosm/jepson/scripts
sbatch --output=../cdhit/log/cdhit.log --error=../cdhit/err/cdhit.err cdhit.sh
```

## bowtie ref

```bash
cd /home/csantosm/jepson/
mkdir bowtie
cd bowtie
mkdir err log ref alignments coverm
cp ../cdhit/votu_cdhit.fa .

cd /home/csantosm/jepson/scripts
sbatch --output=../bowtie/log/cdhit.ref.log --error=../bowtie/err/cdhit.ref.err bowtie_cdhit_ref.sh
```

## bowtie map

```bash
cd /home/csantosm/jepson/scripts

for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../bowtie/log/${sample}.cdhit.bt2.log --error=../bowtie/err/${sample}.cdhit.bt2.err bowtie_cdhit_map.sh $sample
done
```

## one sample wasn't finished. it was only missing the samtools step
```bash
cd /home/csantosm/jepson/scripts
sbatch --output=../bowtie/log/JVD208.sam.bt2.log --error=../bowtie/err/JVD208.sam.bt2.err samtools.sh JVD208
```

## coverM
```bash
cd /home/csantosm/jepson/scripts
sbatch --output=../bowtie/log/coverm.log --error=../bowtie/err/coverm.err coverm.sh
```

#prodigal

```bash
cd /home/csantosm/jepson/
mkdir prodigal
cd prodigal
mkdir err log

cd /home/csantosm/jepson/scripts
sbatch --output=../prodigal/log/prdgl.log --error=../prodigal/err/prdgl.err prodigal.sh
```

#vcontact2
```bash
cd /home/csantosm/jepson/
mkdir vcontact
cd vcontact
mkdir err log

sbatch --output=../vcontact/log/g2g.log --error=../vcontact/err/g2g.err g2g.sh
sbatch --output=../vcontact/log/vc2.log --error=../vcontact/err/vc2.err vcontact.sh
```

```bash
cd /home/csantosm/jepson
mkdir iphop
cd iphop
mkdir err log split_db results

cd /home/csantosm/jepson/scripts

sbatch --output=../iphop/log/split.log --error=../iphop/err/split.err iphop_split.sh

for sample in $(<../iphopIDs2.txt)
do
  sbatch --output=../iphop/log/${sample}.log --error=../iphop/err/${sample}.err iphop_predict.sh ${sample}
done

sbatch --output=../iphop/log/batch_00000.log --error=../iphop/err/batch_00000.err iphop_predict.sh batch_00000

cd /home/csantosm/jepson/iphop/results


cat batch*/Host_prediction_to_genus_m90.csv | grep -v "Virus,AAI to closest RaFAH reference,Host genus,Confidence score,List of methods" > all_Host_prediction_to_genus_m90.csv
vim all_Host_prediction_to_genus_m90.csv 
#paste Virus,AAI to closest RaFAH reference,Host genus,Confidence score,List of methods

cat batch*/Host_prediction_to_genome_m90.csv| grep -v "Virus,Host genome,Host taxonomy,Main method,Confidence score,Additional methods" > all_Host_prediction_to_genome_m90.csv
vim all_Host_prediction_to_genome_m90.csv 
#paste Virus,Host genome,Host taxonomy,Main method,Confidence score,Additional methods
```

##instrain
```bash
cd /home/csantosm/jepson
mkdir instrain
cd instrain
mkdir err log

## generating stb file
grep ">" ../cdhit/votu_cdhit.fa | cut -f2 -d">" > tmp_contigs.txt
paste -d"\t" tmp_contigs.txt tmp_contigs.txt > votu_cdhit.stb

cd /home/csantosm/jepson/scripts
for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../instrain/log/${sample}.prof.log --error=../instrain/err/${sample}.prof.err instrain_profile.sh $sample
done

sbatch --output=../instrain/log/comp.log --error=../instrain/err/comp.err instrain_compare.sh
```


##Rarefaction
#Rarefying alignment files
```bash
cd /home/csantosm/jepson/bowtie
mkdir rare_bam

cd /home/csantosm/jepson/scripts

for sample in $(<../sampleIDs.txt)
do
  sbatch --output=../bowtie/log/${sample}.min.view.log --error=../bowtie/err/${sample}.min.view.err sam_view.sh $sample min
  sbatch --output=../bowtie/log/${sample}.med.view.log --error=../bowtie/err/${sample}.med.view.err sam_view.sh $sample med
done

sbatch --output=../bowtie/log/rare.min.coverm.log --error=../bowtie/err/rare.min.coverm.err rare_coverm.sh min
sbatch --output=../bowtie/log/rare.med.coverm.log --error=../bowtie/err/rare.med.coverm.err rare_coverm.sh med
```


