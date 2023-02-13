
```
snakemake -s rnaseq_pipeline.smk --cores 8 --configfile=config.yaml --config ref=ys.softmasking.genome.fa fq_folder=rnaseq.raw.data/ fq_suffix=fq -p
braker.pl --cores 36 --species=pomegranate --softmasking --gff3 --genome=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/ys.softmasking.genome.fa --bam=/data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/03.braker2/04.output.bam/SRR6905890.sorted.bam 1>braker2.log 2>&1

## 输出结果 braker/breker.gff3 braker/braker.gtf 本地igv里有一个igvtools工具可以对gff和gtf文件进行排序 直接指定输入文件和输出文件就可以

## 安装maker 用maker中的一些工具对gff文件中的id进行修改
conda create -n marker ##有些尴尬，环境的名字写错了 应该是maker 暂时不知道怎么修改虚拟环境的名字
conda activate marker
conda install mamba
mamba install maker ##这一步要好长时间，需要下载600多M的东西

安装完提示

##########################################################################################

  !!! MAKER: RESTRICTION FOR COMMERCIAL USAGE !!!

  The MAKER authors specifically allowed to make it available in Bioconda, under GPL3
  license. But be aware that MAKER2/3 is free for academic use, but commercial Bioconda
  and Galaxy users of MAKER2/3 still need a license, which can be obtained here:

    http://weatherby.genetics.utah.edu/cgi-bin/registration/maker_license.cgi

  An official statement of the authors on this subject can be consulted on this page:

    https://github.com/galaxyproject/iwc/pull/47#issuecomment-962260646

##########################################################################################
```
