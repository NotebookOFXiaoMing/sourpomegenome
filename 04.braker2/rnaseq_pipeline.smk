print("The path of your reference genome is: ",config["ref"])
print("The path of folder containing raw fq is: ",config['fq_folder'])

SAMPLES,FRS = glob_wildcards(config['fq_folder'] + "{sample}_{fr}." + config['fq_suffix'])

print(SAMPLES,FRS)


rule all:
    input:
        "02.ref.index/ref_index.1.ht2",
        expand("04.output.bam/{sample}.sorted.bam.bai",sample=SAMPLES)

rule run_fastp:
    input:
        r1 = config['fq_folder'] + "{sample}_1." + config['fq_suffix'],
        r2 = config['fq_folder'] + "{sample}_2." + config['fq_suffix']
    output:
        r1 = "01.clean.reads/{sample}_clean_1.fq",
        r2 = "01.clean.reads/{sample}_clean_2.fq",
        json = "01.clean.reads/{sample}.json",
        html = "01.clean.reads/{sample}.html"
    threads:
        8
    resources:
        mem = 16000
    shell:
        """
        fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2} -j {output.json} -h {output.html}
        """

rule run_hisat2_build:
    input:
        config['ref']
    output:
        "02.ref.index/ref_index.1.ht2"
    params:
        "02.ref.index/ref_index"
    threads:
        8
    resources:
        mem = 16000
    shell:
        """
        hisat2-build {input} {params}
        """

rule run_hisat2_align:
    input:
        r1 = rules.run_fastp.output.r1,
        r2 = rules.run_fastp.output.r2,
        index = rules.run_hisat2_build.output
    output:
        sam = "03.output.sam/{sample}.sam"
    params:
        "02.ref.index/ref_index"
    resources:
        mem = 16000
    threads:
        8
    shell:
        """
        hisat2 -p {threads} --dta -x {params} -1 {input.r1} -2 {input.r2} -S {output.sam}
        """

rule run_samtools_sort:
    input:
        rules.run_hisat2_align.output.sam
    output:
        "04.output.bam/{sample}.sorted.bam"
    threads:
        8
    resources:
        mem = 16000
    shell:
        """
        samtools sort -@ {threads} {input} -O BAM -o {output} 
        """

rule run_samtools_index:
    input:
        rules.run_samtools_sort.output
    output:
        "04.output.bam/{sample}.sorted.bam.bai"
    threads:
        8
    resources:
        mem = 16000
    shell:
        """
        samtools index -@ {threads} {input}
        """