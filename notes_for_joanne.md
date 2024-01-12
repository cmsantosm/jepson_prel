## Requests

# Bioinformatics/sequencing data 

GitHub repo access 
*Done*

vOTU and 16S coverage tables
In github

Metadata (sample summary table, soil chemistry data, relevant categorical/continuous variables)
In github

Raw reads and QC'd reads (maybe just QC'd?) 
WGS data:
Raw reads are gone from the server but it should be available in the external drives I left. They've also been uploaded to NCBI but haven't been released yet.
QCd reads - the QC (Trimmomatic + BBDuk) are found here: /home/csantosm/jepson/reads/cat_rmphix
Amplicon data:
Raw reads: 
/home/csantosm/jepson_16s/reads/raw_j1/FWD/
/home/csantosm/jepson_16s/reads/raw_j1/RVS/
/home/csantosm/jepson_16s/reads/raw_j2/FWD/
/home/csantosm/jepson_16s/reads/raw_j2/RVS/
/home/csantosm/jepson_16s/reads/raw_j3/FWD/
/home/csantosm/jepson_16s/reads/raw_j3/RVS/
 
Assembled contigs 
All VIBRANT contigs - /home/csantosm/jepson/vibrant/all.vib.contigs.fna
Filtered VIBRANT contigs (circular, high, or medium quality) - /home/csantosm/jepson/vibrant/good.vib.contigs.fna
Dereplicated vOTUs (via cdhit) - /home/csantosm/jepson/cdhit/votu_cdhit.fa

Mapping data / bam files
Non-rarefied alignments - /home/csantosm/jepson/bowtie/alignments
Rarefied alignments - /home/csantosm/jepson/bowtie/rare_bam

16S ASV or OTU seed sequences (with taxonomy if possible); this would be for possible trees/UniFrac 
The ASV tables in the Github repo have the entire ASV sequence as row names so it should be possible to retrieve them and convert them to fasta files

NCBI upload - has this already been done in whole or in part? 
This has been handled - The release date is set for 2026-01-01 or upon publication (attaching the NCBI ID file)


Other data

Methods section (can you draft this?) 
yeah, at some point I'll do this. 

Plant biomass data, photos for plant identification
Attached

Culture collection - what's in there? Just Bacillus? (we might do something with your strains)
We barely sequenced a few. I am attaching a table that Devyn generated.

Frozen DNA from Jepson for metagenomes - any idea where this is, box/tube labels, etc.? We will probably send it to the JGI.
It's either in the freezer or in the -80. Boxes are labeled Jepson or Jep. and the labels follow a similar notation (maybe not identical) as the IDs in the dna_map.RDS file in Github

Same as above but for flash-frozen soil for possible RNA extractions
There were no flash-frozen soil samples from the Jepson experiment, they were all just put in the -80 to slowly freeze. They are in boxes labeled JEP, and follow the same notation as the IDs in the soil_map.RDS file in Github

MinION data from Courtney Mattson - where is it/what sample(s) is it (besides what I can already pull from e-mails with you and Courtney)
Data can be found here /home/csantosm/nanopore
Cannot find which samples I used (sorry!) but there should be labeled tubes in the freezer which maybe we could review through pictures?

Your bags of dry Jepson soil on the lab bench (clarifying exactly what they are and how the labels correspond to the contents)
They contain the leftover soil from the wetup experiment, they've been kept at room temperature inside the drawer since we collected the soils. 

