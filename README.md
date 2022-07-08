# Seeking microbiome sequences within RADSeq data


In this project we are scanning microbiological diversity within RADSeq data from bark beetles of the genus Dendroctonus to retrieve metagenomic information from microbial communities associated with bark beetles.

The RADSeq data we use comes from the publication of [Godefroid et al, 2019](https://www.sciencedirect.com/science/article/abs/pii/S1055790319302441), that was generated to build a phylogeny of the bark beetle Dendroctonus (17 out of 20 currently known species) [NCBI Bioproject: PRJNA530572](https://www.ncbi.nlm.nih.gov/bioproject/?term=txid77165[Organism:noexp]).

Scrpits described bellow are available in [bin](https://github.com/daniel-acga/Metagenomics-RAD-Insect-/blob/master/bin/Holmes%202018%20R%20blast), associated data are in [data](link) and results are in [output](link).



## Methods

We analyze the data using the iPyrad v.0.7 pipeline [Eaton & Overcast, 2020](https://academic.oup.com/bioinformatics/article-abstract/36/8/25925697088) using default parameters.


### Gene assembly
Reads were assembled using two clustering threshold values (0.97 and 0.95) that correspond to similarity between reads. We tried three approaches to cluster the shared loci between samples:

1. de novo assembly
1. using a fungi reference genome
1. using an insect reference genome as filter

De novo assembly generates clusters by using a global alignment grouping algorithm, in the USEARCH program [Edgar, 2010](https://www.osti.gov/biblio/1137186), that allows the incorporation of indel variation to identify homology. 

We selected reads based on the fungal reference genome of Grossmania clavigera [NCBI BioProject: PRJNA264104](https://www.ncbi.nlm.nih.gov/bioproject/264104) [DiGuistini et al, 2011](https://www.pnas.org/content/108/6/2504.short) that is a common symbiont of this bark beetle genus. 

Finally, we used the reference genome of Dendroctonus ponderaseae  [NCBI BioProjectI: PRJNA162621](https://www.ncbi.nlm.nih.gov/bioproject/162621), [Keeling et al, 2013](https://genomebiology.biomedcentral.com/articles/10.1186/gb-2013-14-3-r27) to retain only the reads that mismatches the reference. This approach was used to analyze: 1) three samples of Dendroctonus ponderaseae; 2) all samples of the different species of Dendroctonus from the dataset.

We run discontinous megablast search with the goal of retrieving taxids used with the R package, taxize to complete the taxonomic assignation with [holmes_sp.R](https://github.com/daniel-acga/RADSeqMicrobiome/blob/master/bin/holmes_sp.R)  modified from [Holmes and Rabosky, 2018](https://peerj.com/articles/4662/) . An original R script was made to explore the files generated throughout the workflow (“.tax”, “.fasta” and “.loci”), in order to identify and count the samples and subsequently identify the informative loci (mostly microbial, but also from other groups of biological interest such as Streptophyta) with more than 90% similarity with respect to their coincidence in the NCBI database. From this analysis, heat maps of phyla diversity in each Dendroctonus species were generated for the Denovo_97 assemble.


## Results
