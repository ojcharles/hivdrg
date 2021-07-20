
# hivdrg

## overview

hivdrg is a R package to enable synonymous / non-synonymous
characterisation of HIV genetic data for the PANGEA project. Also
provides HIV antiviral drug resistance genotyping. Accepted inputs are
FASTA (whole genomes & fragments) which will be mapped to selected
reference NGS variant data assembled to a supported reference is
accepted in VCF &gt;= ver4.0 & Varscan2 tab formats.

#### Database

A text database extracted in July 2020 from the Stanford resistance
database. Shafer RW(2006). Rationale and Uses of a Public HIV
Drug-Resistance Database. Journal of Infectious Diseases 194 Suppl
1:S51-8

## Installation

You can install the current version from with:
[GitHub](https://github.com/ojcharles/hivdrg)

Dependencies for FASTA file handling are MAFFT and SNP-Sites available
preferably via conda. snp-sites &gt;= 2.3 has been tested.

``` bash
conda config --add channels bioconda
conda install snp-sites
conda install mafft
```

## Usage - resistance genotyping

note: there are 5 supported variants in hivdrg, vcf and tab files must
be assembled against one of these. fasta files will be aligned to the
chosen reference and variants called.

``` r
library("hivdrg")

# select a fasta, vcf, or varscan tab file
my_sample = system.file("testdata", "example.vcf", package = "hivdrg")

# hivdrg provides the following function to return a table of annotated variants
data = call_resistance(infile = my_sample, all_mutations = F, ref = 5)
#> [1] "ref should be an integer between 1 and 5, used to identify the HIV reference genome below"
#> [1] "AG_L39106.1"  "C_AF067155.1" "G_U88826.1"   "JX239390.1"   "K03455.1"


head(data[,c("GENEID","aachange", "freq", "phenotype")])
#>   GENEID aachange   freq phenotype
#> 1     rt    K103N 91.86% Resistant
#> 2     rt    K238T   1.9% Resistant
#> 3     rt    M184V 56.97% Resistant
#> 4     rt    P225H 20.85% Resistant
```

## Usage - synonymous / non-synonymous characterisation

``` r
## call all variants

mutations_all = call_resistance(infile = my_sample, all_mutations = T,ref = 5)
#> [1] "ref should be an integer between 1 and 5, used to identify the HIV reference genome below"
#> [1] "AG_L39106.1"  "C_AF067155.1" "G_U88826.1"   "JX239390.1"   "K03455.1"


# are there any non-synonymous (DNA variants that result in a change of amino acid) variants in resistance genes
mutations_nonsyn = mutations_all[mutations_all$CONSEQUENCE == "nonsynonymous",]


# here the top 3 mutations are nonsynonymous, with no identified resistance effect.
head(mutations_nonsyn[,c("GENEID","aachange", "freq", "CONSEQUENCE","phenotype")])
#>    GENEID aachange   freq   CONSEQUENCE phenotype
#> 2      rt    D250E 59.64% nonsynonymous      <NA>
#> 5      rt    I178V  1.27% nonsynonymous      <NA>
#> 7      rt    K103N 91.86% nonsynonymous Resistant
#> 8      rt    K103R  1.01% nonsynonymous      <NA>
#> 11     rt    K238T   1.9% nonsynonymous Resistant
#> 14     rt    M184V 56.97% nonsynonymous Resistant
```

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on the GitHub Issues page. For questions and other
discussions feel free to contact. [Oscar Charles -
Developer](mailto:oscar.charles.18@ucl.ac.uk)
