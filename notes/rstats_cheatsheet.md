R Cheatsheet
============

Commonly Used Libraries
-----------------------

`lattice` - Lattice Graphics
`ggplot2` - Grammar of Graphics
`MASS` - Support datasets for Venables and Ripley text


```r
library(lattice)
library(ggplot2)
library(MASS)
```


Constants
---------


```r
LETTERS
```

```
##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
## [18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
```

```r
letters
```

```
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
## [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"
```

```r
month.abb
```

```
##  [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov"
## [12] "Dec"
```

```r
month.name
```

```
##  [1] "January"   "February"  "March"     "April"     "May"      
##  [6] "June"      "July"      "August"    "September" "October"  
## [11] "November"  "December"
```

```r
pi
```

```
## [1] 3.142
```


Useful for generating lists like so:


```r
(names <- seq_along(letters[1:10]))
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```



Useful Functions
----------------

`apropos` - Find objects by partial name


```r
apropos("^geom_")
```

```
##  [1] "geom_abline"     "geom_area"       "geom_bar"       
##  [4] "geom_bin2d"      "geom_blank"      "geom_boxplot"   
##  [7] "geom_contour"    "geom_crossbar"   "geom_density"   
## [10] "geom_density2d"  "geom_dotplot"    "geom_errorbar"  
## [13] "geom_errorbarh"  "geom_freqpoly"   "geom_hex"       
## [16] "geom_histogram"  "geom_hline"      "geom_jitter"    
## [19] "geom_line"       "geom_linerange"  "geom_map"       
## [22] "geom_path"       "geom_point"      "geom_pointrange"
## [25] "geom_polygon"    "geom_quantile"   "geom_raster"    
## [28] "geom_rect"       "geom_ribbon"     "geom_rug"       
## [31] "geom_segment"    "geom_smooth"     "geom_step"      
## [34] "geom_text"       "geom_tile"       "geom_violin"    
## [37] "geom_vline"
```


`head`, `tail` - return the first or last part of an object


```r
head(letters)
```

```
## [1] "a" "b" "c" "d" "e" "f"
```

```r
tail(letters)
```

```
## [1] "u" "v" "w" "x" "y" "z"
```


`which` - Give the TRUE indices of a logical object, allowing for array indices.


```r
which(c(TRUE, FALSE))
```

```
## [1] 1
```


`with` - Evaluate an R expression in an environment constructeed from data


```r
library(MASS)
with(anorexia, {
    anorex.1 <- glm(Postwt ~ Prewt + Treat + offset(Prewt), family = gaussian)
    summary(anorex.1)
})
```

```
## 
## Call:
## glm(formula = Postwt ~ Prewt + Treat + offset(Prewt), family = gaussian)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -14.108   -4.277   -0.548    5.484   15.292  
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   49.771     13.391    3.72  0.00041 ***
## Prewt         -0.566      0.161   -3.51  0.00080 ***
## TreatCont     -4.097      1.893   -2.16  0.03400 *  
## TreatFT        4.563      2.133    2.14  0.03604 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for gaussian family taken to be 48.7)
## 
##     Null deviance: 4525.4  on 71  degrees of freedom
## Residual deviance: 3311.3  on 68  degrees of freedom
## AIC: 490
## 
## Number of Fisher Scoring iterations: 2
```


