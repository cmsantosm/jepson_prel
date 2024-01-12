# Jepson study

This repository holds all the processed data and exploratory analyses that I have generated for the Jepson temporal study. In particular, it contains:
 
## Processed data

The following processed data can be found in `Analysis/Data`:

### Processed data generated in the `Processing/Notebooks/coverm_formatting.Rmd` notebook:
- `rare_med_votu75_count.RDS` - vOTU count table with a 75% horizontal coverage threshold rarified to the median sequencing depth
- `rare_med_votu75_tmean.RDS` - vOTU trimmed mean table with a 75% horizontal coverage threshold rarified to the median sequencin g depth
- `rare_min_votu75_count.RDS` - vOTU count table with a 75% horizontal coverage threshold rarified to the minimum sequencing depth
- `rare_min_votu75_tmean.RDS` - vOTU trimmed mean table with a 75% horizontal coverage threshold rarified to the minimum sequencing depth
- `votu75_count.RDS` - vOTU count table with a 75% horizontal coverage threshold (no rarefaction)
- `votu75_tmean.RDS` - vOTU trimmed mean table with a 75% horizontal coverage threshold (no rarefaction)

### Processed data generated in the `Processing/Notebooks/iphop.Rmd` notebook:
- `iphop_genome_aggregated.RDS` - Parsed iphop host_prediction_to_genome file with aggregated predictions 
- `iphop_genome_original.RDS` - Original iphop host_prediction_to_genome file 
- `iphop_genus_aggregated.RDS` - Parsed iphop host_prediction_to_genus file with aggregated predictions 
- `iphop_genus_original.RDS` - Original iphop host_prediction_to_genus file

### Processed data generated in the `Processing/Notebooks/network_formatter.Rmd` notebook:
- `mound_ntwk_filt_edges_rare_min_votu75.RDS` - vcontact edges for a fruchtermanreingold network layout calculated for all mound vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold
- `mound_ntwk_filt_nodes_rare_min_votu75.RDS` - vcontact nodes for a fruchtermanreingold network layout calculated for all mound vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold
- `mound_ntwk_filt_rare_min_votu75.RDS` - raw vcontact pairs for all mound vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold 
- `swale_ntwk_filt_edges_rare_min_votu75.RDS` - vcontact edges for a fruchtermanreingold network layout calculated for all swale vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold
- `swale_ntwk_filt_nodes_rare_min_votu75.RDS` - vcontact edges for a fruchtermanreingold network layout calculated for all swale vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold
- `swale_ntwk_filt_rare_min_votu75.RDS`  - raw vcontact pairs for all swale vOTUs detected in the rarified vOTU table with a 75% horizontal coverage threshold 

### Processed data generated in the `Processing/Notebooks/dada_processing.Rmd` notebook:
- `amplicon_asv.RDS` - Filtered ASV table (chimeras nor organellar ASVs have been removed)
- `amplicon_nsingletons_asv.RDS` - Filtered ASV table with singletons removed
- `amplicon_raremin_nsing_asv.RDS`- Filtered ASV table with singletons removed rarified to the minimum sequencing depth
- `amplicon_tax.RDS` - ASV taxonomic classifications 

### Processed data generated in the `Processing/Notebooks/mapping_files.Rmd` notebook:
- `dna_map.RDS` - Mapping file with all the metadata for the DNA samples and sequencing profiles generated in the experiment.
- `gps.RDS` - File with GPS coordinates
- `soil_map.RDS` - Mapping file with all the soil samples collected in the study

### Processed data generated in the `Processing/Notebooks/sequencing_depth.Rmd` notebook:
- `seq_depth.RDS` - Sequencing depth stats

### Other data:
- `climate.tsv` - Daily climate data collected from the [Jepson weather station](https://wrcc.dri.edu/weather/ucjp.html)

## Exploratory analyses

The following analysis notebooks can be found in  `Analysis/Notebooks`:

- `collection_timepoints.Rmd` - The only point of this notebook is to generate a plot that displays all the samples that were collected for this study. 
- `mound_v_swale.Rmd` - This notebook contains all the analyses comparing the compositional trends of communities associated with mounds and swales
- `spatial_patterns_main.Rmd` - This notebook focuses on the differences across the four sites sampled for the main experiment
- `temporal_patterns_main.Rmd` - This notebook focuses on the temporal trends observed in the main experiment
- `network_trends.Rmd` - This notebook is a very preliminary analysis visually exploring the vOTU distributions in the vcontact network across treatments
- `spatial_complementary.Rmd` - This notebook focuses on the additional set of samples collected at the end of the sampling season across an extended set of locations.


## Processing pipeline

- The `Processing/notes.md` file shows the bioinformatic pipeline steps ran in the server
- The `Processing/Scripts` directory contains all the scripts ran in the server
- The `Processing/Data` directory contains all raw data generated by the various steps of the bioinformatic pipeline
- The `Processing/Notebooks` directory contains R Notebooks used to process the raw data and generate the files found in `Analysis/Data`

## General files

- The `General/general_functions.R` file holds helper functions that are used in various R notebooks 
- The`General/plotting_parameters.R` file holds plotting parameters used in various R notebooks

