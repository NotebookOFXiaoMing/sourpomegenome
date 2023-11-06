#!/bin/bash


#SBATCH --job-name="nextDenovo"
#SBATCH -n 128 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=240000
#SBATCH --partition=tcum256c128Partition
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL


/home/myan/biotools/NextDenovo/nextDenovo run.cfg
