#!/bin/sh
#$ -S /bin/bash
#$ -pe def_slot 18
#$ -l exclusive,s_vmem=10G,mem_req=10G
##$ -o /dev/null
##$ -e /dev/null
##$ -t 1-2:1

#align using MAFFT
./mafft.bat ${name}.input.fasta > ${name}.output.aligned.fasta

#replaces any characters not in 'ATGCN-' characters with 'N'
python3.11 clean_fasta.py ${name}.output.aligned.fasta > ${name}.aligned.cleaned.fasta

#trim uncertain sites
trimal \
-in ${name}.aligned.cleaned.fasta \
-out ${name}.aligned.cleaned.trimmed.fasta \
-htmlout /dev/null \
-gt 0.1

#construction of the tree
iqtree2 \
  -s ${name}.aligned.cleaned.trimmed.fasta \
  -nt AUTO -mem 8G -m GTR -bb 1000

#done
#convert the tree file into a newick file for phylogenetic_tree_visualization.R script
