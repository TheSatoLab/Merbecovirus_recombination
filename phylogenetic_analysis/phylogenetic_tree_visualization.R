#!/usr/bin/env R

library(treeio)
library(data.table)
library(ggtree)
library(ggplot2)
library(dplyr)

#/Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/library/treeio/ 
nwk <- system.file("extdata/MERS-CoV", "{name}.nwk", package = "treeio")
tree <- read.tree(nwk)
tree$tip.label <- gsub("'", "", tree$tip.label)

metadata <- fread("{name}.csv", header = TRUE, check.names = TRUE)
metadata$V1 <- NULL
metadata <- metadata %>% mutate(Notes = ifelse(Strain.name == "NeoCoV", "NeoCoV", Notes))
metadata <- metadata %>% mutate(Notes = ifelse(Strain.name == "PDF-2180", "PDF-2180", Notes))

groupList <- as.list(NULL)
for (i in 1:nrow(metadata)) {
  tip.name <- as.character(metadata[i, ]$Strain.name)
  tip.class <- as.character(metadata[i, ]$Notes)
  if (!tip.class %in% names(groupList)) {
    groupList[[tip.class]] <- as.vector(NULL)
  }
  groupList[[tip.class]] <- c(groupList[[tip.class]], tip.name)
}

tree <- groupOTU(tree, groupList)

color.matching <- c(
  "MERS-CoV" = "#02686B",
  "Hedgehog-CoV-1" = "#C6AF46",
  "HKU5" = "#AF4422",
  "HKU4" = "#0080AA",
  "pangolin-HKU4" = "#00ACE5",
  "NeoCoV" = "#0433FF",
  "group_2_Bat-MERS-related-CoV" = "#D67A25",
  "group_3_Bat-MERS-related-CoV" = "#FFA500",
  "PDF-2180" = "#FF2600",
  "SARS-CoV-2" = "#67468C",
  "SARS-CoV" = "#802780"
)

#original-tree-for-testing
g <- ggtree(tree) + 
  geom_tippoint(aes(color = group)) + theme(legend.position='none') + 
  geom_text2(aes(subset=!isTip, label=node), size=5, hjust=1.3, alpha=0.75) +
  scale_color_manual(values = color.matching)
n.seq <- length(tree$tip.label)
g <- g + ylim(0,n.seq + 50)+ geom_treescale(fontsize=5,x=0,y=n.seq,offset=10)
g

#original-tree with Sarbecovirus
tree2 <- groupClade(tree, c(57, 59, 61, 88, 95, 96, 101, 104, 105)) #clade number is based from the tree
g2 <- ggtree(tree2, aes(color=group)) + theme(legend.position='none') +
  geom_tiplab() +
  #geom_tippoint(aes(color = group), size=0.5) + theme(legend.position='none') + #use it only if you want to check if the color.matching is correct
  scale_color_manual(values=c("black", "#FFA500", "#D67A25", "#02686B", "#0080AA", "#00ACE5", "#AF4422", "#C6AF46", "#802780", "#67468C"))
g2

pdf.name <- 'mers-genome.pdf'

pdf(pdf.name,width=6,height=5)
plot(g2)
dev.off()

#1st tree
tree3 <- groupClade(tree, c(52, 54, 57, 83, 90, 91, 96)) #clade number is based from the tree
g3 <- ggtree(tree3, aes(color=group)) + theme(legend.position='none') + geom_tiplab() +
  scale_color_manual(values=c("black", "#FFA500", "#D67A25", "#02686B", "#0080AA", "#00ACE5", "#AF4422", "#C6AF46"))
g3

pdf.name <- '1st-tree.pdf'

pdf(pdf.name,width=6,height=5)
plot(g3)
dev.off()

#2nd tree (recombined insert)
tree4 <- groupClade(tree, c(54, 55, 57, 67, 74, 75, 94, 95, 96)) #clade number is based from the tree
g4 <- ggtree(tree4, aes(color=group)) + theme(legend.position='none') + geom_tiplab() +
  scale_color_manual(values=c("black", "#FFA500", "#FFA500", "#AF4422", "#0080AA", "#00ACE5", "#02686B", "#D67A25", "#D67A25", "#C6AF46"))
g4

pdf.name <- '2nd-tree.pdf'

pdf(pdf.name,width=6,height=5)
plot(g4)
dev.off()


#3rd tree
tree5 <- groupClade(tree, c(52, 54, 56, 83, 90, 91, 96)) #clade number is based from the tree
g5 <- ggtree(tree5, aes(color=group)) + theme(legend.position='none') + geom_tiplab() +
  geom_text2(aes(subset=!isTip, label=node), size=5, hjust=1.3, alpha=0.75) +
  scale_color_manual(values=c("black", "#FFA500", "#D67A25", "#02686B", "#0080AA", "#00ACE5", "#AF4422", "#C6AF46"))
g5

pdf.name <- '3rd-tree.pdf'

pdf(pdf.name,width=6,height=5)
plot(g5)
dev.off()

#done
