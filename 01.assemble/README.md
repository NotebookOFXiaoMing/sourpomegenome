
```
# ont long reads assembly
sbatch run_nextDenove.sh
ragtag.py scaffold tunisia_genomic.fna nd.asm.fasta

~/anaconda3/bin/seqkit stats nd.asm.fasta
#file          format  type  num_seqs      sum_len  min_len      avg_len     max_len
#nd.asm.fasta  FASTA   DNA         66  329,487,489  219,898  4,992,234.7  20,488,929

~/anaconda3/bin/seqkit stats ragtag_output/ragtag.scaffold.fasta

#file                                 format  type  num_seqs      sum_len  min_len       avg_len     max_len
#ragtag_output/ragtag.scaffold.fasta  FASTA   DNA         19  329,492,189  219,898  17,341,694.2  70,882,804

# fastp filter illumina paired-end reads
fastp -i YS_R1.fq.gz -I YS_R2.fq.gz -o YS_clean_R1.fq -O YS_clean_R2.fq
bwa index ragtag.scaffold.fasta
bwa mem -t 24 ragtag.scaffold.fasta \
paired.end.fastq/YS_clean_R1.fq \
paired.end.fastq/YS_clean_R2.fq | ~/anaconda3/envs/genomeAsemble/bin/samtools \
sort -@ 24 -o ys.sorted.bam
conda run -n genomeAsemble samtools index -@ 8 ys.sorted.bam

grep ">" ragtag.scaffold.fasta | awk 'gsub(">","")' > chr.list
python split_bam_by_chr_id.py --bam ys.sorted.bam --chrlist chr.list
python split_fa_by_seq_id.py --fasta ragtag.scaffold.fasta --outputfoldeer split.fasta

mkdir split.bam
mv *.bam split.bam
mv split.bam/ys.sorted.bam ./
snakemake -s samtools_index.smk --cores 8 -p


####http://protocols.faircloth-lab.org/en/latest/protocols-computer/assembly/polishing-with-pilon.html
sbatch run_pilon.slurm
```
