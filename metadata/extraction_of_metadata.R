#!/usr/bin/env R

library(xml2)

xml_file_path <- "sequence.gbc.xml"
xml_data <- read_xml(xml_file_path)
source_features <- xml_find_all(xml_data, "//INSDFeature[INSDFeature_key = 'source']")
definition_features <- xml_find_all(xml_data, "//INSDSeq[INSDSeq_definition]")

accession_names <- data.frame(matrix(nrow = 53, ncol = 13))
colnames(accession_names) <- c("Species", "Genus", "Family", "Gene-encoded", "Accession-number", "Definition", "Organism", "strain", "isolate-name", "collection-date", "Country", "Host", "Note")
accession_names$Species[1:53] <- "MERS-CoV"
accession_names$Genus[1:53] <- "Betacoronavirus"
accession_names$Family[1:53] <- "Coronaviridae"
accession_names$`Gene-encoded`[1:53] <- "complete-genome"

for (i in 1:length(source_features)) {
  definition <- xml_text(xml_find_first(definition_features[i], "./INSDSeq_definition"))
  accession <- xml_text(xml_find_first(source_features[i], ".//INSDInterval_accession"))
  organism <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'organism']/INSDQualifier_value"))
  isolate_name <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'isolate']/INSDQualifier_value"))
  date <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'collection_date']/INSDQualifier_value"))
  country <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'country']/INSDQualifier_value"))
  host <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'host']/INSDQualifier_value"))
  strain <- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'strain']/INSDQualifier_value"))
  note<- xml_text(xml_find_first(source_features[i], ".//INSDQualifier[INSDQualifier_name = 'note']/INSDQualifier_value"))
  
  accession_names$Definition[i] <- definition
  accession_names$`Accession-number`[i] <- accession
  accession_names$Organism[i] <- organism
  accession_names$strain[i] <- strain
  accession_names$`isolate-name`[i] <- isolate_name
  accession_names$`collection-date`[i] <- date
  accession_names$Country[i] <- country
  accession_names$Host[i] <- host
  accession_names$Note[i] <- note
  
  cat("Definition:", definition, "\n")
  cat("Accession:", accession, "\n")
  cat("Organism:", organism, "\n")
  cat("Strain:", strain, "\n")
  cat("Isolate Name:", isolate_name, "\n")
  cat("Collection Date:", date, "\n")
  cat("Country:", country, "\n")
  cat("Host:", host, "\n")
  cat("Note:", note, "\n")
  cat("\n")
}

View(accession_names)

###export-the-file-as-excel###
library(openxlsx)
filename <- "$filename.xlsx"
write.xlsx(accession_names, file = filename, rowNames = TRUE)
cat("Data frame exported successfully to", filename)

#end
