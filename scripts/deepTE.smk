SAMPLES, = glob_wildcards("{sample}-families.fa")

print(SAMPLES)


rule all:
    input:
        expand("01.{sample}.LTRunknown/opt_DeepTE.txt",sample=SAMPLES),
        expand("02.{sample}.DNAunknown/DNAunknown_id_dict.txt",sample=SAMPLES),
        expand("00.{sample}.rep.lib/{sample}-families.fa",sample=SAMPLES)


rule step01:
    input:
        "{sample}-families.fa"
    output:
        "01.{sample}.LTRunknown/{sample}_LTRunknown.ids"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        grep "LTR/Unknown" {input} | awk '{{print $1}}' | awk 'gsub(">","")' > {output}
        grep "#Unknown" {input} | awk '{{print $1}}' | awk 'gsub(">","")' > Unknown.ids
        """

rule step02:
    input:
        ids = rules.step01.output,
        fa = "{sample}-families.fa"
    output:
        "01.{sample}.LTRunknown/{sample}_LTRunknown.fa"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        seqkit grep -r -f {input.ids} {input.fa} -o {output}
        """

rule step03:
    input:
        rules.step02.output
    output:
        "01.{sample}.LTRunknown/opt_DeepTE.txt"
    threads:
        4
    resources:
        mem_mb = 4000
    params:
        "01.{sample}.LTRunknown/"
    shell:
        """
        python /home/myan/biotools/DeepTE/DeepTE.py -i {input} -sp P -d {params} \
        -o {params} -m_dir /home/myan/biotools/DeepTE/Plants_model/
        """

rule step04:
    input:
        rules.step03.output
    output:
        "01.{sample}.LTRunknown/LTRunknown_id_dict.txt"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        python 001.py {input} {output}
        """


rule step05:
    input:
        "{sample}-families.fa"
    output:
        "02.{sample}.DNAunknown/{sample}_DNAunknown.ids"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        grep "#Unknown" {input} | awk '{{print $1}}' | awk 'gsub(">","")' > {output}
        """

rule step06:
    input:
        ids = rules.step05.output,
        fa = "{sample}-families.fa"
    output:
        "02.{sample}.DNAunknown/{sample}_DNAunknown.fa"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        seqkit grep -r -f {input.ids} {input.fa} -o {output}
        """

rule step07:
    input:
        rules.step06.output
    output:
        "02.{sample}.DNAunknown/opt_DeepTE.txt"
    threads:
        4
    resources:
        mem_mb = 4000
    params:
        "02.{sample}.DNAunknown/"
    shell:
        """
        python /home/myan/biotools/DeepTE/DeepTE.py -i {input} -sp P -d {params} \
        -o {params} -m_dir /home/myan/biotools/DeepTE/Plants_model/
        """

rule step08:
    input:
        rules.step07.output
    output:
        "02.{sample}.DNAunknown/DNAunknown_id_dict.txt",
        "02.{sample}.DNAunknown/unknown_id_dict.txt"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        python 002.py {input} {output[0]}
        python 001.py {input} {output[1]}
        """

rule step09:
    input:
        rules.step08.output[0],
        rules.step08.output[1],
        rules.step04.output
    output:
        "{sample}_unknown_id_dict.txt"
        
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        cat {input[0]} {input[1]} {input[2]} > {output}
        """
rule step10:
    input:
        "{sample}-families.fa",
        rules.step09.output
    output:
        "00.{sample}.rep.lib/{sample}-families.fa"
    threads:
        4
    resources:
        mem_mb = 4000
    shell:
        """
        python 003.py {input[0]} {input[1]} {output}
        """


