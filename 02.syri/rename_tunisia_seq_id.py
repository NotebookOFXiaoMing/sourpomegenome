seqids = ['NC_045127.1',
          'NC_045128.1',
          'NC_045129.1',
          'NC_045130.1',
          'NC_045131.1',
          'NC_045132.1',
          'NC_045133.1',
          'NC_045134.1']

from Bio import SeqIO

i = 0

fw = open("refgenome.fa",'w')

for rec in SeqIO.parse('tunisia_genomic.fna','fasta'):
    i = i + 1
    if rec.id in seqids:
        fw.write(">Chr%d\n%s\n"%(i,str(rec.seq)))
        
fw.close()