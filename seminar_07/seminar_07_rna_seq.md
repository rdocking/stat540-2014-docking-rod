Seminar 07 - RNA-Seq Analysis
=============================

Runthrough of the two week 7 seminars:

[Getting Read Counts](http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar07_RNA-seq-bam.html)
[Using read counts for differential expression analysis](http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar07_RNA-seq.html)

Seminar 7 optional material: From BAM File To Count Data
--------------------------------------------------------

> Contributors: Katayoon Kasaian

## Introduction

> In order to use RNA-Seq data for the purposes of differential expression, we need to begin by calculating an expression value for each gene (or any other expressed entity such as exons, non-coding RNAs, etc). The digital nature of RNA-seq data allows us to use the number of reads which align to a specific feature as its expression value. In this seminar, we will analyze a small subset of an alignment file and find the read counts for each gene in that region.

## BAM/SAM - Aligned Sequence Data File Format

> The alignment BAM file we will be working with is from the transcriptome of Drosophila melanogaster (fruit fly). [SAM: Sequence Alignment/Map](http://bioinformatics.oxfordjournals.org/content/early/2009/06/08/bioinformatics.btp352.full.pdf) format as well as BAM (binary version of SAM) have become popular formats for representing the alignment of short reads to the reference genome. [Samtools](http://samtools.sourceforge.net/samtools.shtml) package has been developed for working with SAM/BAM alignment files. Several packages have been introduced in order to bring the functionality of Samtools into the R environment. We will work with a few of these packages today.

## Preliminaries

> If you already haven't done so, please install the following packages from Bioconductor.


```r
source("http://bioconductor.org/biocLite.R")
biocLite("ShortRead")
biocLite("Rsamtools")
biocLite("easyRNASeq")
biocLite("BSgenome.Dmelanogaster.UCSC.dm3")
biocLite("biomaRt")
```


## Reading BAM Files

> We start by importing the BAM file, [drosophilaMelanogasterSubset.bam](../examples/drosophilaRnaSeq/data/drosophilaMelanogasterSubset.bam):

> Remember you may need to edit the file paths below, to reflect your working directory and local file storage choices.


```r
library(ShortRead)
library(Rsamtools)

bamDat <- readAligned("../../../stat540/stat540_2014/examples/drosophilaRnaSeq/data/drosophilaMelanogasterSubset.bam", 
    type = "BAM")

# bamDat is an AlignedRead object from the ShortRead package. It stores
# reads and their genomic alignment information.
str(bamDat)
```

```
## Formal class 'AlignedRead' [package "ShortRead"] with 8 slots
##   ..@ chromosome  : Factor w/ 15 levels "chrYHet","chrM",..: 2 2 2 2 2 2 2 2 2 2 ...
##   ..@ position    : int [1:64206] 548 1497 1506 1528 1540 1552 1552 1555 1559 1566 ...
##   ..@ strand      : Factor w/ 3 levels "+","-","*": 2 1 1 1 1 1 1 1 2 2 ...
##   ..@ alignQuality:Formal class 'NumericQuality' [package "ShortRead"] with 1 slots
##   .. .. ..@ quality: int [1:64206] 132 132 127 130 130 122 132 132 132 132 ...
##   ..@ alignData   :Formal class 'AlignedDataFrame' [package "ShortRead"] with 4 slots
##   .. .. ..@ varMetadata      :'data.frame':	1 obs. of  1 variable:
##   .. .. .. ..$ labelDescription: chr "Type of read; see ?scanBam"
##   .. .. ..@ data             :'data.frame':	64206 obs. of  1 variable:
##   .. .. .. ..$ flag: int [1:64206] 16 0 0 0 0 0 0 0 16 16 ...
##   .. .. ..@ dimLabels        : chr [1:2] "readName" "alignColumn"
##   .. .. ..@ .__classVersion__:Formal class 'Versions' [package "Biobase"] with 1 slots
##   .. .. .. .. ..@ .Data:List of 1
##   .. .. .. .. .. ..$ : int [1:3] 1 1 0
##   ..@ quality     :Formal class 'FastqQuality' [package "ShortRead"] with 1 slots
##   .. .. ..@ quality:Formal class 'BStringSet' [package "Biostrings"] with 5 slots
##   .. .. .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. .. .. ..@ group          : int [1:64206] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. .. .. ..@ start          : int [1:64206] 1 37 73 109 145 181 217 253 289 325 ...
##   .. .. .. .. .. .. ..@ width          : int [1:64206] 36 36 36 36 36 36 36 36 36 36 ...
##   .. .. .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. .. .. ..@ metadata       : list()
##   .. .. .. .. ..@ elementType    : chr "BString"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   ..@ sread       :Formal class 'DNAStringSet' [package "Biostrings"] with 5 slots
##   .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. ..@ group          : int [1:64206] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. ..@ start          : int [1:64206] 1 37 73 109 145 181 217 253 289 325 ...
##   .. .. .. .. ..@ width          : int [1:64206] 36 36 36 36 36 36 36 36 36 36 ...
##   .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   .. .. ..@ elementType    : chr "DNAString"
##   .. .. ..@ elementMetadata: NULL
##   .. .. ..@ metadata       : list()
##   ..@ id          :Formal class 'BStringSet' [package "Biostrings"] with 5 slots
##   .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. ..@ group          : int [1:64206] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. ..@ start          : int [1:64206] 1 29 57 85 114 144 173 202 230 260 ...
##   .. .. .. .. ..@ width          : int [1:64206] 28 28 28 29 30 29 29 28 30 30 ...
##   .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   .. .. ..@ elementType    : chr "BString"
##   .. .. ..@ elementMetadata: NULL
##   .. .. ..@ metadata       : list()
```


> Note that in addition to the drosophilaMelanogasterSubset.bam file, there is an index file called drosophilaMelanogasterSubset.bam.bai. This index file allows fast look up of data from the binary alignment file. To index a bam file, you can use the following code:


```r
indexFile <- indexBam("../../../stat540/stat540_2014/examples/drosophilaRnaSeq/data/drosophilaMelanogasterSubset.bam")
```


> This will create the index file `../examples/drosophilaRnaSeq/data/drosophilaMelanogasterSubset.bam.bai`, note that ".bai" has been appended to the original file name.

## Filtering BAM Files

> BAM files contain all the read sequences coming off the sequencing machine, including those that were not aligned to the reference genome! Some reads also contain one or more ambiguous bases encoded as 'N'. As a result, we need to do some filtering before finding expression values for genes.

> First we will load the [easyRNASeq](http://www.bioconductor.org/packages/2.11/bioc/html/easyRNASeq.html) library which provides convenient methods for manipulating BAM files.


```r
library(easyRNASeq)
```


> Now we will do some filtering. The first filter we want to create will keep only reads with at most 2 N's. The `nFilter` functions provides this functionality.


```r
nFilt <- nFilter(2)
```


> Next we will create a filter to keep only reads which have been aligned to the reference genome. The `chromosomeFilter` function will keep only reads which have an entry in the chromosome field of the BAM file satifying a given pattern. We can exploit this by filtering for reads in which the chromsome entry in the BAM file has the string "chr" in them.

> This works because reads which have been aligned to the reference genome will have the chromosome field set to chromosome to which the read has been aligned. Unaligned reads will not have this entry set or it will be something which does not contain "chr".

> If the reference genome used for alignment did not have "chr" in the names of the chromosomes this trick would fail. This is a common issue, for example some versions of the human reference use "chr1" to identify chromsome 1 while others simply use "1".


```r
chrFilt <- chromosomeFilter(regex = "chr")
```


> Now we would like to create a new filter which checks that both conditions are satisfied i.e. a read has 2 or fewer N's and is aligned to the reference genome. We can do this using the `compose` function which will create a new filter that is only satisfied if each constituent filter is satisfied.


```r
filt <- compose(nFilt, chrFilt)
```


> Finally we apply the filter to extract the relevant subset of data.


```r
bamDatFiltered <- bamDat[filt(bamDat)]
```


### Examining BAM Data

> We can examine the filtered BAM file and the annotations stored in `bamDatFiltered` object.

> Like most R objects the `str` function gives us a nice human readable description of the object.


```r
str(bamDatFiltered)
```

```
## Formal class 'AlignedRead' [package "ShortRead"] with 8 slots
##   ..@ chromosome  : Factor w/ 7 levels "chrM","chr2L",..: 1 1 1 1 1 1 1 1 1 1 ...
##   ..@ position    : int [1:56883] 548 1497 1506 1528 1540 1552 1552 1555 1559 1566 ...
##   ..@ strand      : Factor w/ 3 levels "+","-","*": 2 1 1 1 1 1 1 1 2 2 ...
##   ..@ alignQuality:Formal class 'NumericQuality' [package "ShortRead"] with 1 slots
##   .. .. ..@ quality: int [1:56883] 132 132 127 130 130 122 132 132 132 132 ...
##   ..@ alignData   :Formal class 'AlignedDataFrame' [package "ShortRead"] with 4 slots
##   .. .. ..@ varMetadata      :'data.frame':	1 obs. of  1 variable:
##   .. .. .. ..$ labelDescription: chr "Type of read; see ?scanBam"
##   .. .. ..@ data             :'data.frame':	56883 obs. of  1 variable:
##   .. .. .. ..$ flag: int [1:56883] 16 0 0 0 0 0 0 0 16 16 ...
##   .. .. ..@ dimLabels        : chr [1:2] "readName" "alignColumn"
##   .. .. ..@ .__classVersion__:Formal class 'Versions' [package "Biobase"] with 1 slots
##   .. .. .. .. ..@ .Data:List of 1
##   .. .. .. .. .. ..$ : int [1:3] 1 1 0
##   ..@ quality     :Formal class 'FastqQuality' [package "ShortRead"] with 1 slots
##   .. .. ..@ quality:Formal class 'BStringSet' [package "Biostrings"] with 5 slots
##   .. .. .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. .. .. ..@ group          : int [1:56883] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. .. .. ..@ start          : int [1:56883] 1 37 73 109 145 181 217 253 289 325 ...
##   .. .. .. .. .. .. ..@ width          : int [1:56883] 36 36 36 36 36 36 36 36 36 36 ...
##   .. .. .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. .. .. ..@ metadata       : list()
##   .. .. .. .. ..@ elementType    : chr "BString"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   ..@ sread       :Formal class 'DNAStringSet' [package "Biostrings"] with 5 slots
##   .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. ..@ group          : int [1:56883] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. ..@ start          : int [1:56883] 1 37 73 109 145 181 217 253 289 325 ...
##   .. .. .. .. ..@ width          : int [1:56883] 36 36 36 36 36 36 36 36 36 36 ...
##   .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   .. .. ..@ elementType    : chr "DNAString"
##   .. .. ..@ elementMetadata: NULL
##   .. .. ..@ metadata       : list()
##   ..@ id          :Formal class 'BStringSet' [package "Biostrings"] with 5 slots
##   .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
##   .. .. .. .. ..@ xp_list                    :List of 1
##   .. .. .. .. .. ..$ :<externalptr> 
##   .. .. .. .. ..@ .link_to_cached_object_list:List of 1
##   .. .. .. .. .. ..$ :<environment: 0x10905ecd0> 
##   .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
##   .. .. .. .. ..@ group          : int [1:56883] 1 1 1 1 1 1 1 1 1 1 ...
##   .. .. .. .. ..@ start          : int [1:56883] 1 29 57 85 114 144 173 202 230 260 ...
##   .. .. .. .. ..@ width          : int [1:56883] 28 28 28 29 30 29 29 28 30 30 ...
##   .. .. .. .. ..@ NAMES          : NULL
##   .. .. .. .. ..@ elementType    : chr "integer"
##   .. .. .. .. ..@ elementMetadata: NULL
##   .. .. .. .. ..@ metadata       : list()
##   .. .. ..@ elementType    : chr "BString"
##   .. .. ..@ elementMetadata: NULL
##   .. .. ..@ metadata       : list()
```


> If we wanted to see which chromosomes were present we could use `chromosome` function. This functions pulls out the chromosome field for all reads in the `bamDatFiltered` object. Rather than look at these values for each read, we will just look at which chromosomes are present using the `levels` function.


```r
levels(chromosome(bamDatFiltered))
```

```
## [1] "chrM"  "chr2L" "chrX"  "chr3L" "chr4"  "chr2R" "chr3R"
```


> We can look at the read IDs for each read using the `id` function. The next piece of code will look at the IDs for the first 10 reads in the file.


```r
id(bamDatFiltered)[1:10]
```

```
##   A BStringSet instance of length 10
##      width seq
##  [1]    28 HWI-EAS225_90320:3:1:141:680
##  [2]    28 HWI-EAS225_90320:3:1:660:332
##  [3]    28 HWI-EAS225_90320:3:1:164:226
##  [4]    29 HWI-EAS225_90320:3:1:1088:176
##  [5]    30 HWI-EAS225_90320:3:1:1038:1484
##  [6]    29 HWI-EAS225_90320:3:1:850:1742
##  [7]    29 HWI-EAS225_90320:3:1:1319:586
##  [8]    28 HWI-EAS225_90320:3:1:103:631
##  [9]    30 HWI-EAS225_90320:3:1:1353:1498
## [10]    30 HWI-EAS225_90320:3:1:1092:1016
```


> If we want to see the DNA sequence for the read we can use the `sread` method.


```r
sread(bamDatFiltered)[1:10]
```

```
##   A DNAStringSet instance of length 10
##      width seq
##  [1]    36 GGAAATCAAAAATGGAAAGGAGCGGCTCCACTTTTT
##  [2]    36 AAATCATAAAGATATTGGAACTTTATATTTTATTTT
##  [3]    36 AGATATTGGAACTTTATATTTTATTTTTGGAGCTTG
##  [4]    36 ATTTTTGGAGCTTGAGCTGGAATAGTTGGAACATCT
##  [5]    36 TGAGCTGGAATAGTTGGAACATCTTTAAGAATTTTA
##  [6]    36 GTTGGAACATCTTTAAGAATTTTAATTAGAGCTGAA
##  [7]    36 GTTGGAACATCTTTAAGAATTTTAATTCGAGCTGAA
##  [8]    36 GGAACATCTTTAAGAATTTTAATTCGAGCTGAATTA
##  [9]    36 GTCCTAATTCAGCTCGAATTAAAATTCTTAAAGATG
## [10]    36 CCAGGATGTCCTAATTCAGCTCGAATTAAAATTCTT
```


> An important point about sequencing data is that sometimes nucleotides can be incorrectly read by the sequencing machines. Base qualities are used to quantify how likely the observed nucleotide is to be correct. We can look at the base qualities using the `quality` function.


```r
quality(bamDatFiltered)[1:10]
```

```
## class: FastqQuality
## quality:
##   A BStringSet instance of length 10
##      width seq
##  [1]    36 BACBCCABBBBBA>8@B@@==>;5-9A<;=7A@@B@
##  [2]    36 BCBBABBA@@B;B>AB@@<>:AAA9?>?A@A<?A@@
##  [3]    36 @?8AB>A?=)A=@*8>6/@3>A)/@4>?BA'(-1B=
##  [4]    36 BBCACCA@-4ABC62?*;A?BBA?B@.8B9?33;+=
##  [5]    36 ?5@A4::@@55;;89<'6?A8@A=4@=>54>76);A
##  [6]    36 A8=B;462>;7BCBAA>1;=</?BA94%<:?(7@9=
##  [7]    36 BBB>ABB@@BBBBCBCC@7ABBBAABB@B?AAA@=@
##  [8]    36 =B=ACCBBC8ACCCBBBCCCBB=CAB9=BBBB@2?:
##  [9]    36 @7ABBBBABBB?BAAB=@CBB;7ABAABBA?@;2=A
## [10]    36 BB>B?:ABABBBBABCB@@@BB@:@BA;>@;@B?AB
```


> You'll notice the qualities are not numbers but ASCII characters. There is a formula specified in the SAM format for converting the character values into integer PHRED scores.

> We can find out the starting (left most) position where the read was aligned on the chromosome using the `position` function.


```r
position(bamDatFiltered)[1:10]
```

```
##  [1]  548 1497 1506 1528 1540 1552 1552 1555 1559 1566
```


> We can also see which strand (forward/+ or reverse/-) the read was aligned to using the `strand` function.


```r
strand(bamDatFiltered)[1:10]
```

```
##  [1] - + + + + + + + - -
## Levels: + - *
```


> What are the differences between the filtered and unfiltered BAM files?

The filtered file:

- Contains fewer reads - 56,883 vs. 62,206.
- Contains only reads aligning to chromosomes, with less than or equal to 2 N's in each read sequence.

> What are the chromosomes with aligned reads from the BAM file?


```r
levels(chromosome(bamDatFiltered))
```

```
## [1] "chrM"  "chr2L" "chrX"  "chr3L" "chr4"  "chr2R" "chr3R"
```


Get counts:


```r
df <- data.frame(id = id(bamDatFiltered), chrom = chromosome(bamDatFiltered))
summary(df$chrom)
```

```
##  chrM chr2L  chrX chr3L  chr4 chr2R chr3R 
##  1921  9839  8892  9231   739 12370 13891
```


## Accessing Genome Annotations

> Aligned read data is not much use without information about the genome it was aligned to. We will make use of the Drosophila database accessed through R to get some information about the Drosophila genome.

> First we will load the genomic database.


```r
library(BSgenome.Dmelanogaster.UCSC.dm3)
```

```
## Loading required package: BSgenome
```


> Now we can get the length of the chromsomes in the genome.


```r
(chrSizes <- seqlengths(Dmelanogaster))
```

```
##     chr2L     chr2R     chr3L     chr3R      chr4      chrX      chrU 
##  23011544  21146708  24543557  27905053   1351857  22422827  10049037 
##      chrM  chr2LHet  chr2RHet  chr3LHet  chr3RHet   chrXHet   chrYHet 
##     19517    368872   3288761   2555491   2517507    204112    347038 
## chrUextra 
##  29004656
```


> For the purposes of the seminar, we will only look at one chromosome, chr2L, and find the counts for genes on this chromosome. We use the BioMart functionality of the Ensembl database to retrieve the annotations of Drosophila melagoaster chromosome 2L.

> The first step will be to load the `biomaRt` library and specify that we want the Drospohila database.


```r
library(biomaRt)
ensembl <- useMart("ensembl", dataset = "dmelanogaster_gene_ensembl")
```


> Now we can download the genome annotation data. First we will define a set of fields we are interested for each gene. We will get the ENSEMBl gene ID, the strand the gene is on, the chromosome the gene is on, the start position of the gene on that chromosome and the end position of the gene.


```r
annotation.fields <- c("ensembl_gene_id", "strand", "chromosome_name", "start_position", 
    "end_position")
```


> Now we can download the actual annotation data. Because were are restricting attention to chr2L we will use the `filter` argument of the `getBM` function.


```r
gene.annotation <- getBM(annotation.fields, mart = ensembl, filters = "chromosome_name", 
    values = c("2L"))
str(gene.annotation)
```

```
## 'data.frame':	2986 obs. of  5 variables:
##  $ ensembl_gene_id: chr  "FBgn0031208" "FBgn0002121" "FBgn0031209" "FBgn0263584" ...
##  $ strand         : int  1 -1 -1 1 -1 1 1 1 -1 1 ...
##  $ chromosome_name: chr  "2L" "2L" "2L" "2L" ...
##  $ start_position : int  7529 9839 21823 21952 25402 66584 71757 76348 82421 94739 ...
##  $ end_position   : int  9484 21376 25155 24237 65404 71390 76211 77783 87387 102086 ...
```


> Lets check that we only downloaded annotations for chromosome 2L.


```r
levels(as.factor(gene.annotation$chromosome))
```

```
## [1] "2L"
```


> Now you'll notice the chromosome name lacks the "chr" prefix. This will cause issues as the BAM file we are using has uses the "chr" prefix to identify chromosomes. To rectify this we will add "chr" to the annotation data.


```r
gene.annotation$chromosome <- paste("chr", gene.annotation$chromosome_name, 
    sep = "")
levels(as.factor(gene.annotation$chromosome))
```

```
## [1] "chr2L"
```


> Two R packages, GRanges and IRanges, become handy when dealing with problems in genomics. For instance, they can be used for annotating the genome and storing the data.

> Example: annotating all the exons would require storing the information regarding their location. These intervals (the start and end of every exon) can be stored in an IRanges object. GRanges object can also store information regarding chromosome (seqnames) and strand and hence more specific to genomics.


```r
# We store the gene annotation information in an IRanges object
gene.range <- RangedData(IRanges(start = gene.annotation$start_position, end = gene.annotation$end_position), 
    space = gene.annotation$chromosome, strand = gene.annotation$strand, gene = gene.annotation$ensembl_gene_id, 
    universe = "Dm3")

show(gene.range)
```

```
## RangedData with 2986 rows and 2 value columns across 1 space
##         space               ranges   |    strand        gene
##      <factor>            <IRanges>   | <integer> <character>
## 1       chr2L       [ 7529,  9484]   |         1 FBgn0031208
## 2       chr2L       [ 9839, 21376]   |        -1 FBgn0002121
## 3       chr2L       [21823, 25155]   |        -1 FBgn0031209
## 4       chr2L       [21952, 24237]   |         1 FBgn0263584
## 5       chr2L       [25402, 65404]   |        -1 FBgn0051973
## 6       chr2L       [66584, 71390]   |         1 FBgn0067779
## 7       chr2L       [71757, 76211]   |         1 FBgn0031213
## 8       chr2L       [76348, 77783]   |         1 FBgn0031214
## 9       chr2L       [82421, 87387]   |        -1 FBgn0002931
## ...       ...                  ... ...       ...         ...
## 2978    chr2L [22690251, 22691008]   |        -1 FBgn0058439
## 2979    chr2L [22735486, 22736297]   |        -1 FBgn0262947
## 2980    chr2L [22736952, 22747273]   |         1 FBgn0041004
## 2981    chr2L [22811944, 22834955]   |         1 FBgn0002566
## 2982    chr2L [22841770, 22843208]   |        -1 FBgn0058005
## 2983    chr2L [22874534, 22885080]   |         1 FBgn0000384
## 2984    chr2L [22892306, 22918647]   |        -1 FBgn0250907
## 2985    chr2L [22959606, 22961179]   |        -1 FBgn0086683
## 2986    chr2L [22961737, 22963456]   |         1 FBgn0262887
```


### Calculating Coverage

> To do a differential expression analysis we will need data about how many reads align to a given gene. We can compute this type of coverage data using the `coverage` function.

> First lets find out how many bases cover each position in every chromosome.


```r
(cover <- coverage(bamDatFiltered, width = chrSizes))
```

```
## RleList of length 7
## $chrM
## integer-Rle of length 19517 with 953 runs
##   Lengths:  547   36  913    9   22    5 ...    3    5   13  258   36 5793
##   Values :    0    1    0    1    2    3 ...    4    3    2    0    1    0
## 
## $chr2L
## integer-Rle of length 23011544 with 17850 runs
##   Lengths:  6777    36  2316    36  1621 ...   107    36   499    36 50474
##   Values :     0     1     0     1     0 ...     0     1     0     1     0
## 
## $chrX
## integer-Rle of length 22422827 with 16522 runs
##   Lengths:  18996     36  12225     36 ...     36    130     36   6180
##   Values :      0      1      0      1 ...      1      0      1      0
## 
## $chr3L
## integer-Rle of length 24543557 with 17396 runs
##   Lengths: 135455     36   6783     23 ...     36  82251     36  12469
##   Values :      0      1      0      1 ...      1      0      1      0
## 
## $chr4
## integer-Rle of length 1351857 with 1255 runs
##   Lengths:  59510     36   2019     36 ...     36    267     36 118808
##   Values :      0      1      0      1 ...      1      0      1      0
## 
## ...
## <2 more elements>
```


> For differential expression analysis we will need coverage on a per gene basis.


```r
# Aggregating the coverage for each gene
gene.coverage <- aggregate(cover[match(names(gene.range), names(cover))], ranges(gene.range), 
    sum)

# Finding the number of reads covering each gene
gene.coverage <- ceiling(gene.coverage/unique(width(bamDat)))
gene.coverage
```

```
## NumericList of length 1
## [["chr2L"]] 1 47 0 0 1 6 0 0 8 11 1 1 58 ... 17 16 1 0 0 0 15 4 0 1 0 6 0
```


> Restricting attention to chr2L.


```r
# Note that the number of entities with coverage count on chromosome 2L is
# equal to the number of genes on chromosome 2L.
length(gene.coverage[["chr2L"]])
```

```
## [1] 2986
```

```r
length(ranges(gene.range)$chr2L)
```

```
## [1] 2986
```


> Using the coverage and gene annotation data, we can now build a count table and store it in a data frame.


```r
countTable <- data.frame(chromosome = gene.range$space, gene_start = start(gene.range$ranges), 
    gene_end = end(gene.range$ranges), strand = gene.range$strand, gene = gene.range$gene, 
    count = as.vector(gene.coverage[["chr2L"]]))
dim(countTable)
```

```
## [1] 2986    6
```

```r
head(countTable)
```

```
##   chromosome gene_start gene_end strand        gene count
## 1      chr2L       7529     9484      1 FBgn0031208     1
## 2      chr2L       9839    21376     -1 FBgn0002121    47
## 3      chr2L      21823    25155     -1 FBgn0031209     0
## 4      chr2L      21952    24237      1 FBgn0263584     0
## 5      chr2L      25402    65404     -1 FBgn0051973     1
## 6      chr2L      66584    71390      1 FBgn0067779     6
```


> Some methods for doing differential expression analysis such as [edgeR](http://www.bioconductor.org/packages/2.11/bioc/html/edgeR.html) can work from the raw count data.

> Other methods use normalized coverage statistics. The calculated raw number of read counts need to be normalizes for two reasons:

> 1. Longer genes will have more reads aligned to them, thus we need to normalize the read count by gene length.

> 2. Libraries with larger overall number of reads will have more reads aligned to genes compared with a library with less number of total reads. As a result, the normalization should also take into account the library size (total number of reads generated).

> The most widely used normalization value is RPKM defined as the "number of Reads Per Kilobase of gene (feature) per Million mapped reads" (Mortazavi et al, 2008).


```r
countTable <- data.frame(chromosome = gene.range$space, gene_start = start(gene.range$ranges), 
    gene_end = end(gene.range$ranges), strand = gene.range$strand, gene = gene.range$gene, 
    count = as.vector(gene.coverage[["chr2L"]]), RPKM = (as.vector(gene.coverage[["chr2L"]])/(end(gene.range$ranges) - 
        start(gene.range$ranges))) * (1e+09/length(bamDat)))
head(countTable)
```

```
##   chromosome gene_start gene_end strand        gene count    RPKM
## 1      chr2L       7529     9484      1 FBgn0031208     1  7.9667
## 2      chr2L       9839    21376     -1 FBgn0002121    47 63.4497
## 3      chr2L      21823    25155     -1 FBgn0031209     0  0.0000
## 4      chr2L      21952    24237      1 FBgn0263584     0  0.0000
## 5      chr2L      25402    65404     -1 FBgn0051973     1  0.3894
## 6      chr2L      66584    71390      1 FBgn0067779     6 19.4443
```


## Take Home Problem
> Create a similar count table for all the exons located on chr2L.

## References
> This seminar is based on a Bioconductor [RNA-Seq tutorial](http://www.bioconductor.org/packages/2.11/data/experiment/html/RnaSeqTutorial.html)
