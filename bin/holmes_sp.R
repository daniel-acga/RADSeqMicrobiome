#From Holmes & Raboski, 2018
#Modified by Acosta Daniel, 2021

library(seqinr)
library(taxize)

# set this variable to be the name of your .loci file
samp <- 'DendFAT95'

# set your working directory 

setwd('~/path/to/your/working/directory')

# read the .loci file into R as a character vector where each element of the list is one line of the .loci file. The .loci file contains the sequences for each individual that amplified at a given locus, separated by a consistent line break string. The number of sequences at each locus is not consistent.

tmp <- readLines(paste0('./',samp, '.loci'))

# The '//' string is used by the author of pyRAD as part of the string that denotes breaks between loci in the .loci file. We identify the vector elements in 'tmp' that have this string, so that we can find the breaks between loci

tmp.breakLines <- grep('//', tmp, fixed = TRUE)

# we move one line up from each break to select one sequence from each locus for identification

take <- c(tmp.breakLines - 1)

# use the above vector to pull one sequence per locus. This will be a string with the sample name, followed by the DNA equence of the locus

seqs <- tmp[take]

# remove the names from the sequence character string
  
seqList <- lapply(seqs, function(sq){x <- strsplit(sq, " "); return(x[[1]][length(x[[1]])])})

# write out a fasta file that can be passed to the blastn program

write.fasta(seqList, paste0(samp,"_", 1:length(seqList)), paste0("./",samp,".fa"))


##########################
# to blast the sequences #
##########################

# blastn -task dc-megablast -db nt -query [your header].fa -outfmt "6 qseqid sseqid staxids sskingdoms pident mismatch" -out [your header]_out.txt -num_threads 2  -max_target_seqs 20


#######################
# after the blast run #
#######################


# set your threshold percentage similarity between your sequence and its NCBI match
threshold <- 90


# read in the blast results
blast.results <- read.table(paste0("./",samp,"_out.txt"), sep="	")

# get all of the NCBI ids from the blast results

ids <- strsplit(as.character(blast.results$V3),";")

# some sequences get more than one hit, with numbers separated by a semicolon. We take the first number in such cases

ids <- as.numeric(unlist(lapply(ids, function(c){return(c[1])})))

# get a vector with each ID repeated once

ids <- unique(ids)

# use the taxize package to get the verbal classification for each id

# make a directory to hold the verbal classifications

dir.create(paste0("./",samp))

# loop over each id number and write out the classification into the file for later use. This is the most time-consuming step, so we save time by writing the verbal classification into files and querying that smaller database rather than using the 'classification' function for each separate ID in the Blast results. Please note that the 'classification' function occasionally times out, so the loop may need to be re-started if you see the following error message: 'Error in curl::curl_fetch_memory(url, handle = handle).' If that happens, type 'i' into the R terminal and edit the '1' in line 67 to match the value of i, then run the for loop line again.

for(i in 1:length(ids)){
  
  br.classified <- classification(ids[i], db="ncbi")
  
  write.table(br.classified[1], paste0('./',samp,'/',ids[i],'.txt'))
  
}

# remove all results that have a lower percent similarity than your threshold

blast.thresh <- blast.results[blast.results$V5 > threshold,]

# each locus can have more than one hit, so this makes a list of each locus name

locus.IDs <- unique(blast.thresh$V1)

# getTaxa is a function to return the most likely taxonomic ID of each sequence

