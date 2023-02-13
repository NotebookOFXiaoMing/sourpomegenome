#!/bin/bash

# https://zhuanlan.zhihu.com/p/345387783

#SBATCH --job-name="braker2"
#SBATCH -n 36 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=64000
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL

source activate braker2
cd ~/biotools/gmes_linux_64_4
echo 'step01'
perl change_path_in_perl_scripts.pl "/home/myan/anaconda3/envs/braker2/bin/perl"
echo 'step02'
cd /home/myan/my_data/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2
echo 'step03'
braker.pl --cores 36 --species=pomegranate --softmasking --gff3 --genome=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/ys.pome.final.genome.fasta.masked --bam=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/SRR6905890.sorted.bam 1>braker2.log 2>&1
echo 'step04'