from Bio import SeqIO
import click
import os

@click.command()
@click.option("--fasta")
@click.option("--outputfolder")

def split_fa_by_id(fasta,outputfolder):
    os.makedirs(outputfolder,exist_ok=True)
    for rec in SeqIO.parse(fasta,'fasta'):
        fw = open(outputfolder + "/" + rec.id + ".fa",'w')
        fw.write(">%s\n%s\n"%(rec.id,str(rec.seq)))
        fw.close()
        
if __name__ == '__main__':
    split_fa_by_id()