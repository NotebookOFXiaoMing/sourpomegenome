library(tidyverse)
library(circlize)

ref<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/chr.size",
                delim = "\t",
                col_names = FALSE)%>% 
  rename("Genome"="X1",
         "Length"="X2") %>% 
  arrange(desc(Length)) %>% 
  mutate(Genome=factor(Genome,Genome))

ref

brk <- c(0,10,20,30,40,50,60,70)*10^6
brk_label<-paste0(c(0,10,20,30,40,50,60,70),"M")
col_text <- "black"


circos.clear()

circos.par(#"track.height"=0.8,
  gap.degree=5,start.degree =86,clock.wise = T,
  cell.padding=c(0,0,0,0))
circos.initialize(factors=ref$Genome,          
                  xlim=matrix(c(rep(0,8),ref$Length),ncol=2))
circos.track(ylim=c(0,1),panel.fun=function(x,y) {
  Genome=CELL_META$sector.index
  xlim=CELL_META$xlim
  ylim=CELL_META$ylim
  circos.text(mean(xlim),mean(ylim),Genome,cex=1,col=col_text,
              facing="bending.inside",niceFacing=TRUE)
},bg.col="grey90",bg.border=F,track.height=0.06)


circos.track(track.index = get.current.track.index(), panel.fun = function(x, y) {
  circos.axis(h="top",major.at=brk,labels=brk_label,labels.cex=0.8,
              col=col_text,labels.col=col_text,lwd=0.7,labels.facing="clockwise")
},bg.border=F)



df.illumina<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/illumina.coverage",
                        delim = "\t",
                        col_names = FALSE)
df.illumina

df.illumina %>% pull(X4) %>% summary()

df.illumina<-df.illumina %>% 
  mutate(X4=case_when(
    X4 > 100 ~ 100,
    X4 <= 100 ~ X4
  ))

circos.trackPlotRegion(ref$Genome, 
                       ylim = c(0, 100),
                       track.height = 0.1,
                       bg.col = '#EEEEEE6E', 
                       bg.border = NA)
for (chromosome in ref$Genome){
  circos.lines(sector.index = chromosome,
               y = df.illumina[df.illumina$X1==chromosome,]$X4,
               x = df.illumina[df.illumina$X1==chromosome,]$X2+2500,
               area = TRUE,   
               col = "#00bfc4",
               border="transparent")
}


df.ont<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/ont.coverage",
                   delim = "\t",
                   col_names = FALSE)
df.ont

df.ont %>% pull(X4) %>% summary()

df.ont<-df.ont %>% 
  mutate(X4=case_when(
    X4 > 100 ~ 100,
    X4 <= 100 ~ X4
  ))

circos.trackPlotRegion(ref$Genome, 
                       ylim = c(0, 100),
                       track.height = 0.1,
                       bg.col = '#EEEEEE6E', 
                       bg.border = NA)
for (chromosome in ref$Genome){
  circos.lines(sector.index = chromosome,
               y = df.ont[df.ont$X1==chromosome,]$X4,
               x = df.ont[df.ont$X1==chromosome,]$X2+2500,
               area = TRUE,   
               col = "#c77cff",
               border="transparent")
}

df.gc<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/gc.content",
                  delim = "\t",
                  col_names = FALSE) %>% 
  mutate(X10=X1,
         X11=X2) %>% 
  mutate(X1=str_extract(X10,pattern = 'chr[1-9]'),
         X2=str_extract(X10,pattern = ':[0-9]+') %>% 
           str_replace(":","") %>% 
           as.numeric(),
         X3=str_extract(X10,pattern = '-[0-9]+') %>% 
           str_replace("-","") %>% 
           as.numeric(),
         X4=X11) %>% 
  select(X1,X2,X3,X4)

df.gc %>% pull(X4) %>% summary()


# df.gc<-df.gc %>% 
#   mutate(color=colorRampPalette(c('#f0f9e8', '#0868ac'))(length(X4))[rank(X4)])


circos.trackPlotRegion(ref$Genome, 
                       ylim = c(0, 100),
                       track.height = 0.1,
                       bg.col = '#EEEEEE6E', 
                       bg.border = NA)
for (chromosome in ref$Genome){
  circos.lines(sector.index = chromosome,
               y = df.gc[df.gc$X1==chromosome,]$X4,
               x = df.gc[df.gc$X1==chromosome,]$X2+2500,
               area = TRUE,   
               col = "#7cae00",
               border="transparent")
}

df.TE<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/TE.count.100k.window",
                  delim = "\t",
                  col_names = FALSE)
df.TE


df.TE %>% pull(X4) %>% summary()
df.TE<-df.TE %>% 
  mutate(X4=case_when(
    X4>=200 ~ 200,
    X4<200 ~ X4
  ))

# df.TE<-df.TE %>% 
#   mutate(color=colorRampPalette(c('#fef0d9', '#b30000'))(length(X4))[rank(X4)])


circos.trackPlotRegion(ref$Genome, 
                       ylim = c(0, 200),
                       track.height = 0.1,
                       bg.col = '#EEEEEE6E', 
                       bg.border = NA)
for (chromosome in ref$Genome){
  circos.lines(sector.index = chromosome,
               y = df.TE[df.TE$X1==chromosome,]$X4,
               x = df.TE[df.TE$X1==chromosome,]$X2+2500,
               area = TRUE,   
               col = "#f8766d",
               border="transparent")
}



df.gene<-read_delim("D:/000_PomePanGenome/Figures/Figure1/data/gene.count.100k.window",
                    delim = "\t",
                    col_names = FALSE)
df.gene


df.gene %>% pull(X4) %>% summary()

# df.gene<-df.gene %>% 
#   mutate(color=colorRampPalette(c('#edf8fb', '#006d2c'))(length(X4))[rank(X4)])


circos.trackPlotRegion(ref$Genome, 
                       ylim = c(0, 30),
                       track.height = 0.1,
                       bg.col = '#EEEEEE6E', 
                       bg.border = NA)
for (chromosome in ref$Genome){
  circos.lines(sector.index = chromosome,
               y = df.gene[df.gene$X1==chromosome,]$X4,
               x = df.gene[df.gene$X1==chromosome,]$X2+2500,
               area = TRUE,   
               col = "#ff2e6a",
               border="transparent")
}
