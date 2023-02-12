```

RepeatModeler -database pome -pa 24 -LTRStruct 1>repeatmodeler.log 2>&1
RepeatMasker -e rmblast -pa 24 -s -small -lib pome-families.fa ys.pome.final.genome.fasta 1>repeatmasker.log 2>&1
```
