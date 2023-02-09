import click
import os
import subprocess

@click.command()
@click.option("--bam")
@click.option("--chrlist")

def split_bam_by_chr_id(bam,chrlist):
    with open(chrlist,'r') as fr:
        chr_list = [line.strip() for line in fr]
        
    for chr_id in chr_list:
        cmd = ['conda','run','-n','genomeAsemble','samtools','view','-@','8','ys.sorted.bam',chr_id,'-h','-O','BAM','-o',chr_id+'.bam']
        print(' '.join(cmd))
        subprocess.run(cmd)
        
if __name__ == '__main__':
    split_bam_by_chr_id()