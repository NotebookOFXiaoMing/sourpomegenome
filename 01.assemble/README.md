
```
sbatch run_nextDenove.sh
ragtag.py scaffold tunisia_genomic.fna nd.asm.fasta

~/anaconda3/bin/seqkit stats nd.asm.fasta
#file          format  type  num_seqs      sum_len  min_len      avg_len     max_len
#nd.asm.fasta  FASTA   DNA         66  329,487,489  219,898  4,992,234.7  20,488,929

~/anaconda3/bin/seqkit stats ragtag_output/ragtag.scaffold.fasta

#file                                 format  type  num_seqs      sum_len  min_len       avg_len     max_len
#ragtag_output/ragtag.scaffold.fasta  FASTA   DNA         19  329,492,189  219,898  17,341,694.2  70,882,804


```
