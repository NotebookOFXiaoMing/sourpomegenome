
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

conda run -n genomeAsemble gffread -g Bhagwa.01.fa -x cds.fa braker/braker.gtf

braker2的输出结果太多，有4万多，查了一下有没有过滤的办法，找到链接 https://github.com/Gaius-Augustus/BRAKER/issues/319 这里提到有脚本可以过滤 https://github.com/Gaius-Augustus/BRAKER/tree/report/scripts/predictionAnalysis

四个脚本都下载下来 

用法

python ../selectBraker2/selectSupportedSubsets.py --fullSupport fullsupport.gff --anySupport anysupport.gff --noSupport nosupport.gff braker/braker.gtf braker/hintsfile.gff

anysupport.gff 里包含 fullsupport.gff 上面的链接提到会生成summary,但是我这边没有

conda run -n genomeAsemble gffread -g Bhagwa.01.fa -x cds.fa anysupport.gff
python ../trans_cds_to_pep.py --i cds.fa --o bhw.fa #Bhagwa22063 Asbj 20557




