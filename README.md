# Metagenomics-RAD Dendroctonus>


We are seeking to evaluate microbiome sequences associated with RADseq sequences of bark beetles of the genus Dendroctonu to assess the ability to retrieve genetic information from communities of microorganisms associated with beetles.

RADseq data used for scanning microbiological diversity within the genus Dendroctonus comes from the publication of [Godefroid et al de 2019](https://www.sciencedirect.com/science/article/abs/pii/S1055790319302441), generated in order to propose a new phylogeny including seventeen species of this genus [NCBI Bioproject: PRJNA530572](https://www.ncbi.nlm.nih.gov/bioproject/?term=txid77165[Organism:noexp]) We use the iPyrad v.0.7 pipeline .28 [Eaton & Overcast, 2020](https://academic.oup.com/bioinformatics/article-abstract/36/8/2592/5697088).

Scrpits described bellow are available in [bin](linkdeldirectory), associated data in [data](link) and results in [output](link).

Genome assemblies (.loci and fasta files) can be found [here](https://drive.google.com/drive/folders/1tdBvzSGAc31RCNSy1-ugs9rbh54g-a3L?usp=sharingin). Each assembly is contained in a directory in loci and fasta format. Alongside, there are also statistics, assembly parameters and a table that counts the reads with which the assembly begins.




## Methods

### Quality Filtering
The steps of quality filtering and assignment of the reads to a sample were performed using the default parameters of ipyrad. Multiple assemblies were explored by varying the clustering threshold parameter (0.97 and 0.95), which corresponds to the level of similarity to which two reads are considered homologous. [Eaton & Overcast, 2020](https://academic.oup.com/bioinformatics/article-abstract/36/8/2592/5697088), to compare the performance of different matrices.

A minimum value of samples with shared loci (min_samples_locus) of 1 was chosen so as not to discard the sequences from possible exclusive symbionts of a sample, 4 as the maximum value of different alleles in the consensus per sample (max_alleles_consens) and a value of maximum sites heterozygotes per locus (max_shared_Hs_locus) of 0.5.


### Gene assembly
We tried three approaches to group the shared loci between the samples analyzed:

1. de novo assembly
1. using a fungi reference genome
1. using an insect reference genome as filter

The first type of assembly (de novo) generates clusters by using a global alignment grouping algorithm, using the USEARCH program [Edgar, 2010] (https://www.osti.gov/biblio/1137186), which allows the incorporation of indelible variations when identifying homology. 

The second takes as a reference a genome chosen by the user to identify homologies and discards everything that does not resemble it. To generate the assembly we used the complete genome sequence of one of the characteristic symbiote fungi of this bark beetle genus, Grosmannia clavigera ( [NCBI BioProject: PRJNA39837](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA39837) , [DiGuistini et al, 2011] (https://www.pnas.org/content/108/6/2504.short) ).

El tercero (de novo - referencia) elimina cualquier lectura que coincida con la secuencia de referencia y retiene sólo reads no coincidentes para ser utilizadas en un ensamble de novo (Eaton, 2014).   Esta última aproximación se utilizó para identificar loci nuevos en las muestras previamente etiquetadas por el artículo original como Dendroctonus D. ponderaseae, y también en el universo de muestras como segunda aproximación, usando como referencia a la secuencia del proyecto de genoma completo de Dendroctonus ponderosae (NCB BioProjectI: PRJNA162621, Keeling et al, 2013).

Brevemente para cada estrategia, se recuperó el archivo .loci generado por ipyrad, el cual presenta los reads asociados a cada locus, con el nombre del individuo de donde se originó la muestra. Se empleó el script de R escrito por Holmes y Rabosky en su publicación de 2018 para tomar la primera secuencia de cada locus y agruparalas en un archivo fasta que posteriormente se procesó mediante la herramienta de blastn del National Center for Biotechnology Information (NCBI).

ADD BLAST METODOLOGY


## Results
