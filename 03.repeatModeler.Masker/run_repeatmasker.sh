#!/bin/bash


#SBATCH --job-name="ysrepMasker"
#SBATCH -n 24 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=48000
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL

source activate repeat
RepeatMasker -e rmblast -pa 24 -s -small -lib pome-families.fa ys.pome.final.genome.fasta 1>repeatmasker.log 2>&1