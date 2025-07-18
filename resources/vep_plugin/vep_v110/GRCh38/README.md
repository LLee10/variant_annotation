Download fasta from
> wget https://ftp.ensembl.org/pub/release-114/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
>
> gzip -d Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
>
> samtools faidx Homo_sapiens.GRCh38.dna.primary_assembly.fa
