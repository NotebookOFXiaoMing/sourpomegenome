
```
snakemake -s rnaseq_pipeline.smk --cores 8 --configfile=config.yaml --config ref=ys.softmasking.genome.fa fq_folder=rnaseq.raw.data/ fq_suffix=fq -p
braker.pl --cores 36 --species=pomegranate --softmasking --gff3 --genome=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/ys.softmasking.genome.fa --bam=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/04.output.bam/SRR6905890.sorted.bam 1>braker2.log 2>&1
```
