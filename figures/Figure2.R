library(tidyverse)
library(ggplot2)
library(scatterpie)
library(readxl)


dat<-read_delim("D:/000_PomePanGenome/Figures/Figure2/data/Orthogroups.GeneCount.tsv",
                delim = "\t",
                col_names = TRUE) %>% 
  select(-Total) %>% 
  column_to_rownames("Orthogroup")


dat %>% colnames()
dat %>% dim()

dat[1:6,1:6]

dat.backup<-dat
head(dat)

which(rowSums(dat)==0)

dat[dat>0] = 1

dat[1:6,1:6]

dat %>% 
  rownames_to_column() %>% 
  write_delim("D:/000_PomePanGenome/Figures/Figure2/data/family_matrix.txt",
              delim = "\t",col_names = FALSE)


df<-tibble(samples=character(),
           sampleNum=numeric(),
           Pan=numeric(),
           Core=numeric())

total_genome <- 6
sim<-100
samples<-dat %>% colnames()

for(i in 1:sim){
  if(i%%10==0){
    print(i)
  }
  sim_samples<-sample(samples,replace = F)
  sim_pav<-dat[,sim_samples]
  for(j in 1:ncol(dat)){
    subsim<-sim_pav[,1:j]
    
    if(j==1){
      Npan<-sum(subsim)
      Ncore<-Npan
    }else{
      sum<-rowSums(subsim)
      Ncore<-nrow(subsim[sum==j,])
      Npan<-nrow(subsim[sum>0,])
    }
    df<-add_row(df,samples=as.character(i),
                sampleNum=j,
                Pan=Npan,
                Core=Ncore)
  }
}


df %>% 
  select(-samples) %>% 
  pivot_longer(!sampleNum) %>% 
  mutate(sampleNum=factor(sampleNum,levels = 1:total_genome)) -> longer.df


p1<-ggplot(data=longer.df,aes(x=sampleNum,y=value))+
  geom_boxplot(aes(fill=name),
               outlier.alpha = 0,
               #width=1,
               linewidth=0.1)+
  theme_bw(base_size = 20)+
  theme(panel.grid = element_blank(),
        legend.position = c(0.8,0.5),
        legend.title = element_blank())+
  scale_fill_manual(values = c("Core"="#DC0000FF",
                               "Pan"="#2e89be"))+
  labs(x="Sample number",y="Family number")+
  scale_x_discrete(breaks = 1:6)

p1

dat %>% rowSums() %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  rename("Total"=".") %>%
  mutate(Class=case_when(
    Total == total_genome ~ "Core",
    #Total >= round(total_genome*0.9) & Total < total_genome ~ "SoftCore",
    Total < 6 & Total >= 2 ~ "Dispensable",
    Total == 1 ~ "Private"
  )) %>%
  mutate(Class=factor(Class,levels = c("Core","Dispensable","Private")))-> freq.df


freq.df %>% 
  pull(Class) %>% table() %>% 
  as.data.frame() %>% 
  rename("Class"=".") %>% 
  pivot_wider(names_from = Class,
              values_from = Freq) %>%
  mutate(x=1,y=1,region=1) -> pie.df
pie.df

#19527        8494     293
19527+8494+293
19527/28314
8494/28314
p2<-ggplot()+
  geom_scatterpie(data=pie.df,
                  aes(x,y,group=region,r=1),
                  cols=c("Core","Dispensable","Private"),
                  color=NA)+
  theme_void()+
  coord_equal()+
  scale_fill_manual(values = c("Core"="#2e89be",
                               "Dispensable"="#179437",
                               "Private"="#DC0000FF"))+
  theme(legend.position = "none")+
  annotate(geom = "text",x=1.4,y=1,label="Core\n19527 (68.96%)",size=3)+
  annotate(geom = "text",x=0.6,y=1.2,label="Dispensable\n8494 (30.00%)",size=3)+
  annotate(geom = "text",x=0.6,y=2.1,label="Private\n293 (1.04%)",size=3)+
  annotate(geom="segment",x=0.95,xend = 0.85,y=2,yend=2.05)

p2
freq.df %>% head()

dat %>% head()

nrow(dat)

for(i in 1:6){
  
  print(dat %>% 
    select(colnames(dat)[i]) %>% 
    pull(colnames(dat)[i]) %>% sum())
}

petal.df01<-read_excel("D:/000_PomePanGenome/Figures/Figure2/data/petal.xlsx")
petal.df01
x<-1:(6*30)
y<-sin(6*x*pi/180)
petal.df02<-data.frame(x1=x,y1=abs(y),
                       var=gl(6,30,labels = LETTERS[1:6]))
petal.df02
petal.df<-left_join(petal.df02,petal.df01,by=c("var"="group"))

petal.df

