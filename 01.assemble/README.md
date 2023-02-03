
```
# ont long reads assembly
sbatch run_nextDenove.sh
# fastp filter illumina paired-end reads
fastp -i YS_R1.fq.gz -I YS_R2.fq.gz -o YS_clean_R1.fq -O YS_clean_R2.fq
# polish long reads assembly with illumina paired-end reads with pilon
bwa index nd.asm.fasta
bwa mem -t 24 nd.asm.fasta YS_clean_R1.fq YS_clean_R2.fq | ~/anaconda3/envs/genomeAsemble/bin/samtools sort -@ 24 -o ys.sorted.bam
~/anaconda3/envs/genomeAsemble/bin/samtools index ys.sorted.bam
pilon -Xmx48G --genome nd.asm.fasta --bam ys.sorted.bam --changes --vcf --diploid --threads 24 --output poilon.polished.output

#http://protocols.faircloth-lab.org/en/latest/protocols-computer/assembly/polishing-with-pilon.html

ragtag.py scaffold tunisia_genomic.fna nd.asm.fasta

~/anaconda3/bin/seqkit stats nd.asm.fasta
#file          format  type  num_seqs      sum_len  min_len      avg_len     max_len
#nd.asm.fasta  FASTA   DNA         66  329,487,489  219,898  4,992,234.7  20,488,929

~/anaconda3/bin/seqkit stats ragtag_output/ragtag.scaffold.fasta

#file                                 format  type  num_seqs      sum_len  min_len       avg_len     max_len
#ragtag_output/ragtag.scaffold.fasta  FASTA   DNA         19  329,492,189  219,898  17,341,694.2  70,882,804


```
