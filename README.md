# sourpomegenome

## 1. estimate genome size

```
cat ../02.pome_CP_Mito/pomeCP.fa ../02.pome_CP_Mito/pomeMito.fa > cp_mito.fa
bwa index cp_mito.fa
bwa mem -t 24 -R "@RG\tID:pome\tSM:pome" cp_mito.fa ../../upload2ncbi/YS_clean_1.fq.gz ../../upload2ncbi/YS_clean_2.fq.gz -o cp_mito.sam
samtools sort -@ 16 -n -O Bam -o cp_mito.sorted.bam cp_mito.sam
samtools view -@ 16 -b -f 12 -F 256 cp_mito.sorted.bam -O BAM -o cp_mito.unmap_unmap.bam
bamToFastq -i cp_mito.unmap_unmap.bam -fq unmap_unmap.R1.fq -fq2 unmap_unmap.R2.fq
cat unmap_unmap.R*.fq | jellyfish count /dev/fd/0 -C -o pome.21mer -m 21 -t 16 -s 5G
jellyfish histo -h 3000000 -o pome.21mer.histo pome.21mer

library(findGSE)
findGSE(histo = "pome.21mer.histo",size=21,outdir = "pome_21mer")
#Genome size estimate for pome.21mer.histo: 355866374 bp
```

## 2. genome assembly

```
sbatch run_nextDenovo.slurm

samtools faidx ../01.nextdenovo/03.ctg_graph/nd.asm.fasta
awk 'OFS="\t" {print $1,0,$2}' ../01.nextdenovo/03.ctg_graph/nd.asm.fasta.fai > nd.asm.fasta.bed

minimap2 -x asm5 -t 8 pomeMito.fa ../01.nextdenovo/03.ctg_graph/nd.asm.fasta -o mito.paf
awk 'OFS="\t" {print $1,$3,$4}' mito.paf > mito.paf.bed
bedtools coverage -a nd.asm.fasta.bed -b mito.paf.bed > mito.paf.bed.cov 

awk '{ if ($7>.5) print $1} ' mito.paf.bed.cov

minimap2 -x asm5 -t 8 pomeCP.fa ../01.nextdenovo/03.ctg_graph/nd.asm.fasta -o cp.paf
awk 'OFS="\t" {print $1,$3,$4}' cp.paf > cp.paf.bed
bedtools coverage -a nd.asm.fasta.bed -b cp.paf.bed > cp.paf.bed.cov
awk '{ if ($7>.5) print $1} ' cp.paf.bed.cov

awk '{ if ($7>.5) print $1} ' ../02.pome_CP_Mito/mito.paf.bed.cov > cp_mito.ids
awk '{ if ($7>.5) print $1} ' ../02.pome_CP_Mito/cp.paf.bed.cov >> cp_mito.ids

seqkit grep -r -v -f cp_mito.ids ../01.nextdenovo/03.ctg_graph/nd.asm.fasta -o nd.asm.exclude.cpmito.fasta
ragtag.py scaffold ../../pomeGenome/tunisia_genomic.fna nd.asm.exclude.cpmito.fasta -t 16


minimap2 -x asm5 ../../pomeGenome/tunisia_genomic.fna ragtag_output/ragtag.scaffold.fasta -o dotplot.paf

library(pafr)
paf<-read_paf("dotplot.paf")
pdf("dotplot.pdf")
dotplot(paf)
dev.off()

python replaceChrID.py ragtag_output/ragtag.scaffold.fasta ids.txt ys.genome.fasta

assembly-stats ys.genome.fasta
```
