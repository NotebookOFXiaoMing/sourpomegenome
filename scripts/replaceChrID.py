import sys
from Bio import SeqIO

input_genome = sys.argv[1]
input_ids = sys.argv[2]

output_genome = sys.argv[3]


id_dict = {}

with open(input_ids,'r') as fr:
    for line in fr:
        id_dict[line.strip().split()[0]] = line.strip().split()[1]
        
fw = open(output_genome,'w')

for rec in SeqIO.parse(input_genome,'fasta'):
    fw.write(">%s\n%s\n"%(id_dict[rec.id],str(rec.seq).upper()))
    
fw.close()