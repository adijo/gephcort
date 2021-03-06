#!/usr/bin/Rscript

####################################################################################
# This short script is a part of gephcort package v1.0
# 
# Script outline:
#    1) Read input files:
#          - Sequence file
#          - Maximum likelihood weighted tree file (in newick format)
#          - Type of sequence file (fasta or phylip)
#
#    2) Perform maximum likelihood ancestral sequence reconstruction using 
#       phangorn package
#          - Note that phangorn reports probability values for sequence patterns
#
#    3) For individual character state probabilities, choose the optimal character
#       with highest probability
#
#    4) Create processed tabulated output of optimal characters at ancestral states
#           - Note that this output will be required for reanimate.py
#
# For any queries related to script, contact: Amol Kolte (amolkolte1989@gmail.com)
#
####################################################################################

args <- commandArgs(TRUE)

## Default setting when no arguments passed
if(length(args) < 4) {
  args <- c("--help")
}
 
## Help section
if("--help" %in% args) {
  cat("
      The R Script
 
      Arguments:
      <alignment_seq_file>   - Sequence file
      <newick_tree_file>     - Newick tree file
      <fasta/phylip>         - Sequence file format (fasta or phylip)
      <ressurect_output.dat> - Output file name
      --help                 - print this text
 
      Example:
      ./test.R <alignment_seq_file> <newick_tree_file> <fasta/phylip> <ressurect_output.dat> \n\n")
 
  q(save="no")
}

library(methods)
library(phangorn)

tree <- read.tree(args[2])

chrseq <- read.phyDat(args[1], format=args[3])

fit <- pml(tree,chrseq)
temp <- ancestral.pml(fit, type="ml")

ptab = array(dim=c(length(temp), length(temp[[1]])/4))

locmax <- function(list) {

# locmax function takes probability values for each ancestral character
# state as input list


    if (list[1]==list[2] && list[3]==list[4])
    {
        return (18)
    }    
    else
    {
        for (i in seq(1, length(list)))
        {
            if (max(list) == list[i])
            {
                return (i)
            }
        }
    }    
}


for (h in 1:length(temp)) {
    for (j in 1:(length(temp[[1]])%/%4))
    {
        ptab[h, j] <- locmax(temp[[h]][j,])
    }
}

write.table(ptab, args[4], col.name=F, row.names=names(temp))
