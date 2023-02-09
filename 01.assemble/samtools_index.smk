CHRS, = glob_wildcards("split.bam/{chr}.bam")
print(CHRS)

rule all:
    input:
        expand("split.bam/{chr}.bam.bai",chr=CHRS)

rule samtools_index:
    input:
        "split.bam/{chr}.bam"
    output:
        "split.bam/{chr}.bam.bai"
    threads:
        4
    shell:
        """
        conda run -n genomeAsemble samtools index -@ {threads} {input}
        """