getTaxa <- function(id){
  
  # get the results for a single locus
  
  ind.tmp <- blast.thresh[blast.thresh$V1==id,]
  
  # put the highest percent similarity hit at the top
  ind.tmp <- ind.tmp[rev(order(ind.tmp$V5)),]
  
  # remove sequences that don't have a kingdom affiliation
  ind.tmp <- ind.tmp[!ind.tmp$V4=="N/A",]
  
  # see if there are multiple kingdoms listed for the top hit(s)
  ind.max <- ind.tmp[ind.tmp$V5==max(ind.tmp$V5),]	
  
  # set up a vector to hold the classification results
  taxon <- rep(NA, 6)
  # put the locus name in the first element of the vector
  taxon[1] <- as.character(id)
  
  # find the number of kingdoms that match the top hit
  nKing <- length(unique(ind.max$V4)) 
  
  # if there is more than one kingdom, stop and report 'multiple' in the second element of the result vector
  if(nKing > 1){
    
    taxon[2] <- "multiple"
    
    # if there is one kingdom, fill the second element of the result vector with the kingdom name and fill the third element with the phylum
    
  }else if(nKing==1){
    taxon[2] <- as.character(unique(ind.max$V4))
  
	


    # query the verbal classification database to find if there are multiple phyla, no phylum names, or one phylum name. Fill the third element of the vector with this information
    # get the taxon ID number(s) to find the phylum
    phyla <- as.character(unique(ind.max$V3))
    phyla <- strsplit(as.character(phyla),";")
    phyla <- as.numeric(unlist(lapply(phyla, function(c){return(c[1])})))
    
    ### query the verbal classification database to find if there are multiple phyla, no phylum names, or one phylum name. Fill the third element of the vector with this information. Modified by Daniel Acosta in order to recover family, genus and species information too.
    phyNames <- c()
    
    for(i in 1:length(phyla)){
      phy.tmp <- read.table(paste0('./',samp,'/', phyla[i],'.txt'))
      
      if(sum(phy.tmp[,2]=='phylum') > 0){
        phyNames[i] <- as.matrix(phy.tmp[phy.tmp[,2]=='phylum',])[1,1]
      }else{phyNames[i] <- 'no phylum'}
      
    }
    if(length(unique(phyNames)) > 1){taxon[3] <- "multiple"}else{taxon[3] <- unique(phyNames)}
    
    
    
    famNames <- c()
    
    for(i in 1:length(phyla)){
      fam.tmp <- read.table(paste0('./',samp,'/', phyla[i],'.txt'))
      
      if(sum(fam.tmp[,2]=='family') > 0){
        famNames[i] <- as.matrix(fam.tmp[fam.tmp[,2]=='family',])[1,1]
      }else{famNames[i] <- 'no family'}
      
    }
    if(length(unique(famNames)) > 1){taxon[4] <- "multiple"}else{taxon[4] <- unique(famNames)}
    
    
    genNames <- c()
    
    for(i in 1:length(phyla)){
      gen.tmp <- read.table(paste0('./',samp,'/', phyla[i],'.txt'))
      
      if(sum(gen.tmp[,2]=='genus') > 0){
        genNames[i] <- as.matrix(gen.tmp[gen.tmp[,2]=='genus',])[1,1]
      }else{genNames[i] <- 'no genus'}
      
    }
    if(length(unique(genNames)) > 1){taxon[5] <- "multiple"}else{taxon[5] <- unique(genNames)}
    
    
    spNames <- c()
    
    for(i in 1:length(phyla)){
      sp.tmp <- read.table(paste0('./',samp,'/', phyla[i],'.txt'))
      
      if(sum(sp.tmp[,2]=='species') > 0){
        spNames[i] <- as.matrix(sp.tmp[sp.tmp[,2]=='species',])[1,1]
      }else{spNames[i] <- 'no species'}
      
    }
    if(length(unique(spNames)) > 1){taxon[6] <- "multiple"}else{taxon[6] <- unique(spNames)}
    
    
    
    
     
  }
  
  # return the filled vector of locus names, kingdom, and phylum
  return(taxon)
}


# loop over each locus and store the vector in a list

taxList <- list()

for(i in 1:length(locus.IDs)){
  
  taxList[[i]] <- getTaxa(locus.IDs[i])
  
}
  
  # make the list into a matrix
  tax <- do.call(rbind, taxList)

# write out the matrix into your directory
write.table(tax, paste("./",samp,"_tax.txt"))


