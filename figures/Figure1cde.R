library(tidyverse)
library(ggplot2)
library(ggridges)
library(ggforce)
library(clusterProfiler)

dat.fig1c<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/InsDelInvTrans_Len.txt",
                      delim = "\t",
                      col_names = FALSE) %>% 
  filter(X4 >= 50)
dat.fig1c %>% 
  pull(X3) %>% table()

fig1c<-ggplot(data=dat.fig1c,
       aes(x=log10(X4),y=X3))+
  geom_density_ridges(aes(fill=X3))+
  theme_bw(base_size = 15)+
  theme(panel.grid = element_blank(),
        legend.position = "none",
        axis.text.x = element_text(angle=60,hjust=1,vjust = 1))+
  labs(x="The length of Structure Variation (bp)",y=NULL)+
  scale_y_discrete(labels=c("Deletion","Insertion","Inversion","Translocation"))+
  scale_x_continuous(breaks = 1:6,
                     labels = c(10,100,1000,10000,"100000","1000000"))

fig1c
dat.fig1d<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/all.anno.variant_function",
                      delim = "\t",
                      col_names = FALSE)
dat.fig1d
dat.fig1c %>% 
  mutate(X5=paste(X1,X2,sep="_")) %>% 
  left_join(dat.fig1d %>% 
              mutate(X11=paste(X3,X4,sep="_")),
            by=c("X5"="X11")) %>% 
  pull(X1.y) %>% 
  table()

dat.fig1d1<-data.frame(x=c("downstream","exonic","intergenic","intronic","upstream"),
                       y=c(68+24,38,354,137,101+24))
dat.fig1d1
92/(92+38+354+137+125)
38/(92+38+354+137+125)
354/(92+38+354+137+125)
137/(92+38+354+137+125)
125/(92+38+354+137+125)
dat.fig1d1 %>% 
  mutate(new_y=y/sum(y))
fig1d<-ggplot()+
  geom_arc_bar(data=dat.fig1d1,
               stat="pie",
               aes(x0=0,y0=0,r0=0,r=2,
                   amount=y,fill=x))+
  theme_void()+
  theme(legend.position = "none")+
  coord_equal()+
  scale_fill_manual(values = c("#64e200","#fae800","#ffa700","#ff3800","#5a2a8f"))


fig1d+
  annotate(geom = "text",x=0.5,y=1.5,label="downstream\n92 (12.33%)")+
  annotate(geom = "text",x=1.9,y=1.3,label="exonic\n38 (5.09%)")+
  annotate(geom = "text",x=0.5,y=-1,label="intergenic\n354 (47.45%)")+
  annotate(geom = "text",x=-1,y=0,label="intronic\n137 (18.36%)")+
  annotate(geom = "text",x=-0.5,y=1,label="intronic\n125 (16.75%)",
           color="white") -> fig1d


df.TE01<-data.frame(x=c("A","B","C"),
                    y=c(25.73,12.16,0.68))
25.73/sum(c(25.73,12.16,0.68))
12.16/sum(c(25.73,12.16,0.68))
17.15/sum(c(25.73,12.16,0.68))
8.58/sum(c(25.73,12.16,0.68))
8.01/sum(c(25.73,12.16,0.68))
1.12/sum(c(25.73,12.16,0.68))
0.3/sum(c(25.73,12.16,0.68))
2.73/sum(c(25.73,12.16,0.68))
0.68/sum(c(25.73,12.16,0.68))

df.TE02<-data.frame(x=c("a","b","c","d","e","f","g","h"),
                    y=c(17.15,8.58,8.01,1.12,0.3,2.73,0.09,0.59))
