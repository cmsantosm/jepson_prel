# Load libraries
library(Rcpp, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(farver, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(labeling, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(digest, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(dada2, lib.loc="/home/csantosm/R_Packages/R3.6.3/")

# Setting the absolute paths for FWD and RVS files
fwd1.path <- "/home/csantosm/jepson_16s/reads/raw_j1/FWD/" 
rvs1.path <- "/home/csantosm/jepson_16s/reads/raw_j1/RVS/"

fwd2.path <- "/home/csantosm/jepson_16s/reads/raw_j2/FWD/" 
rvs2.path <- "/home/csantosm/jepson_16s/reads/raw_j2/RVS/"

fwd3.path <- "/home/csantosm/jepson_16s/reads/raw_j3/FWD/" 
rvs3.path <- "/home/csantosm/jepson_16s/reads/raw_j3/RVS/"

# Forward and reverse fastq filenames have format: JAXXX.fastq
fnFs1 <- sort(list.files(fwd1.path, pattern="JA.*fastq", full.names = TRUE))
fnRs1 <- sort(list.files(rvs1.path, pattern="JA.*fastq", full.names = TRUE))

fnFs2 <- sort(list.files(fwd2.path, pattern="JA.*fastq", full.names = TRUE))
fnRs2 <- sort(list.files(rvs2.path, pattern="JA.*fastq", full.names = TRUE))

fnFs3 <- sort(list.files(fwd3.path, pattern="JA.*fastq", full.names = TRUE))
fnRs3 <- sort(list.files(rvs3.path, pattern="JA.*fastq", full.names = TRUE))

# Plot first 10 forward libraries
pdf("/home/csantosm/jepson_16s/qual_plots/raw_j1_FWD.pdf")
plotQualityProfile(fnFs1[1:10])
dev.off()

pdf("/home/csantosm/jepson_16s/qual_plots/raw_j2_FWD.pdf")
plotQualityProfile(fnFs2[1:10])
dev.off()

pdf("/home/csantosm/jepson_16s/qual_plots/raw_j3_FWD.pdf")
plotQualityProfile(fnFs3[1:10])
dev.off()

# Plot first 10 forward libraries
pdf("/home/csantosm/jepson_16s/qual_plots/raw_j1_RVS.pdf")
plotQualityProfile(fnRs1[1:10])
dev.off()

pdf("/home/csantosm/jepson_16s/qual_plots/raw_j2_RVS.pdf")
plotQualityProfile(fnRs2[1:10])
dev.off()

pdf("/home/csantosm/jepson_16s/qual_plots/raw_j3_RVS.pdf")
plotQualityProfile(fnRs3[1:10])
dev.off()
