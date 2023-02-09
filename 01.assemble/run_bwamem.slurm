#!/bin/bash


#SBATCH --job-name="bwamem"
#SBATCH -n 24 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=48000
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL

source activate genomeAsemble
bwa mem -t 24 ragtag.scaffold.fasta \
paired.end.fastq/YS_clean_R1.fq \
paired.end.fastq/YS_clean_R2.fq | ~/anaconda3/envs/genomeAsemble/bin/samtools \
sort -@ 24 -o ys.sorted.bam