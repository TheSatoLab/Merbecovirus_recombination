#!/usr/bin/env R

library(treeio)
library(data.table)
library(ggtree)
library(ggplot2)
library(dplyr)
library(ape)
library(stats)
library (phytools)

setwd("/Users/JarelElginTolentino/Desktop/Dissertation/phylogenetic-analysis/projects/Merbecovirus/Merbecovirus-recombination/final/excel-table")
#/Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/library/treeio/
nwk <- system.file("{recombination-free}.nwk", package = "treeio")
tree1 <- read.tree(nwk)
tree1$tip.label <- gsub("'", "", tree1$tip.label)

nwk.1 <- system.file("{RBD}.nwk", package = "treeio")
tree2 <- read.tree(nwk.1)
tree2$tip.label <- gsub("'", "", tree2$tip.label)

metadata <- fread("metadata.csv", header = TRUE, check.names = TRUE)
metadata$V1 <- NULL
metadata <- metadata %>% mutate(Notes = ifelse(Strain.name == "NeoCoV", "NeoCoV", Notes))
metadata <- metadata %>% mutate(Notes = ifelse(Strain.name == "PDF-2180", "PDF-2180", Notes))

color.matching <- c(
    "SC2013" = "#FFA500",
    "VsCoV-kj15" = "#FFA500",
    "HKU25" = "#FFA500",
    "BtCoV-422" = "#FFA500",
    "EjCoV-3" = "#FFA500",
    "NeoCoV" = "#0433FF",
    "HCoV-EMC-2012" = "#02686B",
    "PDF-2180" = "#FF2600",
    "MOW15-22" = "#D67A25",
    "PnNL2018B" = "#D67A25",
    "PaGB01" = "#FFA500",
    "LMH1f" = "#0080AA",
    "B04f" = "#0080AA",
    "SM3A" = "#0080AA",
    "GZ131656" = "#0080AA",
    "BtCoV/133" = "#0080AA",
    "GX2012" = "#0080AA",
    "MjHKU4-1" = "#00ACE5",
    "TT07f" = "#AF4422",
    "LMH03f" = "#AF4422",
    "GD2013" = "#AF4422",
    "BY140568" = "#AF4422",
    "Erinaceus-216" = "#C6AF46",
    "HKU31" = "#C6AF46"
  )

tree1$tip.color <- rep("#000000", length(tree1$tip.label))

for (i in 1:length(tree1$tip.label)) {
  tip_label <- tree1$tip.label[i]
  if (tip_label %in% names(color.matching)) {
    tree1$tip.color[i] <- color.matching[tip_label]
  }
}

tanglegram <- cophylo(tree1, tree2, rotate = TRUE)

pdf.name <- 'tanglegram.pdf'
pdf(pdf.name,width=6,height=5)
plot(tanglegram, link.type="curved",link.lwd=4,
     link.lty="solid",link.col=make.transparent(color.matching, 0.25))
dev.off()

#done
