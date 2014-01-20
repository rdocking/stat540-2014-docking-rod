# STAT540 Seminar 02
# Workthrough of the material at:
# http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar02_playing-with-probability.html

# Different ways to call a function
rnorm(n=10)
rnorm(10) # Equivalent
rnorm(n=10, mean=100, sd=10)

rnorm(mean=500, n=50, sd=5)
rnorm(sd=0, mean=0, n=1000)

# Set seed for future work
set.seed(540)
rnorm(10)

# Generate a matrix the R way
n <- 10
B <- 4
x <- matrix(rnorm(n * B), nrow = n)
str(x)

# ... and other not-so-good ways
x <- matrix(0, nrow = n, ncol = B)
for(j in 1:B) {
  x[ , j] <- rnorm(n)
}

# or worse...
sample1 <- rnorm(n)
sample2 <- rnorm(n)
sample3 <- rnorm(n)
sample4 <- rnorm(n)
x <- cbind(sample1, sample2, sample3, sample4)

x <- rnorm(n)
for(j in 1:(B - 1)) {
  x <- cbind(x, rnorm(n))
}

# Back to the good way...
x <- matrix(rnorm(n * B), nrow = n)
rownames(x) <- sprintf("obs%02d", 1:n)    # set row names
colnames(x) <- sprintf("samp%02d", 1:B)   # set col names
x
dim(x)

# Take sample means
mean(x[ , 2]) # sample mean for 2nd sample
colMeans(x)   # means for all columns
apply(x, 2, mean)
apply(x, c(1,2), mean) # try for rows and columns
apply(x, 1, mean) # or just rows

# Exercise: Recall the claim that the expected value of the sample mean is the true mean. 
# Compute the average of the 4 sample means we have. 
# Is it (sort of) close the true mean? Feel free to change n or B at any point.
mean(colMeans(x))   # mean for all samples
# Yes, close to the expected mean of 0
# Adjust n and b to large numbers and re-calculate
n <- 100
B <- 100
x <- matrix(rnorm(n * B), nrow = n)
mean(colMeans(x))   # mean for all samples
# Not much closer at this point

# Exercise: Recall the Weak Law of Large Numbers said that, as the sample size gets bigger, 
# the distribution of the sample means gets more concentrated around the true mean. 
# Recall also that the variance of the sample mean is equal to the true data-generating 
# variance divided by the sample size n. Explore these probability facts empirically. 


