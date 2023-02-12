seqids = ['Chr1',
          'Chr2',
          'Chr3',
          'Chr4',
          'Chr5',
          'Chr6',
          'Chr7',
          'Chr8']

from Bio import SeqIO

i = 0

fw = open("querygenome.fa",'w')

for rec in SeqIO.parse('ys.pome.final.genome.fasta','fasta'):
    i = i + 1
    if rec.id in seqids:
        fw.write(">Chr%d\n%s\n"%(i,str(rec.seq)))
        
fw.close()