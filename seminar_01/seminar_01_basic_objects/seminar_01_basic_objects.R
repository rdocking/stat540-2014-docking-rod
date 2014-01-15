# R Basic objects
# Code is mainly from: 
# http://www.stat.ubc.ca/~jenny/STAT545A/block03_basicObjects.html#vectors-are-everywhere

# Vectors are everywhere
# Making indices and an array out of what looked like an int at first!
x <- 3 * 4
x
is.vector(x)
length(x)
x[2] <- 100
x
x[5] <- 3
x
x[11]
x[0]

x <- 1:4
(y <- x^2) # vectorized - good!
z <- vector(mode = mode(x), length = length(x))
for (i in seq_along(x)) { # for loop - ugly!
  z[i] <- x[i]^2
}
identical(y, z)

set.seed(1999)
rnorm(5, mean = 10^(1:5)) # normal distribution, 5 observations, on a vector of means
round(rnorm(5, sd = 10^(0:4)), 2)

# Recycling examples - steer clear if not intentional!
(y <- 1:3)
## [1] 1 2 3
(z <- 3:7)
## [1] 3 4 5 6 7
y + z
## Warning: longer object length is not a multiple of shorter object length
## [1] 4 6 8 7 9
(y <- 1:10)
##  [1]  1  2  3  4  5  6  7  8  9 10
(z <- 3:7)
## [1] 3 4 5 6 7
y + z
##  [1]  4  6  8 10 12  9 11 13 15 17
# Note that there's no warning in this second case!

# Concatenate function examples
str(c("hello", "world"))
str(c(1:3, 100, 150))

# Coercion examples
(x <- c("cabbage", pi, TRUE, 4.3))
str(x)
length(x)
mode(x)
class(x)
# These are coerced to characters!

n <- 8
set.seed(1)
(w <- round(rnorm(n), 2))  # numeric floating point
## [1] -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
(x <- 1:n)  # numeric integer
## [1] 1 2 3 4 5 6 7 8
## another way to accomplish by hand is x <- c(1, 2, 3, 4, 5, 6, 7, 8)
(y <- LETTERS[1:n])  # character
## [1] "A" "B" "C" "D" "E" "F" "G" "H"
(z <- runif(n) > 0.3)  # logical
## [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE

str(w)
##  num [1:8] -0.63 0.18 -0.84 1.6 0.33 -0.82 0.49 0.74
length(x)
## [1] 8
is.logical(y)
## [1] FALSE
as.numeric(z)
## [1] 1 1 1 1 1 0 1 0

# Indexing vectors
w
## [1] -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
names(w) <- letters[seq_along(w)]
w
##     a     b     c     d     e     f     g     h 
## -0.63  0.18 -0.84  1.60  0.33 -0.82  0.49  0.74
w < 0
##     a     b     c     d     e     f     g     h 
##  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE
which(w < 0)
## a c f 
## 1 3 6
w[w < 0]
##     a     c     f 
## -0.63 -0.84 -0.82
seq(from = 1, to = length(w), by = 2)
## [1] 1 3 5 7
w[seq(from = 1, to = length(w), by = 2)]
##     a     c     e     g 
## -0.63 -0.84  0.33  0.49
w[-c(2, 5)]
##     a     c     d     f     g     h 
## -0.63 -0.84  1.60 -0.82  0.49  0.74
w[c("c", "a", "f")]
##     c     a     f 
## -0.84 -0.63 -0.82

# List example to contrast with vectors
## earlier: a <- c('cabbage', pi, TRUE, 4.3)
(a <- list("cabbage", pi, TRUE, 4.3))
str(a)
length(a)
mode(a)
class(a)

names(a)
names(a) <- c("veg", "dessert", "myAim", "number")
a
a <- list(veg = "cabbage", dessert = pi, myAim = TRUE, number = 4.3)
names(a)

# Back to data frame examples
n <- 8
set.seed(1)
(jDat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))
str(jDat)
mode(jDat)
class(jDat)

# Matrices
jMat <- outer(as.character(1:4), as.character(1:4), function(x, y) {
  paste0("x", x, y)
})
jMat
rownames(jMat) <- paste0("row", seq_len(nrow(jMat)))
colnames(jMat) <- paste0("col", seq_len(ncol(jMat)))
dimnames(jMat)  # also useful for assignment
jMat
jMat[1, grepl("[24]", colnames(jMat))]

# Creating matrices
matrix(1:15, nrow = 5)
matrix("yo!", nrow = 3, ncol = 6)
matrix(c("yo!", "foo?"), nrow = 3, ncol = 6)
matrix(1:15, nrow = 5, byrow = TRUE)
matrix(1:15, nrow = 5, dimnames = list(paste0("row", 1:5), paste0("col", 1:3)))

vec1 <- 5:1
vec2 <- 2^(1:5)
cbind(vec1, vec2)
rbind(vec1, vec2)

vecDat <- data.frame(vec1 = 5:1,
                     vec2 = 2^(1:5))
str(vecDat)
vecMat <- as.matrix(vecDat)
str(vecMat)

# Finishes up with a range of ways to index, subset, and slice data frames