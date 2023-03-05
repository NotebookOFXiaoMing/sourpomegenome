```

## 参考链接 http://git.genek.cn:3333/zhxd2/emcp
emapper <- read_delim("D:/Bioinformatics_Intro/pome_genome/20230209/genome/maker/MM_tefs5h49.emapper.annotations.tsv", 
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

emapper %>% head() %>% DT::datatable()


gene_info <- dplyr::select(emapper,  GID, Gene_Name) %>%
  dplyr::filter(!is.na(Gene_Name)) %>%
  dplyr::filter(Gene_Name != '-') 
gene_info
gene2go <- dplyr::select(emapper, GID, GO) %>%
  separate_rows(GO, sep = ',', convert = F) %>%
  filter(!is.na(GO)) %>%
  filter(str_detect(GO, '^GO')) %>%
  mutate(EVIDENCE = 'IEA') 
gene2go
save(gene_info,gene2go,file = "geneinfogene2go.Rdata")

library(AnnotationForge)
load("geneinfogene2go.Rdata")

makeOrgPackage(gene_info=gene_info,go=gene2go,maintainer = "MingYan <mingyan24@126.com
    >",author = "MingYan",outputDir = "./",tax_id = 22663,genus = "Punica",species = "gran
    atum",goTable = "go",version = "1.0")

 pkgbuild::build(".//org.Pgranatum.eg.db",dest_path = ".")
 
```
