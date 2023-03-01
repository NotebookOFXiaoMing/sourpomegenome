```
conda activate repeat
BuildDatabase -name pome ys.pome.final.genome.fasta
RepeatModeler -database pome -pa 24 -LTRStruct 1>repeatmodeler.log 2>&1 #这一步比较耗时 运行了一天多
RepeatMasker -e rmblast -pa 24 -s -small -lib pome-families.fa ys.pome.final.genome.fasta 1>repeatmasker.log 2>&1 # 这一步运行了3个小时左右

gunzip ys.pome.final.genome.fasta.cat.gz
calcDivergenceFromAlign.pl -s pomegranate.divsum ys.pome.final.genome.fasta.cat #这一步会提示我缺少模块，我是到https://github.com/rmhubley/RepeatMasker 下载下来，然后把里面pm结尾的文件添加到/home/myan/perl5/lib/perl5目录下

createRepeatLandscape.pl -div pomegranate.divsum -g 329143568 > pomegranate.html
```

RepeatMasker 还需要配置 RepBase 数据库 下载链接 http://ftp.genek.cn:8888/Share/linux_software/ RepBaseRepeatMaskerEdition-20181026.tar.gz


/home/myan/anaconda3/envs/repeat/share/RepeatMasker 通过conda安装的RepeatMasker 在这个目录下，把RepBaseRepeatMaskerEdition-20181026.tar.gz放到这个目录下解压

tar -xzvf RepBaseRepeatMaskerEdition-20181026.tar.gz

Libraries/
Libraries/RMRBSeqs.embl
Libraries/README.RMRBSeqs

这个解压出来的文件 RMRBSeqs.embl 好像在官网可以下载更新版本的，是不是直接下载那个也行呢？

这个目录下原来是有Libraries这个文件夹的 这个解压过程显示 以上内容，不知道会不会对这个文件夹有影响

接下来再运行./addRepBase.pl -libdir Libraries/

提示信息

Rebuilding RepeatMaskerLib.h5 master library
  - Read in 49011 sequences from Libraries//RMRBSeqs.embl
  - Read in 49011 annotations from Libraries//RMRBMeta.embl
  Merging Dfam + RepBase into RepeatMaskerLib.h5 library...

File: /home/myan/anaconda3/envs/repeat/share/RepeatMasker/Libraries/RepeatMaskerLib.h5
Database: Dfam withRBRM
Version: 3.3
Date: 2020-11-09

Dfam - A database of transposable element (TE) sequence alignments and HMMs.
RBRM - RepBase RepeatMasker Edition - version 20181026

Total consensus sequences: 51780
Total HMMs: 6915

这个是repeatMasker这一步 不知道RepeatModelor这一步是否需要重新运行

如果研究的物种在Repbase这个数据库中有，需要配置这个数据库，如果没有就不用配置这个数据库，直接用repeatModeler去训练

