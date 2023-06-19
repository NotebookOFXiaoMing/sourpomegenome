library(tidyverse, quietly = TRUE)
library(formattable, quietly = TRUE)
#BiocManager::install("AnnotationForge")
library(AnnotationForge, quietly = TRUE)
library(seqinr, quietly = TRUE)
library(clusterProfiler, quietly = TRUE)

emapper <- read_delim("six.pome.pep.emapper.annotations", 
                      "\t", escape_double = FALSE, col_names = FALSE, 
                      comment = "#", trim_ws = TRUE) %>%
  dplyr::select(GID = X1, 
                COG = X7,
                Gene_Name = X8,
                Gene_Symbol = X9,
                GO = X10,
                KO = X12,
                Pathway = X13
  )

gene_info <- dplyr::select(emapper,  GID, Gene_Name) %>%
  dplyr::filter(!is.na(Gene_Name)) %>%
  dplyr::filter(Gene_Name != '-') 
eggnog_anno <- length(gene_info$GID)


gene2go <- dplyr::select(emapper, GID, GO) %>%
  separate_rows(GO, sep = ',', convert = F) %>%
  filter(!is.na(GO)) %>%
  filter(str_detect(GO, '^GO')) %>%
  mutate(EVIDENCE = 'IEA') 


makeOrgPackage(gene_info=gene_info,
               go=gene2go,
               maintainer='MingYan <mingyan24@126.com>',
               author='MingYan',
               outputDir="./",
               tax_id=22663,
               genus='P',
               species='g',
               goTable="go",
               version="1.0")

pkgbuild::build('./org.Pg.eg.db', dest_path = ".")
