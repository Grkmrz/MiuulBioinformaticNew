rule all:
    input:  #"output/G_intestinalis.txt",
            #"output/G_intestinalis.tRNA",
            #expand("output/tRNAscan/{sp}.tRNA", sp=["G_muris", "G_intestinalis"]),
            expand("output/blastn/G_intestinalis/{sp}.blastn", sp=["G_muris", "S_salmonicida"])

rule tRNAscan:
    input: "resources/genome/G_intestinalis.fasta"
    output: "output/G_intestinalis.txt"
    shell: """tRNAscan-SE {input} -o {output}"""

rule tRNAscan_stats:
    input:
            genome = "resources/genome/G_intestinalis.fasta"
    output:
            tRNA = "output/G_intestinalis.tRNA",
            stats = "output/G_intestinalis.stats"
    params:
        threads=2
    conda:
         "env/env.yaml"
    script:
          "scripts/tRNAscan_stats.py"

rule tRNAscan_stats_wildcard:
    input:
         genome="resources/genome/{genome}.fasta"
    output:
         tRNA="output/tRNAscan/{genome}.tRNA",
         stats="output/tRNAscan/{genome}.stats"
    params:
         threads=2
    conda:
         "env/env.yaml"
    script:
         "scripts/tRNAscan_stats.py"

rule makeblastdb:
    input:
         "resources/{type}/db/{db}.fasta"
    output:
         "output/{type}/db/{db}.ndb",
         "output/{type}/db/{db}.nhr",
         "output/{type}/db/{db}.nin",
         "output/{type}/db/{db}.not",
         "output/{type}/db/{db}.nsq",
         "output/{type}/db/{db}.ntf",
         "output/{type}/db/{db}.nto"
    params:
         outname="output/{type}/db/{db}"

    shell:
         'makeblastdb -dbtype nucl -in {input} -out {params.outname}'

rule blastn:
    input:
         query = "resources/{type}/query/{query}.fasta",
         db = "output/{type}/db/{db}.ndb"
    output:
         'output/{type}/{db}/{query}.blastn'
    params:
         perc_identity=95,
         outfmt=6,
         num_threads=2,
         max_target_seqs=1,
         max_hsps=1,
         db_prefix="output/{type}/db/{db}"
    script:
         "scripts/blastn.py"






