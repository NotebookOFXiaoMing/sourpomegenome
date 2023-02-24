
```
ragtag.py scaffold ../../../ys.pome.final.genome.fasta Azerbaijan.fna
```


```
java -jar ~/biotools/GeMoMa-1.9.jar CLI GeMoMaPipeline threads=8 outdir=output GeMoMa.Score=ReAlign AnnotationFinalizer.r=NO o=true t=../Bhagwa.fna  a=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/04.maker/ys.all.maker.gff3 g=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/ys.pome.final.genome.fasta
```

Bhagwa 重新注释

python simple_seq_id.py --i Bhagwa.fna --o Bhagwa01.fa

snakemake -s rnaseq_pipeline.smk --cores 8 --configfile config.yaml --config ref=Bhagwa.01.fa fq_folder=/data/myan/raw_data/pome/sour.pome/rnaseq/ fq_suffix=fastq.gz

