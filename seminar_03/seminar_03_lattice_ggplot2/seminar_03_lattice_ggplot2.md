STAT540 Seminar 03 - lattice and ggplot2 graphics
=================================================

Rod Docking - 2014-01-23

This is a workthrough of the material for the [lattice](http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar03_graphics-lattice.html) and [ggplot2](http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar03_graphics-ggplot2.html)
tutorials for STAT540.

Load the necessary libraries:


```r
library(lattice)
library(ggplot2)
```


Read in the input data set. 
(*Note that this is reading from a symlink to to the original data file from the course repo*)


```r
kDat <- readRDS("GSE4051_MINI.rds")
str(kDat)
```

```
## 'data.frame':	39 obs. of  7 variables:
##  $ sidChar   : chr  "Sample_20" "Sample_21" "Sample_22" "Sample_23" ...
##  $ sidNum    : num  20 21 22 23 16 17 6 24 25 26 ...
##  $ devStage  : Factor w/ 5 levels "E16","P2","P6",..: 1 1 1 1 1 1 1 2 2 2 ...
##  $ gType     : Factor w/ 2 levels "wt","NrlKO": 1 1 1 1 2 2 2 1 1 1 ...
##  $ crabHammer: num  10.22 10.02 9.64 9.65 8.58 ...
##  $ eggBomb   : num  7.46 6.89 6.72 6.53 6.47 ...
##  $ poisonFang: num  7.37 7.18 7.35 7.04 7.49 ...
```

```r
table(kDat$devStage)
```

```
## 
##     E16      P2      P6     P10 4_weeks 
##       7       8       8       8       8
```

```r
table(kDat$gType)
```

```
## 
##    wt NrlKO 
##    20    19
```

```r
with(kDat, table(devStage, gType))
```

```
##          gType
## devStage  wt NrlKO
##   E16      4     3
##   P2       4     4
##   P6       4     4
##   P10      4     4
##   4_weeks  4     4
```


Scatterplots
------------

Make a scatterplot of the expression of two separate genes:


```r
xyplot(eggBomb ~ crabHammer, kDat)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


> You try: request a scatterplot of the variable poisonFang against crabHammer.

OK:


```r
xyplot(poisonFang ~ crabHammer, kDat)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 


> Let's imagine that crabHammer is somehow a natural explanatory variable or predictor (weird here, I admit, but go with me) and eggBomb and poisonFang are natural response variables. We might want to see both responses plotted against crabHammer at the same time. Here is a first way to do so, using a bit of a cheat known as the "extended formula interface" in lattice.


```r
xyplot(eggBomb + poisonFang ~ crabHammer, kDat, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


> What if we want each response to have it's own scatterplot, but we want to put them side-by-side for comparison?


```r
xyplot(eggBomb + poisonFang ~ crabHammer, kDat, outer = TRUE, grid = TRUE)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 


> What if we'd like to know which points are from the wild type mice versus the Nrl knockouts?


```r
xyplot(eggBomb + poisonFang ~ crabHammer, kDat, outer = TRUE, grid = TRUE, groups = gType, 
    auto.key = TRUE)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 


Reshape the data into a better format:


```r
nDat <- with(kDat, data.frame(sidChar, sidNum, devStage, gType, crabHammer, 
    probeset = factor(rep(c("eggBomb", "poisonFang"), each = nrow(kDat))), geneExp = c(eggBomb, 
        poisonFang)))