p3<-ggplot()+
  geom_area(data = data.frame(x=1:180,y=0.7),
            aes(x=x,y=y),
            fill="#ecccea",
            alpha=1)+
  ggnewscale::new_scale_fill()+
  geom_area(data=petal.df02,aes(x=x1,y=y1,fill=var),
            #fill="blue",
            alpha=0.8)+
  #scale_x_continuous(expand = expansion(mult = c(0,0)))+
  scale_fill_manual(values = c("#ff8e54","#f63c50","#0088bf","#77d793",
                               "#e1f594","#ffe087","#ffffbe"))+
  coord_polar()+
  geom_area(data = data.frame(x=1:180,y=0.3),
            aes(x=x,y=y),
            fill="#ebccea",
            alpha=1,show.legend = FALSE)+
  theme_void()+
  geom_text(data=petal.df %>% filter(y1==1),
            aes(x=x1,y=y1+0.2,label=cultivar),
            fontface="italic")+
  geom_text(data=petal.df %>% filter(y1==1),
            aes(x=x1,y=y1-0.1,label=private))+
  geom_text(data=petal.df %>% filter(y1==1),
            aes(x=x1,y=y1-0.5,label=total-core-private))+
  annotate(geom = "text",x=1,y=0,label="Core 19527")+
  theme(legend.position = "none")

p3

### 结构域的注释比例

orthogroups<-read_delim("D:/000_PomePanGenome/Figures/Figure2/data/Orthogroups.tsv",
                        delim = "\t",
                        col_names = TRUE)

head(orthogroups)

identical(orthogroups$Orthogroup,freq.df$rowname)

bind_cols(orthogroups,freq.df) %>% 
  select(-c(rowname,Total,Orthogroup)) %>% 
  pivot_longer(!Class) %>% 
  filter(Class=="Private") %>% 
  na.omit() %>% 
  pull(value) %>% 
  str_split(pattern = ", ") %>% 
  unlist() %>% 
  write_lines(file = "D:/000_PomePanGenome/Figures/Figure2/data/allPrivateID.txt")


bind_cols(orthogroups,freq.df) %>% 
  #mutate(X1=str_count(V127,"mRNA1")) %>% 
  #filter(X1>=2) %>% 
  select(-c(rowname,Total,Orthogroup)) %>% 
  pivot_longer(!Class) %>% 
  filter(Class=="Dispensable") %>% 
  na.omit() %>% 
  pull(value) %>% 
  str_split(pattern = ", ") %>% 
  unlist() %>% 
  write_lines(file = "D:/000_PomePanGenome/Figures/Figure2/data/allDispensableID.txt")


bind_cols(orthogroups,freq.df) %>% 
  #mutate(X1=str_count(V127,"mRNA1")) %>% 
  #filter(X1>=2) %>% 
  select(-c(rowname,Total,Orthogroup)) %>% 
  pivot_longer(!Class) %>% 
  filter(Class=="Core") %>% 
  na.omit() %>% 
  pull(value) %>% 
  str_split(pattern = ", ") %>% 
  unlist() %>% 
  write_lines(file = "D:/000_PomePanGenome/Figures/Figure2/data/allCoreID.txt")

myfun<-function(x){
  return(read_delim(x,delim = "\t",comment = "##") %>% 
           select(`#query`,PFAMs))
}

list.files("06.emapper.collections/",pattern = "*.annotations",full.names = TRUE)%>%
  map(myfun)%>%
  bind_rows() -> allemapperPfams

save(allemapperPfams,file = "allemapperPfams.Rdata")


load("D:/000_PomePanGenome/Figures/Figure2/data/allemapperPfams.Rdata")

allemapperPfam

read_delim("D:/000_PomePanGenome/Figures/Figure2/data/allCoreID.txt",
           delim = "\t",col_names = FALSE)%>%
  left_join(allemapperPfam,by=c("X1"="#query"))%>% 
  mutate(PFAMs=replace_na(PFAMs,"-")) %>% 
  mutate(group=case_when(
    PFAMs == "-" ~ "nodomain",
    TRUE ~ "domain"
  )) %>% pull(group) %>% table()

read_delim("D:/000_PomePanGenome/Figures/Figure2/data/allDispensableID.txt",
           delim = "\t",col_names = FALSE)%>%
  left_join(allemapperPfam,by=c("X1"="#query"))%>% 
  mutate(PFAMs=replace_na(PFAMs,"-")) %>% 
  mutate(group=case_when(
    PFAMs == "-" ~ "nodomain",
    TRUE ~ "domain"
  )) %>% pull(group) %>% table()

read_delim("D:/000_PomePanGenome/Figures/Figure2/data/allPrivateID.txt",
           delim = "\t",col_names = FALSE)%>%
  left_join(allemapperPfam,by=c("X1"="#query"))%>% 
  mutate(PFAMs=replace_na(PFAMs,"-")) %>% 
  mutate(group=case_when(
    PFAMs == "-" ~ "nodomain",
    TRUE ~ "domain"
  )) %>% pull(group) %>% table()

