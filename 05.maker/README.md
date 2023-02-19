fasta_merge -d ys.softmasking.genome.maker.output/ys.softmasking.genome_master_datastore_index.log -o ys
gff3_merge -d ys.softmasking.genome.maker.output/ys.softmasking.genome_master_datastore_index.log -o ys.all.maker.gff3
maker_map_ids --prefix YS_ --justify 6 ys.all.maker.gff3 > all.id.map
map_fasta_ids all.id.map ys.all.maker.proteins.fasta
map_fasta_ids all.id.map ys.all.maker.transcripts.fasta
map_gff_ids all.id.map ys.all.maker.gff3

grep '>' ys.all.maker.proteins.fasta | wc -l

26136

busoc

run_busco -i ../ys.all.maker.proteins.fasta -l ~/biotools/busco/embryophyta_odb10 -o tsh -m prot

INFO	C:97.6%[S:95.8%,D:1.8%],F:1.2%,M:1.2%,n:1614
INFO	1576 Complete BUSCOs (C)
INFO	1547 Complete and single-copy BUSCOs (S)
INFO	29 Complete and duplicated BUSCOs (D)
INFO	20 Fragmented BUSCOs (F)
INFO	18 Missing BUSCOs (M)
INFO	1614 Total BUSCO groups searched
INFO	BUSCO analysis done. Total running time: 1377.1852402687073 seconds
INFO	Results written in /data/myan/raw_data/pome/sour.pome/pomeGenome/ys.final.genome/04.maker/busco/run_tsh/

EDTA

EDTA.pl -genome ../03.braker2/ys.softmasking.genome.fa -species others -step all -t 8
