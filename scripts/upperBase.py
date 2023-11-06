from Bio import SeqIO
import sys

fw = open(sys.argv[1],'w')


for rec in SeqIO.parse(sys.argv[2],'fasta'):
    fw.write(">%s\n%s\n"%(rec.id.split("_")[0],str(rec.seq).upper()))
    
fw.close()