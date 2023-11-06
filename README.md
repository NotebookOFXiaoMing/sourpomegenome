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

seqkit seq -m 50000 ys.nanopore.fa -o ys.nanopore.larger50k.fa -j 24
seqkit seq -m 100000 ys.nanopore.fa -o ys.nanopore.larger100k.fa -j 24


time tgsgapcloser --scaff ../04.ragtag/ys.genome.fasta \
--reads raw.reads/ys.nanopore.larger100k.fa --output tgsgapcloser_output \
--racon /home/myan/anaconda3/envs/syri/bin/racon --thread 32

assembly-stats tgsgapcloser_output.scaff_seqs

~/biotools/NextPolish/nextPolish run.cfg

python upperBase.py genome.nextpolish.upperbase.fasta genome.nextpolish.fasta
```

## 3. RepeatModelor + RepeatMasker
```
conda activate edta03
BuildDatabase -name ys genome.nextpolish.upperbase.fasta
RepeatModeler -database ys -threads 52 -LTRStruct

conda activate DeepTE

snakemake -s deepTE.smk --cores 4 -p
grep "Unknown" ys-families.fa | wc -l # 1461
grep "Unknown" 00.ys.rep.lib/ys-families.fa | wc -l ##551

conda activate edta03
RepeatMasker -e rmblast -pa 32 -qq -xsmall \
-lib 00.ys.rep.lib/ys-families.fa genome.nextpolish.upperbase.fasta \
-dir ys.repeatmasker
```

## 4. assembly quality

```
busco -i ../06.nextPolish/genome.nextpolish.upperbase.fasta -c 24 -o busco -m geno -l ~/my_data/database/embryophyta_odb10 --offline

minimap2 -ax sr ../../06.nextPolish/genome.nextpolish.upperbase.fasta \
../../../upload2ncbi/YS_clean_1.fq.gz \
../../../upload2ncbi/YS_clean_2.fq.gz -t 32 > illumina.sam
samtools sort -@ 16 -O BAM -o illumina.sorted.sam illumina.sam
samtools flagstat -@ 16 illumina.sorted.sam

minimap2 -ax sr ../../06.nextPolish/genome.nextpolish.upperbase.fasta \
../../03.genomeSizeEstimate/unmap_unmap.R1.fq \
../../03.genomeSizeEstimate/unmap_unmap.R2.fq -t 32 > unmap_cpMito_illumina.sam

samtools sort -@ 16 -O BAM -o unmap_cpMito_illumina.sorted.bam unmap_cpMito_illumina.sam
samtools flagstat -@ 16 unmap_cpMito_illumina.sorted.bam

bwa index ../../06.nextPolish/genome.nextpolish.upperbase.fasta
bwa mem -t 24 ../../06.nextPolish/genome.nextpolish.upperbase.fasta \
../../03.genomeSizeEstimate/unmap_unmap.R1.fq \
../../03.genomeSizeEstimate/unmap_unmap.R2.fq -o bwa_map.sam
samtools sort -@ 16 -O BAM -o bwa_map.sorted.sam bwa_map.sam
samtools flagstat -@ 16 bwa_map.sorted.sam

minimap2 -ax map-ont ../../06.nextPolish/genome.nextpolish.upperbase.fasta ../../../upload2ncbi/ys.nanopore.fq.gz -t 8 > ont.sam
samtools sort -@ 16 -O BAM -o ont.sorted.bam ont.sam
samtools flagstat -@ 16 ont.sorted.bam

meryl k=21 count output r1.meryl ../../03.genomeSizeEstimate/unmap_unmap.R1.fq
meryl k=21 count output r2.meryl ../../03.genomeSizeEstimate/unmap_unmap.R2.fq

meryl union-sum output r1_r2.meryl r1.meryl r2.meryl
merqury.sh r1_r2.meryl ../../06.nextPolish/genome.nextpolish.upperbase.fasta out_prefix

perl LTR_FINDER_parallel-1.1/LTR_FINDER_parallel \
-seq ../../06.nextPolish/genome.nextpolish.upperbase.fasta -threads 32 -harvest_out

LTR_retriever -threads 32 -genome \
../../06.nextPolish/genome.nextpolish.upperbase.fasta \
-inharvest genome.nextpolish.upperbase.fasta.finder.combine.scn

LAI -t 32 -genome ../../06.nextPolish/genome.nextpolish.upperbase.fasta \
-intact genome.nextpolish.upperbase.fasta.pass.list \
-all genome.nextpolish.upperbase.fasta.out
```

## 5. genome annotation
```
conda activate rnaseq
snakemake -s genomeAnnotationStep01.smk --configfiles=step01.yaml --cores 128 -pn

conda activate braker2
snakemake -s genomeAnnotationStep02.smk --configfiles step02.yaml --cores 64 -p #201m

conda activate rnaseq
snakemake -s genomeAnnotationStep03.smk --configfiles step03.yaml --cores 52 -p

snakemake -s genomeAnnotationStep03_04.smk --configfiles step04.yaml --cores 24 -p

conda activate EVM
snakemake -s genomeAnnotationStep04.smk --configfiles step04.yaml --cores 52 -pn

time emapper.py -i ../../08.proteinCodingGenes/05.evm/ys/ys.pep.fa -o ys --cpu 24 -m diamond

interproscan.sh -i ../../08.proteinCodingGenes/05.evm/ys/ys.pep.fa -f tsv --goterms -dp -cpu 32 -o ys.interproscan.tsv
```
