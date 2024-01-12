# Load libraries
library(Rcpp, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(stringr, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(farver, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(labeling, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(digest, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(magrittr, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(dplyr, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(tidyr, lib.loc="/home/csantosm/R_Packages/R3.6.3/")
library(dada2, lib.loc="/home/csantosm/R_Packages/R3.6.3/")

# Setting the absolute paths for FWD and RVS files
fwd.path <- "/home/csantosm/jepson_16s/reads/raw_j1/FWD/" 
rvs.path <- "/home/csantosm/jepson_16s/reads/raw_j1/RVS/"

# Forward and reverse fastq filenames have format: JAXXX.fastq
fnFs <- sort(list.files(fwd.path, pattern="JA.*fastq", full.names = TRUE))
fnRs <- sort(list.files(rvs.path, pattern="JA.*fastq", full.names = TRUE))

# Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(str_extract(basename(fnFs), "JA\\d\\d\\d"), `[`, 1)

# Generate filtered file path
filtFs <- file.path("/home/csantosm/jepson_16s/reads/raw_j1/filtered/", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path("/home/csantosm/jepson_16s/reads/raw_j1/filtered/", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names


out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen = c(240,160),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE, 
                     compress=TRUE, multithread=TRUE, verbose = TRUE)

out

errF <- learnErrors(filtFs, multithread=TRUE, randomize = T)
errR <- learnErrors(filtRs, multithread=TRUE, randomize = T)

pdf("/home/csantosm/jepson_16s/qual_plots/err1_FWD.pdf")
plotErrors(errF, nominalQ=TRUE)
dev.off()

pdf("/home/csantosm/jepson_16s/qual_plots/err1_RVS.pdf")
plotErrors(errR, nominalQ=TRUE)
dev.off()



dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)

dadaFs[[1]]
dadaRs[[1]]



mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
# Inspect the merger data.frame from the first sample
head(mergers[[1]])


seqtab <- makeSequenceTable(mergers)
dim(seqtab)
table(nchar(getSequences(seqtab)))



seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim)
sum(seqtab.nochim)/sum(seqtab)
table(nchar(getSequences(seqtab.nochim)))


getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)


taxa <- assignTaxonomy(seqtab.nochim, "/home/csantosm/databases/silva_v138.1/silva_nr99_v138.1_train_set.fa.gz", multithread=TRUE)
taxa <- addSpecies(taxa, "/home/csantosm/databases/silva_v138.1/silva_species_assignment_v138.1.fa.gz")

taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)

otu <- t(seqtab.nochim)
otu.tax <- taxa %>% as.data.frame() %>% mutate(OTU_ID = row.names(.))
rownames(otu.tax) <- NULL


saveRDS(seqtab.nochim, "/home/csantosm/jepson_16s/dada_files/otu_dada1.RDS")
saveRDS(taxa, "/home/csantosm/jepson_16s/dada_files/tax_dada1.RDS")
saveRDS(otu, "/home/csantosm/jepson_16s/dada_files/otu1.RDS")
saveRDS(otu.tax, "/home/csantosm/jepson_16s/dada_files/tax1.RDS")
saveRDS(track, "/home/csantosm/jepson_16s/dada_files/track1.RDS")


