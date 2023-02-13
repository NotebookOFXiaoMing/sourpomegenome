```
conda activate repeat
BuildDatabase -name pome ys.pome.final.genome.fasta
RepeatModeler -database pome -pa 24 -LTRStruct 1>repeatmodeler.log 2>&1 #这一步比较耗时 运行了一天多
RepeatMasker -e rmblast -pa 24 -s -small -lib pome-families.fa ys.pome.final.genome.fasta 1>repeatmasker.log 2>&1 # 这一步运行了3个小时左右

gunzip ys.pome.final.genome.fasta.cat.gz
calcDivergenceFromAlign.pl -s pomegranate.divsum ys.pome.final.genome.fasta.cat #这一步会提示我缺少模块，我是到https://github.com/rmhubley/RepeatMasker 下载下来，然后把里面pm结尾的文件添加到/home/myan/perl5/lib/perl5目录下

createRepeatLandscape.pl -div pomegranate.divsum -g 329143568 > pomegranate.html
```
