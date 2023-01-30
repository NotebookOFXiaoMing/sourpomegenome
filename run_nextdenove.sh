#!/bin/bash

#SBATCH --job-name="runnextdenove"
#SBATCH --partition=himem
#SBATCH --cpus-per-task=64
#SBATCH --mem=256G
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL


/mnt/shared/scratch/myan/apps/mingyan/Biotools/NextDenovo/nextDenovo /mnt/shared/scratch/myan/apps/mingyan/Biotools/NextDenovo/pome_genome/run.cfg
