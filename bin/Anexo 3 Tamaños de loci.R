##Sdript Size loci per sample
##Por Daniel Acosta
##02-22

library (dplyr)
library (stringr)
library(modeest)

# set your working directory 

setwd('~/path/to/your/working/directory')
 
samp <- "sampname"

#load up the files as a R objects and make sure your ".loci" file first line is a // for the code to work


tax.table <- read.table (paste0('./',samp,"_tax.txt"), header = TRUE, sep = " ")
seq_fa <- readLines (paste0('./',samp, '.fa'))


names <- sort(unique(tax.table$V3)) #V4 fam, V5 genus

#optionally focus the search in only certain species names

names <- names [names %in%  c("speciesnames")]

#build a data frame for keeping the taxa count  the samples

taxa_counts_d <-data.frame (matrix(0L, nrow=length(names), ncol=7))
rownames(taxa_counts_d)<- sort(names)
taxa_counts_d[,1] <- table(tax.table$V3)



#save each fasta sequence name from every taxa in a vector

for (a in names)  {
  locisearch <-tax.table$V1 [grepl(a, tax.table$V3)] #find each sequence from that taxa in the loci file 
  sizes <- vector(mode = "integer", length = taxa_counts_d[a, 1] )
  
  for (k in 1:length(locisearch)) {
    i <-locisearch[k]
    seq_filter <- grep (gsub(" ", "", paste("^>",i,"$")), seq_fa, fixed = FALSE)
    took <- c(seq_filter + 1) 
    sizes [k] <- str_length (seq_fa [took])
  
  }
  
 taxa_counts_d[a, 2] <- mean(sizes , na.rm = TRUE)
 taxa_counts_d[a, 3] <- median(sizes , na.rm = TRUE)
  taxa_counts_d[a, 4] <- mfv (sizes)
  taxa_counts_d[a, 5] <- sd(sizes)
  taxa_counts_d[a, 6] <- min(sizes)
  taxa_counts_d[a, 7] <- max(sizes)
  sizes <- c() 
  print (a)
}




#save count by sample in a csv file

write.csv(taxa_counts_d, paste("./rangesize_dnnn.csv"))