str(nDat)
```

```
## 'data.frame':	78 obs. of  7 variables:
##  $ sidChar   : Factor w/ 39 levels "Sample_1","Sample_10",..: 13 14 15 16 8 9 36 17 18 19 ...
##  $ sidNum    : num  20 21 22 23 16 17 6 24 25 26 ...
##  $ devStage  : Factor w/ 5 levels "E16","P2","P6",..: 1 1 1 1 1 1 1 2 2 2 ...
##  $ gType     : Factor w/ 2 levels "wt","NrlKO": 1 1 1 1 2 2 2 1 1 1 ...
##  $ crabHammer: num  10.22 10.02 9.64 9.65 8.58 ...
##  $ probeset  : Factor w/ 2 levels "eggBomb","poisonFang": 1 1 1 1 1 1 1 1 1 1 ...
##  $ geneExp   : num  7.46 6.89 6.72 6.53 6.47 ...
```


> Now we can make the previous plot with more canonical lattice syntax, i.e. this workflow and way of thinking will serve you better in the future:

(*Note - above, we've put eggBomb and poisonFang into a new varaible, geneExpe*)


```r
xyplot(geneExp ~ crabHammer | probeset, nDat, grid = TRUE, groups = gType, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 


> You try: Remake this plot but instead of conveying genotype via color, show developmental stage.

OK:


```r
xyplot(geneExp ~ crabHammer | probeset, nDat, grid = TRUE, groups = devStage, 
    auto.key = TRUE)
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


Stripplot
---------

> The next set of figures we will make requires yet more data reshaping, which is a substantial background task in many analyses. We drop the idea of crabHammer being a predictor and eggBomb and poisonFang being responses and we just treat them all equivalently.


```r
oDat <- with(kDat, data.frame(sidChar, sidNum, devStage, gType, probeset = factor(rep(c("crabHammer", 
    "eggBomb", "poisonFang"), each = nrow(kDat))), geneExp = c(crabHammer, eggBomb, 
    poisonFang)))
str(oDat)
```

```
## 'data.frame':	117 obs. of  6 variables:
##  $ sidChar : Factor w/ 39 levels "Sample_1","Sample_10",..: 13 14 15 16 8 9 36 17 18 19 ...
##  $ sidNum  : num  20 21 22 23 16 17 6 24 25 26 ...
##  $ devStage: Factor w/ 5 levels "E16","P2","P6",..: 1 1 1 1 1 1 1 2 2 2 ...
##  $ gType   : Factor w/ 2 levels "wt","NrlKO": 1 1 1 1 2 2 2 1 1 1 ...
##  $ probeset: Factor w/ 3 levels "crabHammer","eggBomb",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ geneExp : num  10.22 10.02 9.64 9.65 8.58 ...
```


> A stripplot is a univariate scatterplot. Let's inspect the gene expression data, plain and simple.


```r
stripplot(~geneExp, oDat)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


> Pretty boring and slightly nonsensical! We had to start somewhere. Let's split things out for the three different genes.


```r
stripplot(probeset ~ geneExp, oDat)
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 


> Sometimes, it can help to add jitter, a small bit of meaningless noise, in the horizontal position.


```r
stripplot(probeset ~ geneExp, oDat, jitter.data = TRUE)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 


> Notice that all the data is presented in one panel but with the different genes corresponding to different locations in the y direction. What if we want to put the different genes in different panels?


```r
stripplot(~geneExp | probeset, oDat, layout = c(nlevels(oDat$probeset), 1))
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15.png) 


> What if we want to see information about wild type versus Nrl knockout?


```r
stripplot(~geneExp | probeset, oDat, layout = c(nlevels(oDat$probeset), 1), 
    groups = gType, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 


> Let's start exploring gene expression changes over the course of development.


```r
stripplot(geneExp ~ devStage, oDat)
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17.png) 


> Retaining one panel per gene ....


```r
stripplot(geneExp ~ devStage | probeset, oDat, layout = c(nlevels(oDat$probeset), 
    1))
```

![plot of chunk unnamed-chunk-18](figure/unnamed-chunk-18.png) 


> Adding back the genotype information ....


```r
stripplot(geneExp ~ devStage | probeset, oDat, layout = c(nlevels(oDat$probeset), 
    1), groups = gType, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-19](figure/unnamed-chunk-19.png) 


> Adding averages


```r
stripplot(geneExp ~ devStage | probeset, oDat, layout = c(nlevels(oDat$probeset), 
    1), groups = gType, auto.key = TRUE, grid = TRUE, type = c("p", "a"))
```

![plot of chunk unnamed-chunk-20](figure/unnamed-chunk-20.png) 


> The argument 'type' can be used to add a variety of enhancements. Type is specified as a vector (through the use of 'c'). The option 'p' in the above example specifies the data as points on the plot, 'a' refers to getting the average of each category and joining them by a line (other summaries can be requested too). Some of the other options include 'l' for joining points by lines, 'b' for both points and lines, 'r' for adding the fit from a simple linear regression and 'smooth' for adding a nonparametric "smooth" fitted curve.

Densityplot
-----------

> Here's a nice alternative to histograms!


```r
densityplot(~geneExp, oDat)
```

![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21.png) 


(*Note - the stripplot of points seems to be part of the default here*)

> The vertical bar works as usual.


```r
densityplot(~geneExp | gType, oDat, grid = TRUE)
```

![plot of chunk unnamed-chunk-22](figure/unnamed-chunk-22.png) 


> `groups` works as usual -- a real advantage over histogram.


```r
densityplot(~geneExp, oDat, groups = gType, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23.png) 


> The argument 'bw' specifies the bandwidth or the spread of the underlying Gaussian distributions. It controls how smooth this smoothed histogram will be. Though densityplot() has a sensible default, you can always specify directly if you wish. The argument 'n' controls the number of points at which the kernel density estimate is evaluated. It is easy to confuse this with the usual use of 'n' to denote sample size, so beware. If your density looks jaggedy, try increasing 'n'.


```r
jBw <- 0.2
jn <- 400
densityplot(~geneExp, oDat, groups = gType, auto.key = TRUE, bw = jBw, n = jn, 
    main = paste("bw =", jBw, ", n =", jn))
```

![plot of chunk unnamed-chunk-24](figure/unnamed-chunk-24.png) 


> You try: use densityplot() to explore the gene expression distribution by gene and/or developmental stage. Play with 'bw' and 'n' if you like.

Try colouring by gene:


```r
densityplot(~geneExp, oDat, groups = probeset, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25.png) 


And then by developmental stage:


```r
densityplot(~geneExp, oDat, groups = devStage, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26.png) 


Try splitting into panels (colour is devStage, panels are split by probe):


```r
densityplot(~geneExp | probeset, oDat, groups = devStage, auto.key = TRUE)
```

![plot of chunk unnamed-chunk-27](figure/unnamed-chunk-27.png) 


Boxplot
-------

> There is also a time and place for boxplots, obtained with the lattice function bwplot() for "box-and-whiskers plot".

```r
bwplot(geneExp ~ devStage, oDat)
```

![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28.png) 


> The vertical bar | still works ....


```r
bwplot(geneExp ~ devStage | gType, oDat)
```

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29.png) 


> A violinplot is a hybrid of densityplot and histogram.


```r
bwplot(geneExp ~ devStage, oDat, panel = panel.violin)
```

![plot of chunk unnamed-chunk-30](figure/unnamed-chunk-30.png) 


Heatmaps
--------