fig1g<-ggplot()+
  geom_arc_bar(data=df.TE01,
               stat="pie",
               aes(x0=0,y0=0,r0=0,r=2,
                   amount=y,fill=x),
               show.legend = FALSE,
               linewidth=0.5)+
  theme_bw()+
  theme(panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  coord_equal(clip = "off")+
  scale_fill_manual(values = c("white","white","white"))+
  annotate(geom = "text",x=1,y=0,label="LTR\n66.71%",size=2)+
  annotate(geom = "text",x=-1,y=0.2,label="DNA\n31.52%",size=2)+
  annotate(geom = "text",x=-0.5,y=1.5,label="",size=2)+
  ggnewscale::new_scale_fill()+
  geom_arc_bar(data=df.TE02,
               stat="pie",
               aes(x0=0,y0=0,r0=2.1,r=3.1,
                   amount=y,fill=x),
               show.legend = FALSE,
               linewidth=0.1)+
  scale_fill_manual(values = c("#ffe699","#c6deb5","#c7c7c7","#ff9999",
                               "#99ffff","#f8cbad","#c6acd9","#99dff9"))+
  annotate(geom = "text",x=1.8,y=1.9,label="Gypsy\n44.46%",size=2)+
  annotate(geom = "text",x=-0.6,y=-2.4,label="Copia\n22.24%",size=2)+
  annotate(geom = "text",x=-2.5,y=0,label="hobo-Activator\n20.76%",size=2,angle=90)+
  annotate(geom = "text",x=-3,y=2.4,label="Tc1-IS630-Pogo\n2.91%",size=2)+
  annotate(geom = "text",x=-2,y=2.8,label="MULE-MuDR\n0.78%",size=2)+
  annotate(geom = "text",x=-1.4,y=3.2,label="Tourist/Harbinger\n7.07%",size=2)+
  annotate(geom = "text",x=-0.3,y=3.5,label="Line and SINE\n1.76%",size=2)

fig1g

dat.fig1c %>% 
  mutate(X5=paste(X1,X2,sep="_")) %>% 
  left_join(dat.fig1d %>% 
              mutate(X11=paste(X3,X4,sep="_")),
            by=c("X5"="X11")) %>% 
  select(6,7) %>% 
  filter(X1.y!="intergenic") %>% 
  filter(X1.y!="splicing") %>% pull(X2.y) %>% 
  str_replace_all(pattern = "\\(dist=[0-9]+\\)","") %>% 
  str_split(pattern = ",|;") %>% 
  unlist() -> gene.list

gene.list

term2gene<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/term2gene.txt",
                      delim = "\t",col_names = FALSE)
term2gene

term2name<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/go.tb",delim = "\t")
term2name


sv.enrich<-enricher(gene = gene.list,
                    pAdjustMethod = "none",
         TERM2NAME = term2name,
         TERM2GENE = term2gene,
         pvalueCutoff = 0.05,
         qvalueCutoff = 0.05) 
dotplot(sv.enrich)

sv.enrich@result %>% select(-geneID)
sv.enrich@result %>% filter(pvalue<0.01) %>% 
  left_join(term2name %>% select(-2),by=c("ID"="GO")) %>% 
  select(-geneID) %>% 
  select(Description,Count,level) %>% 
  arrange(level,desc(Count)) %>% 
  mutate(Description=factor(Description,levels = Description)) %>% 
  ggplot(aes(y=Description,x=Count))+
  geom_col(aes(fill=level))+
  geom_text(aes(x=0.11,label=Description),hjust=0)+
  theme_bw(base_size = 15)+
  theme(panel.grid = element_blank(),
        #axis.text.x = element_text(angle=60,hjust=1,vjust=1),
        legend.position = "top",
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())+
  scale_x_continuous(expand = expansion(mult=c(0,0)))+
  scale_fill_manual(values = c("#3ba889","#4593c3","#f18e0c"),
                    labels=c("Biological Process",
                             "Cellular Component","Molecular Function"),
                    name=NULL) -> fig1e
fig1e

library(patchwork)

fig1d
fig1g
fig1c
fig1e
fig1c/fig1e +
  plot_layout(heights = c(0.5,1))


pdf(file = "fig1a_blank.pdf",width=16,height = 14)

ggplot()+
  annotate(geom = "segment",x=1,xend=16,y=6,yend=6,lty="dashed")+
  annotate(geom = "segment",x=1,xend=16,y=10,yend=10,lty="dashed")+
  annotate(geom = "segment",x=8,xend=8,y=1,yend=14,lty="dashed")+
  annotate(geom = "segment",x=12,xend=12,y=1,yend=14,lty="dashed")+
  theme_void()

dev.off()


(29141+28814+30987+28530+28192)/5
