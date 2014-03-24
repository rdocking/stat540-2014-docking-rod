R Cheatsheet
============

Online References
-----------------

[Quick-R](http://www.statmethods.net)
[Cookbook for R](http://www.cookbook-r.com)
[An R Introduction to Statistics](http://www.r-tutor.com)
[R-seek](http://www.rseek.org)
[Advanced R Programming](http://adv-r.had.co.nz)

Useful Blog Posts
-----------------

[Fitting & Interpreting Linear Models in R](http://blog.yhathq.com/posts/r-lm-summary.html)

Commonly Used Libraries
-----------------------

`ggplot2` - Grammar of Graphics plotting
`knitr` - Convert .Rmd files to markdown and html
`lattice` - Lattice Graphics
`limma` - Linear Models for Microarray Data
`MASS` - Support datasets for Venables and Ripley text
`plyr` - split, apply, recombine
`stats` - Common statistical functions

Constants
---------

```{r}
LETTERS # A B C ...
letters # a b c ...
month.abb # "Jan" "Feb" "Mar" ...
month.name # "January" "February" "March" ...
pi # 3.141593
```

Useful Functions
----------------

`addmargins` - puts arbitrary margins on multidimensional tables or arrays
`aggregate` - compute summary statistics of data subsets
`anova` - Compute analysis of variance (or deviance) tables for one or more fitted model objects.
`apply` - apply functions over array margins
`apropos` - find objects by partial name
`c` - combine values into a vector or list
`coef` - extract the coefficients from a fitted model
`droplevels` - drop unused levels from a factor or, more commonly, from factors in a data frame.
`grep` - Pattern Matching and Replacement
`head` - return the first part of an object
`identical` - test for exact identity
`nrow`, `ncol` - the number of rows or columns
`par` - Set or Query Graphical Parameters
`p.adjust` - Given a set of p-values, returns p-values adjusted using one of several methods.
`round(x, digits = 0)` - round numbers
`subset` - return subsets of vectors, matrices or data frames which meet conditions
`t` - transpose
`table` - make a contingency table
`tail` - return the last part of an object
`which` - Give the TRUE indices of a logical object, allowing for array indices.
`with` - Evaluate an R expression in an environment constructeed from data

Statistical Tests
-----------------

`ks.test` - Perform a one- or two-sample Kolmogorov-Smirnov test.
`lm` - fit a linear model
`t.test` - Performs one and two sample t-tests on vectors of data.
`wilcox.test` - Wilcoxon Rank Sum and Signed Rank Tests

User-defined Functions
----------------------

```{r}
myfunction <- function(arg1, arg2, ... ){
statements
return(object)
}
```

Package-specific Links and Functions
------------------------------------

### `class`

Functions for classification

`knn` - k-Nearest Neighbour Classification

### `knitr`

[knitr](http://yihui.name/knitr/)
[Chunk options](http://yihui.name/knitr/options#chunk_options)

`kable` - Create tables in LaTeX, HTML, Markdown and reStructuredText

#### Some useful chunk options

`{r eval=FALSE}` - don't evaluate the code in this chunk
`{r results='asis'}` - put the results directly into the document (useful for inserting raw markdown or html)

### `lattice`

`cloud` - 3d Scatter Plot and Wireframe Surface Plot

### `limma`

`decideTests` - Classify a series of related t-statistics as up, down or not significant
`eBayes` - Empirical Bayes Statistics for Differential Expression
`lmFit` - Fit linear model for each gene given a series of arrays
`makeContrasts` - Construct the contrast matrix corresponding to specified contrasts of a set of parameters.
`model.matrix` - creates a design (or model) matrix.
`topTable` - Table of Top Genes from Linear Model Fit

### `pvclust`

Hierarchical Clustering with P-Values via Multiscale Bootstrap Resampling

`pvclust` - Calculating P-values for Hierchical Clustering
`pvrect` - Find Clusters with High/Low P-values

### `RColorBrewer`

`display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE)` - show all available Brewer palettes

### `stats`

`heatmap` - Draw a Heat Map
`hclust` - Hierarchical clustering
`kmeans` - K-Means Clustering
`rect.hclust` - Draw Rectangles Around Hierarchical Clusters
`prcomp` - Principal Components Analysis

Test
