```
python rename_tunisia_seq_id.py
python rename_ys_seq_id.py
minimap2 -ax asm5 --eqx refgenome.fa querygenome.fa > out.sam
syri -c out.sam -r refgenome.fa -q querygenome.fa -k -F S

plotsr --sr syri.out --genomes genomes.txt -W 10 -H 8
```
