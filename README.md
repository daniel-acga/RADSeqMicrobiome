# Metagenomics-RAD-2020
Se busca evaluar secuencias de microbioma asociadas a secuencias de RADseq del género Dendroctonus. 
Para evaluar la capacidad de recuperar información genética de comunidades de microorganismos asociados a los escarabajos,

Los datos de RADseq empleados para el escaneo de la diversidad microbiológica dentro del género Dendroctonus provienen de la publicación de Godefroid et al de 2019, realizada con el fin de proponer una nueva filogenia incluyendo diecisiete especies de este género (NCBI Bioproject: PRJNA530572), empleamos el pipeline iPyrad v.0.7.28 (Eaton, 2014).

Se realizaron tres aproximaciones para el agrupamiento de loci compartidos entre las muestras analizadas:  ensamble de novo, ensamble con referencia y de novo - menos referencia.

El primer tipo de ensamble (de novo) genera clusters mediante el uso de un algoritmo de agrupación global de alineación, recurriendo al programa USEARCH (Edgar, 2010), que permite la incorporación de variaciones indels al identificar la homología. 
El segundo toma como referencia una secuencia elegida por el usuario para identificar homologías y descarta todo lo que no se parezca a ella. Para generar el ensamble usando como referencia la secuencia del genoma completo de uno de los hongos simbiontes característicos de este género, Grosmannia clavigera (NCBI BioProject: PRJNA39837, DiGustini et al, 2011). 
El tercero (de novo - referencia) elimina cualquier lectura que coincida con la secuencia de referencia y retiene sólo reads no coincidentes para ser utilizadas en un ensamble de novo (Eaton, 2014).   Esta última aproximación se utilizó para identificar loci nuevos en las muestras previamente etiquetadas por el artículo original como Dendroctonus D. ponderaseae, y también en el universo de muestras como segunda aproximación, usando como referencia a la secuencia del proyecto de genoma completo de D. ponderosae (NCB BioProjectI: PRJNA162621, Keeling et al, 2013).

Se realizaron los pasos de filtrado por calidad y asignación de las reads a una muestra  usando los parámetros predeterminados de ipyrad. Se exploraron múltiples ensambles variando el parámetro clustering threshold (0.97 y 0.95), que corresponde al nivel de similitud al que dos reads se consideran homólogos (Eaton, 2014), para comparar el desempeño de diferentes matrices. 

Se eligió un valor mínimo de muestras con loci compartidos (min_samples_locus) de 1 para no descartar las secuencias provenientes de posibles simbiontes exclusivos de una muestra, 4 como valor máximo de alelos diferentes en el consenso por muestra (max_alleles_consens) y un valor de máximos sitios heterocigotos por locus (max_shared_Hs_locus) de 0.5.

Se recuperó el archivo .loci generado por ipyrad, el cual presenta los reads asociados a cada locus enlistados en un grupo, con el nombre del individuo de donde se originó la muestra incluido en el nombre de esa secuencia y con una línea de diagonales separando a los loci diferentes dentro del archivo. Se empleó el script de R escrito por Holmes y Rabosky en su publicación de 2018 para tomar la primera secuencia de cada locus. 
Estas secuencias son agrupadas en un archivo fasta que posteriormente se procesó mediante la herramienta de blastn del National Center for Biotechnology Information (NCBI). 

Tras no obtener resultados satisfactorios al realizar este último paso con la herramienta disponible para UNIX shell, NCBI-BLAST-2.10.0+,debido al poder de cómputo requerido, se propone la posibilidad de llevar a cabo las pruebas de búsqueda por alineamiento en e cluster de súpercomputo de la UNAM "Miztli" disponible para este proyecto o mediante la plataforma de TheGalaxyProject (Afgan et. al., 2016).




Disponibilidad de los ensambles en el siguiente enlace:

Cada ensamble está contenido en un directorio en formato loci y fasta. Además en este se encuentran también los estadísticos, los parámetros del ensamble y una tabla que hace el conteo de los reads con los que empieza el ensamble.


https://drive.google.com/drive/folders/1tdBvzSGAc31RCNSy1-ugs9rbh54g-a3L?usp=sharing


