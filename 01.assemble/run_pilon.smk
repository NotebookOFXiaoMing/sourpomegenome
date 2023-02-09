CHRS, = glob_wildcards("split.bam/{chr}.bam")

rule all:
    input:
        expand("pilon.polished/{chr}.fasta",chr=CHRS)

rule run_pilon:
    input:
        fasta = "split.fasta/{chr}.fa",
        bam = "split.bam/{chr}.bam"
    output:
        fasta = "pilon.polished/{chr}.fasta"
    params:
        prefix = "pilon.polished/{chr}"
    threads:
        8
    resources:
        mem = 24000
    shell:
        """
        pilon -Xmx24G --genome {input.fasta} --bam {input.bam} --changes --vcf --diploid --output {params.prefix}
        """