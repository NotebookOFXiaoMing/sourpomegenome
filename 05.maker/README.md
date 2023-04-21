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

Sun Feb 19 16:13:05 CST 2023	Dependency checking:
				All passed!

Sun Feb 19 16:13:18 CST 2023	Obtain raw TE libraries using various structure-based programs: 
Sun Feb 19 16:13:18 CST 2023	EDTA_raw: Check dependencies, prepare working directories.

Sun Feb 19 16:13:24 CST 2023	Start to find LTR candidates.

Sun Feb 19 16:13:24 CST 2023	Identify LTR retrotransposon candidates from scratch.

Sun Feb 19 17:35:16 CST 2023	Finish finding LTR candidates.

Sun Feb 19 17:35:16 CST 2023	Start to find TIR candidates.

Sun Feb 19 17:35:16 CST 2023	Identify TIR candidates from scratch.

Species: others
Sun Feb 19 20:09:05 CST 2023	Finish finding TIR candidates.

Sun Feb 19 20:09:05 CST 2023	Start to find Helitron candidates.

Sun Feb 19 20:09:05 CST 2023	Identify Helitron candidates from scratch.

Sun Feb 19 21:49:55 CST 2023	Finish finding Helitron candidates.

Sun Feb 19 21:49:55 CST 2023	Execution of EDTA_raw.pl is finished!

Sun Feb 19 21:49:55 CST 2023	Obtain raw TE libraries finished.
				All intact TEs found by EDTA: 
					ys.softmasking.genome.fa.mod.EDTA.intact.fa
					ys.softmasking.genome.fa.mod.EDTA.intact.gff3

Sun Feb 19 21:49:55 CST 2023	Perform EDTA advcance filtering for raw TE candidates and generate the stage 1 library: 

Sun Feb 19 22:03:03 CST 2023	EDTA advcance filtering finished.

Sun Feb 19 22:03:03 CST 2023	Perform EDTA final steps to generate a non-redundant comprehensive TE library:

				Skipping the RepeatModeler step (--sensitive 0).
				Run EDTA.pl --step final --sensitive 1 if you want to use RepeatModeler.

				Skipping the CDS cleaning step (--cds [File]) since no CDS file is provided or it's empty.

Sun Feb 19 22:14:03 CST 2023	EDTA final stage finished! You may check out:
				The final EDTA TE library: ys.softmasking.genome.fa.mod.EDTA.TElib.fa


blast

 blastn -query two.seq.pra.fa -db /home/sunj/Software/ncbi_database/nt/nt_DB -out novel.nt.blast -evalue 1e-5 -perc_identity 0.8 -task megablast -outfmt '6 std qcovs stitle staxid' -max_target_seqs 5 -num_threads 8

eggnog mapper

emapper.py --cpu 20 --mp_start_method forkserver --data_dir /dev/shm/ -o out --output_dir /emapper_web_jobs/emapper_jobs/user_data/MM_tefs5h49 --temp_dir /emapper_web_jobs/emapper_jobs/user_data/MM_tefs5h49 --override -m diamond --dmnd_ignore_warnings -i /emapper_web_jobs/emapper_jobs/user_data/MM_tefs5h49/queries.fasta --evalue 0.001 --score 60 --pident 40 --query_cover 20 --subject_cover 20 --itype proteins --tax_scope auto --target_orthologs all --go_evidence non-electronic --pfam_realign none --report_orthologs --decorate_gff yes --excel > /emapper_web_jobs/emapper_jobs/user_data/MM_tefs5h49/emapper.out 2> /emapper_web_jobs/emapper_jobs/user_data/MM_tefs5h49/emapper.err


cat ys.all.maker.gff3 | awk '$2=="maker"{print}' > ys.all.maker01.gff3
python igv_web.py -r ys.softmasking.genome.fa -g ys.all.maker01.gff3
