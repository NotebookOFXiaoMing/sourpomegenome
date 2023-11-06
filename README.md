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
```
