Pan-genome


### GO enrich analysis

```
conda activate eggnogmapper
export EGGNOG_DATA_DIR=/home/myan/my_data/database/eggnog/
emapper.py -i six.pome.pep.fa -o six.pome.pep --cpu 24 -m diamond --excel
```

The link of emapper output 链接: https://caiyun.139.com/m/i?105Cf3uVmIpfy  提取码:v76w  复制内容打开中国移动云盘手机APP，操作更方便哦

参考这个链接 http://git.genek.cn:3333/zhxd2/emcp 构建自己的OrgDB用于GO富集分析

```
Rscript constructOrgDb.R 
```
