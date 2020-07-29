###Cleaning and plotting of the RADSeq microbiome taxa retrieved 
##Por Daniel E. Acosta

library(ggplot2)
library(dplyr)


#Loading of the files from the blast matches with a similarity value of at least 90% and replace the column that identifies each sequence with the assembly title

tax <- read.table("./GrossmaniaRef_97_tax.txt", header= TRUE, sep = "")
tax$V1 <- "GRef_97"


tax1  <- read.table("./DPond_97_tax.txt", header= TRUE, sep = "")
tax1$V1 <- "DPond_97"

tax2 <-  read.table("./DPond_95_tax.txt", header= TRUE, sep = "")
tax2$V1 <- "DPond_95"

tax3 <- read.table("./DendroDenovo_97_tax.txt", header= TRUE, sep = "")
tax3$V1 <- "Denovo_97"


tax4  <- read.table("./DendroDenovo_95_tax.txt", header= TRUE, sep = "")
tax4$V1 <- "Denovo_95"

tax5 <-  read.table("./DendroRef_97_tax.txt", header= TRUE, sep = "")
tax5$V1 <- "DRef_97"


#Merge the rows of the tables to plot the complete data

taxx <- bind_rows(tax, tax1, tax2, tax3, tax4, tax5)


#Fix the data into a frequency matrix

counts <- rename(count(taxx, V1, V3), Freq = n) 

o <- table(taxx$V1, taxx$V3)



a <-ggplot(taxx, aes (x = V1)) + geom_bar(aes(fill=V3)) +
  labs(x= "phylum", y="no seqs") + theme_minimal() 
a + theme(legend.title = element_blank()) + ggtitle ("Total matches, 90% similarity") 

#Filter the problematic data from the taxa and plotting

taxx_x <- taxx[!(taxx$V3 == "Arthropoda"| taxx$V3 == "Chordata" | taxx$V3 == "Echinodermata"| taxx$V3 == "Mollusca" | taxx$V3 == "Porifera" | taxx$V3 == "Platyhelminthes" | taxx$V3 == "Streptophyta"| taxx$V3 == "multiple"),]
                   
counts_x <- rename(count(taxx_x, V1, V3), Freq = n) 

p <- table(taxx_x$V1, taxx_x$V3)
p


b <- ggplot(taxx_x, aes (x = V1)) + geom_bar(aes(fill=V3) ) +
  labs(x= "phylum", y="no seqs") + theme_minimal() 
b + theme(legend.title = element_blank()) + ggtitle ("Filtered matches, 90% similarity") 




