
```
## 统计测序产生的数据量

seqkit stats YS_R2.fq.gz
seqkit stats YS_R1.fq.gz

file            format  type    num_seqs        sum_len  min_len  avg_len  max_len
YS_clean_R1.fq  FASTQ   DNA   48,569,063  7,109,715,347       31    146.4      150

file            format  type    num_seqs        sum_len  min_len  avg_len  max_len
YS_clean_R2.fq  FASTQ   DNA   48,569,063  7,109,715,347       31    146.4      150

total 14219430694

cat xinjiang_pome/*.fastq > nanopore.02.fq
seqkit stats nanopore.02.fq 这一步提示数据有问题
[ERRO] nanopore.02.fq: fastx: bad fastq format
seqkit stats nanopore.fq

seqkit stats out_long_reads.fastq

file                  format  type   num_seqs         sum_len  min_len   avg_len  max_len
out_long_reads.fastq  FASTQ   DNA   1,727,304  28,484,600,925        2  16,490.8  574,024

total 28,484,600,925

## 估计基因组大小
jellyfish count -t 8 -C -m 19 -o 19mer_out -s 8G or1.fq or2.fq #这一步时间还挺长的
jellyfish histo -o 19mer_out.histo 19mer_out

## ont long reads assembly
sbatch run_nextDenove.sh

assembly-stats nd.asm.fasta

stats for nd.asm.fasta
sum = 329487489, n = 66, ave = 4992234.68, largest = 20488929
N50 = 16226133, n = 9
N60 = 15406943, n = 11
N70 = 12203689, n = 14
N80 = 7951563, n = 17
N90 = 1644282, n = 28
N100 = 219898, n = 66
N_count = 0
Gaps = 0


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

mkdir pilon.polished.fa
cp pilon.polished/*.fasta pilon.polished.fa
python merge_multi_contigs_to_one.py

seqkit stats ys.pome.final.genome.fasta
#file                        format  type  num_seqs      sum_len    min_len       avg_len     max_len
#ys.pome.final.genome.fasta  FASTA   DNA          9  329,143,568  4,183,326  36,571,507.6  70,784,242

seqkit seq ys.pome.final.genome.fasta -u -o ys.pome.final.genome_upper.fasta

mkdir ys.final.genome
mv ../ragtag_output/bwa.index/pilon.polished.fa/ys.pome.final.genome_upper.fasta ./ys.pome.final.genome.fasta

assembly-stats ys.pome.final.genome.fasta

stats for ys.pome.final.genome.fasta
sum = 329143568, n = 9, ave = 36571507.56, largest = 70784242
N50 = 41230887, n = 4
N60 = 41230887, n = 4
N70 = 33506262, n = 5
N80 = 30200207, n = 6
N90 = 28996985, n = 8
N100 = 4183326, n = 9
N_count = 4800
Gaps = 57


conda activate repeat
BuildDatabase -name pome ys.pome.final.genome.fasta
RepeatModeler -database pome -pa 24 -LTRStruct 1>repeatmodeler.log 2>&1
```