p4<-data.frame(nodomain=c(21475,19006,431),
           domain=c(114221,15232,577),
           Class=c("Core","Dispensable","Private"))%>% 
  pivot_longer(!Class) %>% 
  mutate(Class=factor(Class,levels = c("Core","Dispensable","Private")),
         name=factor(name,levels = c("nodomain","domain"))) %>% 
  ggplot(aes(x=Class,y=value))+
  geom_bar(stat="identity",
           aes(fill=name),
           position="fill",show.legend = FALSE)+
  theme_bw(base_size = 20)+
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(),
        axis.text.x = element_text(angle = 60,hjust = 1,vjust=1))+
  scale_y_continuous(expand = expansion(mult = c(0,0)))+
  labs(x=NULL,y="Annotated domain")+
  scale_fill_manual(values = c("gray","#007AC1FF"))

p4
### kaks

orthogroups

dat.backup %>% head()
dat.backup %>% colnames()
dat.backup %>% 
  filter(azerbaijan==1&bhagwa==1&dabenzi==1&taishanhong==1&tunisia==1&ys==1) %>% 
  rownames_to_column() %>% 
  left_join(orthogroups,by=c("rowname"="Orthogroup")) %>% 
  select(8:13) %>% 
  write_delim("D:/000_PomePanGenome/Figures/Figure2/data/kaks_core_id.txt",
              delim = "\t",col_names = FALSE)
dat.backup %>% 
  filter(azerbaijan<=1)%>% 
  filter(bhagwa<=1)%>% 
  filter(dabenzi<=1)%>% 
  filter(taishanhong<=1)%>% 
  filter(tunisia<=1)%>% 
  filter(ys<=1) %>% 
  filter(!(azerbaijan==1&bhagwa==1&dabenzi==1&taishanhong==1&tunisia==1&ys==1)) %>% 
  rowSums() %>%
  as.data.frame() %>%
  rownames_to_column() %>% 
  rename("Class"=".") %>% 
  filter(Class>=2) %>% 
  left_join(orthogroups,by=c("rowname"="Orthogroup")) %>%
  select(3:8) %>% 
  write_delim("D:/000_PomePanGenome/Figures/Figure2/data/kaks_dispen_id.txt",
              delim = "\t",col_names = FALSE)

read_delim("D:/000_PomePanGenome/Figures/Figure2/data/kaksvalue.txt",
           delim = "\t",
           col_names = FALSE) %>% 
  na.omit() %>%
  filter(X1>0&X1<=3) %>%
  aov(X1~X2,data=.) -> kaks.aov
summary(kaks.aov)


p5<-read_delim("D:/000_PomePanGenome/Figures/Figure2/data/kaksvalue.txt",
           delim = "\t",
           col_names = FALSE) %>% 
  na.omit() %>%
  filter(X1>0&X1<=3) %>% 
  ggplot(aes(x=X2,y=X1))+
  geom_violin(aes(fill=X2))+
  geom_boxplot(aes(fill=X2),
               width=0.2,
               outlier.alpha = 0)+
  theme_bw(base_size = 20)+
  theme(legend.position = "none",
        panel.grid = element_blank())+
  labs(x=NULL,y="Ka/Ks value")+
  scale_fill_manual(values = c("#38aa8a","#4394c4"))+
  annotate(geom="segment",x=1,xend=2,y=3.1,yend=3.1)+
  annotate(geom="text",x=1.5,y=3.15,label="***",size=10)+
  scale_x_discrete(labels=c("Core","Dispensable"))
p5

### 核苷酸多样性
library(tidyverse)
library(pegas)

myfun<-function(x){return(nuc.div(read.dna(x,format = "fasta")))}
list.files("pi.core/",pattern = "*.fasta",full.names = TRUE)%>%map(myfun)%>%unlist() -> core.div
list.files("pi.dispen/",pattern = "*.fasta",full.names = TRUE)%>%map(myfun)%>%unlist() -> dispen.div

bind_rows(data.frame(div=core.div,group="core"),
          data.frame(div=dispen.div,group="dispensable")) %>% 
  write_delim(file = "nucle_diversity.txt",delim = "\t")

read_delim("D:/000_PomePanGenome/Figures/Figure2/data/nucle_diversity.txt",
           delim = "\t") %>% 
  filter(div>0) %>%
  aov(div~group,data=.) %>% 
  summary()

p6<-read_delim("D:/000_PomePanGenome/Figures/Figure2/data/nucle_diversity.txt",
           delim = "\t") %>% 
  filter(div>0) %>% 
  ggplot(aes(x=group,y=log10(div)))+
  geom_violin(aes(fill=group))+
  geom_boxplot(aes(fill=group),width=0.3)+
  theme_bw(base_size = 20)+
  theme(legend.position = "none",
        panel.grid = element_blank())+
  labs(x=NULL,y="nucleotide diversity")+
  scale_fill_manual(values = c("#38aa8a","#4394c4"))+
  scale_y_continuous(breaks = -4:0,
                     labels = c("0.0001",0.001,0.01,0.1,1))+
  scale_x_discrete(labels=c("Core","Dispensable"))+
  annotate(geom="segment",x=1,xend=2,y=0.1,yend=0.1)+
  annotate(geom="text",x=1.5,y=0.15,label="***",size=10)

p6


library(patchwork)

p1+p5+p6+p4+p5+p6+
  plot_layout(ncol = 3)+
  plot_annotation(tag_levels = "A")


322868188/331473998 
296847911/320494280

27901176364/355866374
