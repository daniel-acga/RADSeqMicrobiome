##Sdript Count loci per sample
##Por Daniel Acosta
##04-21

library (dplyr)
library(gplots)
library(vegan)
library(RColorBrewer)



# set your working directory 

setwd('~/path/to/your/working/directory')

#set this variable to be the common name of your files wich contains the taxonomic assigments and the sequences in various formats

samp <- "samplename"

#load up the files as a R objects and make sure your ".loci" file first line is a // for the code to work


tax.table <- read.table (paste0('./',samp,"_tax.txt"), header = TRUE, sep = " ")
seq_fa <- readLines (paste0('./',samp, '.fa'))
seq_loci <- readLines(paste0('./',samp, '.loci'))
samp.names <- readLines("./muestras.txt")  #text file with each sample name
sp_id <- readLines("./nombres_spp.txt")    #text file with each specie name related to the samples order


#get sample names and taxa to be searched across the data. If you search for family or genus information of certain phyla change for the commented command

#names <- as.vector(unique(tax.table_f$V5)) #V4 fam, V5 genus
#names <- unique (tax.table$V4 [grepl("Proteobacteria", tax.table$V3)])  #get all families from a phyla



#build a data frame for keeping the taxa count  the samples

taxa_counts <-data.frame (matrix(0L, nrow=70, ncol=length(names)))
rownames(taxa_counts) <- samp.names
colnames(taxa_counts)<- names


#make a couple of empty vector for the main loop

seqList <- vector()

seqs <- vector()


#save each fasta sequence name from every taxa in a vector

for (a in names){
  column.numb <- which ((colnames(taxa_counts) == a))
  locisearch <-tax.table_f$V1 [grepl(a, tax.table_f$V5)]

  #find each sequence from that taxa in the loci file
  
  for (i in locisearch) {
    seq_filter <- grep(i, seq_fa, fixed=T)
    took <- c(seq_filter + 1)
    seqs [i] <- seq_fa [took]
    count_filter <- grep (seqs[i],seq_loci, fixed=T )
    count_filter <- max (count_filter): (max(count_filter) - 70)
    
    #use located sequence for counting up each sample that forms 
    
    for (n in count_filter) {
      if (!(grepl("//*", seq_loci [n]))) {
        seqList <- strsplit(seq_loci[n], ".sra", fixed =F)
        num_row <- grep(seqList[[1]], samp.names)
        taxa_counts[[num_row, column.numb]] <- taxa_counts[[num_row, column.numb]] + 1
      } else {
          break
        }
    }
  }
}

#save count by sample in a csv file

write.csv(taxa_counts, paste("./",samp,"_taxa_counts.csv"))

#fix counts table by merging samples of the same specie

taxa_counts$X <- sp_id
taxa_counts_sp <- taxa_counts %>% group_by(X) %>% summarise_each(funs(sum))
taxa_counts_sp <- taxa_counts_sp[-c(18,19),]

row.names(taxa_counts_sp) <-taxa_counts_sp$X


#sabe counts of each specie in a csv file

write.csv(taxa_counts_sp, paste("./",samp,"_taxa_counts_sp.csv"))

#delete columns with 0 counts. Commented commands are used for fixing table if you just loaded it

#taxa_counts_sp <- read.csv
#row.names(taxa_counts_sp) <-taxa_counts_sp[,2]
#taxa_counts_sp[,c(1,2)] <- NULL
ind <- sapply(taxa_counts_sp, function(x) sum(x==0) != nrow(taxa_counts_sp))
taxa_counts_sp <- taxa_counts_sp[,ind]


#transform the raw counts of reads to proportions within a sample:
data.prop <- taxa_counts_sp/rowSums(taxa_counts_sp)
data.prop <- as.data.frame(data.prop)

head(data.prop)

# determine the maximum relative abundance for each column
maxab <- apply(data.prop, 2, max)
maxab


# remove the genera with less than 1% as their maximum relative abundance
n1 <- names(which(maxab < 0.01))
data.prop.1 <- data.prop[, - (which(names(data.prop) %in% n1))]


# calculate the Bray-Curtis dissimilarity matrix on the full dataset:
data.dist <- vegdist(data.prop.1, method = "bray")

# Do average linkage hierarchical clustering. Other options are 'complete' or 'single'. You'll need to choose the one that best fits the needs of your situation and your data.
clus <- hclust(data.dist, "aver")

#select the color for the sidebar according on a selected taxa code
sidecol = c("red", "red", "orange", "red", "red", "yellow", "red", "green", "green", "yellow", "purple", "green", "blue", "green", "purple", "blue", "blue" )



#build heatmap 
hm <- heatmap.2(as.matrix(data.prop.1), trace = "none", density.info = "none",  dendrogram = "row", Rowv = as.dendrogram(clus), col = scaleyellowred, cexCol = 1.15, cexRow = 1.15, RowSideColors = sidecol, margins = c(11.5, 12))


