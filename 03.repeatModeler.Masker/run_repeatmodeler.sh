#!/bin/bash


#SBATCH --job-name="ysrepeat"
#SBATCH -n 24 #threads
#SBATCH -N 1 #node number
#SBATCH --mem=48000
#SBATCH --mail-user=mingyan24@126.com
#SBATCH --mail-type=BEGIN,END,FAIL

source activate repeat
RepeatModeler -database pome -pa 24 -LTRStruct 1>repeatmodeler.log 2>&1
