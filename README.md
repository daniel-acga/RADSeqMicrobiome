# Metagenomics-RAD Dendroctonus>


We are seeking to evaluate microbiome sequences associated with RADseq sequences of bark beetles of the genus Dendroctonu to assess the ability to retrieve genetic information from communities of microorganisms associated with beetles.

RADseq data used for scanning microbiological diversity within the genus Dendroctonus comes from the publication of [Godefroid et al de 2019](https://www.sciencedirect.com/science/article/abs/pii/S1055790319302441), generated in order to propose a new phylogeny including seventeen species of this genus [NCBI Bioproject: PRJNA530572](https://www.ncbi.nlm.nih.gov/bioproject/?term=txid77165[Organism:noexp]) We use the [iPyrad v.0.7 pipeline .28] (https://ipyrad.readthedocs.io/en/latest/)  [Eaton, 2014](https://academic.oup.com/bioinformatics/article/30/13/1844/2422183).

Scrpits described bellow are available in [bin](linkdeldirectory), associated data in [data](link) and results in [output].

Genome assemblies (.loci and fasta files) can be found [here](https://drive.google.com/drive/folders/1tdBvzSGAc31RCNSy1-ugs9rbh54g-a3L?usp=sharingin). Cada ensamble está contenido en un directorio en formato loci y fasta. Además en este se encuentran también los estadísticos, los parámetros del ensamble y una tabla que hace el conteo de los reads con los que empieza el ensamble.



## Methods

### Quality Filtering
Se realizaron los pasos de filtrado por calidad y asignación de las reads a una muestra  usando los parámetros predeterminados de ipyrad. Se exploraron múltiples ensambles variando el parámetro clustering threshold (0.97 y 0.95), que corresponde al nivel de similitud al que dos reads se consideran homólogos (Eaton, 2014), para comparar el desempeño de diferentes matrices. 

Se eligió un valor mínimo de muestras con loci compartidos (min_samples_locus) de 1 para no descartar las secuencias provenientes de posibles simbiontes exclusivos de una muestra, 4 como valor máximo de alelos diferentes en el consenso por muestra (max_alleles_consens) y un valor de máximos sitios heterocigotos por locus (max_shared_Hs_locus) de 0.5.


### Gene assembly
Se realizaron tres aproximaciones para el agrupamiento de loci compartidos entre las muestras analizadas:

1. de novo assembly
1. using a fungi reference genome
1. using an insect reference genome as filter

El primer tipo de ensamble (de novo) genera clusters mediante el uso de un algoritmo de agrupación global de alineación, recurriendo al programa USEARCH (Edgar, 2010), que permite la incorporación de variaciones indels al identificar la homología. 

El segundo toma como referencia un genoma elegido por el usuario para identificar homologías y descarta todo lo que no se parezca a ella. Para generar el ensamble usando como referencia la secuencia del genoma completo de uno de los hongos simbiontes característicos de este género (bark beetle), Grosmannia clavigera (NCBI BioProject: PRJNA39837, DiGustini et al, 2011).

El tercero (de novo - referencia) elimina cualquier lectura que coincida con la secuencia de referencia y retiene sólo reads no coincidentes para ser utilizadas en un ensamble de novo (Eaton, 2014).   Esta última aproximación se utilizó para identificar loci nuevos en las muestras previamente etiquetadas por el artículo original como Dendroctonus D. ponderaseae, y también en el universo de muestras como segunda aproximación, usando como referencia a la secuencia del proyecto de genoma completo de Dendroctonus ponderosae (NCB BioProjectI: PRJNA162621, Keeling et al, 2013).

Brevemente para cada estrategia, se recuperó el archivo .loci generado por ipyrad, el cual presenta los reads asociados a cada locus, con el nombre del individuo de donde se originó la muestra. Se empleó el script de R escrito por Holmes y Rabosky en su publicación de 2018 para tomar la primera secuencia de cada locus y agruparalas en un archivo fasta que posteriormente se procesó mediante la herramienta de blastn del National Center for Biotechnology Information (NCBI).

ADD BLAST METODOLOGY


## Results
