#!/bin/bash


#SBATCH --job-name="run_pilon"
#SBATCH -n 2 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=4000
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL

source activate genomeAsemble
snakemake --cluster "sbatch --output=/data/myan/slurm.out/%j.out \
--error=/data/myan/slurm.out/%j.out --cpus-per-task={threads} \
--mail-type=END,FAIL --mail-user=mingyan24@126.com --mem={resources.mem}" \
--jobs 19 -s run_pilon.smk
