
```
ragtag.py scaffold ../../../ys.pome.final.genome.fasta Azerbaijan.fna
```


```
java -jar ~/biotools/GeMoMa-1.9.jar CLI GeMoMaPipeline threads=8 outdir=output GeMoMa.Score=ReAlign AnnotationFinalizer.r=NO o=true t=../Bhagwa.fna  a=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/04.maker/ys.all.maker.gff3 g=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/ys.pome.final.genome.fasta
```

Bhagwa 重新注释

```
python simple_seq_id.py --i Bhagwa.fna --o Bhagwa01.fa
snakemake -s rnaseq_pipeline.smk --cores 8 --configfile config.yaml --config ref=Bhagwa.01.fa fq_folder=/data/myan/raw_data/pome/sour.pome/rnaseq/ fq_suffix=fastq.gz
这个命令是必须执行的 perl change_path_in_perl_scripts.pl "/home/myan/anaconda3/envs/braker2/bin/perl"
braker.pl --cores 16 --softmasking --gff3 --genome=Bhagwa.01.fa --bam=04.output.bam/SRR6905890.sorted.bam 晚上10点开始（由于没运行perl那行命令报错，早上8点40重新开始 11点40运行完 3个小时 还挺快的）
```

AAzerbaijan 重新注释

```
python ../Bhagwa/simple_seq_id.py --i Azerbaijan.fna --o Azerbaijan.01.fa
snakemake -s rnaseq_pipeline.smk --cores 8 --configfile config.yaml --config ref=Azerbaijan.01.fa fq_folder=/data/myan/raw_data/pome/sour.pome/rnaseq/ fq_suffix=fastq.gz
braker.pl --cores 16 --softmasking --genome=Azerbaijan.01.fa --bam=04.output.bam/SRR6905890.sorted.bam (不加--gff3参数输出gtf文件)
```
