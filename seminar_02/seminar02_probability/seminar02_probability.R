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

n <- 10000
B <- 10000
x <- matrix(rnorm(n * B), nrow = n)
mean(colMeans(x))   # mean for all samples
# closer to 0!

# Exercise: Recall the Weak Law of Large Numbers said that, as the sample size gets bigger, 
# the distribution of the sample means gets more concentrated around the true mean. 
# Recall also that the variance of the sample mean is equal to the true data-generating 
# variance divided by the sample size n. Explore these probability facts empirically. 

# Brute-force for at first, then tidy up the code...
n <- 10000 # Set sample size
num_samp <- 10000 # Set number of samples
x  <- matrix(rnorm(n * num_samp), nrow=num_samp) # Draw from normal distribution
rownames(x) <- sprintf("obs%02d", 1:n)    # set row names
colnames(x) <- sprintf("samp%02d", 1:num_samp)   # set col names
str(x)
x_bar <- colMeans(x) # Take the mean of each sample
(true_sem <- 1 / sqrt(n)) # Std_dev used above was 1, this is the expected SEM
(obs_sem <- sd(x) / sqrt(n)) # Observed standard error of the mean
(samp_mean_IQR <- IQR(x_bar)) # Inter-quartile range of the sample means
(samp_mean_mad <- mad(x_bar)) # median absolute deviation of the sample means

# OK - these numbers match the example pretty well. 
# Here's the more sophisticated solution from GitHub:
B <- 1000
n <- 10^(1:4)
names(n) <- paste0("n", n)
getSampleMeans <- function(n, B) colMeans(matrix(rnorm(n * B), nrow = n))
x <- sapply(n, getSampleMeans, B, simplify = FALSE)
cbind(sampSize = n,
      trueSEM = 1 / sqrt(n),
      obsSEM = sapply(x, sd),
      sampMeanIQR = sapply(x, IQR),
      sampMeanMad = sapply(x, mad))

# Exercise: Repeat the above for a different distribution
# Repeat for chi-squared ditribution
B <- 1000
n <- 10^(1:4)
names(n) <- paste0("n", n)
getSampleMeans <- function(n, B) colMeans(matrix(rchisq(n * B, df=1), nrow = n))
x <- sapply(n, getSampleMeans, B, simplify = FALSE)
cbind(sampSize = n,
      trueSEM = 1 / sqrt(n),
      obsSEM = sapply(x, sd),
      sampMeanIQR = sapply(x, IQR),
      sampMeanMad = sapply(x, mad))


# Compare probabilities and observe relative frequencies ------------------------------------

# Exercise: Generate a reasonably large sample from some normal distribution 
# (it need not be standard normal!). Pick a threshhold. 
# What is the CDF at that threshhold, i.e. what's the true probability of seeing an 
# observation less than or equal to the threshhold? 
# Use your large sample to compute the observed proportion of observations that
# are less than threshhold. Are the two numbers sort of close? 
# Hint: If x is a numeric vector, then mean(x <= threshhold) computes the proportion 
# of values less than or equal to threshhold.

# Get a reasonably large sample from some normal distribution
n <- 10000
dist_mean <- 100
dist_sd <- 10
x <- rnorm(n, mean=dist_mean, sd=dist_sd)
# Plot to check
plot(density(x))

# Pick a threshold
threshold <- 80

# What is the CDF at that threshhold, i.e. what's the true probability of seeing an 
# observation less than or equal to the threshhold? 
(exp_cdf <- pnorm(threshold, mean=dist_mean, sd=dist_sd))

# Use your large sample to compute the observed proportion of observations that are less than threshhold. 
(obs_cdf <- mean(x <= threshold))

# Are the two numbers sort of close?
abs(exp_cdf - obs_cdf)
# Yes, they're close!

# Exercise: Do the same for a different distribution.
n <- 10000
dist_df <- 100
x <- rchisq(n, df=dist_df)
plot(density(x))
threshold <- 80
(exp_cdf <- pchisq(threshold, df=dist_df))
(obs_cdf <- mean(x <= threshold))
(abs(exp_cdf - obs_cdf))
# The values are close again

# Exercise: Do the same for a variety of sample sizes. 
# Do the two numbers tend to be closer for larger samples?
n_one <- 10
n_two <- 100
n_three <- 1000
dist_mean <- 100
dist_sd <- 10
threshold <- 80
x_one <- rnorm(n_one, mean=dist_mean, sd=dist_sd)
x_two <- rnorm(n_two, mean=dist_mean, sd=dist_sd)
x_three <- rnorm(n_three, mean=dist_mean, sd=dist_sd)
(exp_cdf <- pnorm(threshold, mean=dist_mean, sd=dist_sd))
(obs_cdf_one <- mean(x_one <= threshold))
(obs_cdf_two <- mean(x_two <= threshold))
(obs_cdf_three <- mean(x_two <= threshold))
# By the time n gets to 100, the obs and expected are close to each other

# Exercise: Instead of focusing on values less than the threshhold, 
# focus on values greater than the threshhold.
# To do this, change lower.tail = TRUE to lower.tail = FALSE
n <- 10000
dist_mean <- 100
dist_sd <- 10
x <- rnorm(n, mean=dist_mean, sd=dist_sd)
plot(density(x))
threshold <- 80
(exp_cdf <- pnorm(threshold, mean=dist_mean, sd=dist_sd, lower.tail=FALSE))
(obs_cdf <- mean(x >= threshold))
(abs(exp_cdf - obs_cdf))
# The observed and expected again match closely

# Exercise: Instead of focusing on tail probabilities, focus on the probability 
# of the observed values falling in an interval.
n <- 10000
dist_mean <- 100
dist_sd <- 10
x <- rnorm(n, mean=dist_mean, sd=dist_sd)
plot(density(x))
low_threshold <- 80
high_threshold <- 120
observed <- mean(x >= low_threshold & x <= high_threshold)
expected <- ( 1 - 
                pnorm(low_threshold, mean=dist_mean, sd=dist_sd, lower.tail=TRUE) -
                pnorm(high_threshold, mean=dist_mean, sd=dist_sd, lower.tail=FALSE))
abs(observed - expected)
# There's probably a better way to do this, but in both cases ~95% of the data falls between 80-120

# Explore the distribution of sample means and the CLT ------------------------------------

library(lattice)

## theoretical vs. empirical distriubution for a single sample
## demo of the Central Limit Theorem
n <- 35
x  <- rnorm(n)
densityplot(~ x)

densityplot(~x, n = 200, ylim = dnorm(0) * c(-0.1, 1.15),
            panel = function(x, ...) {
              panel.densityplot(x, ...)
              panel.mathdensity(n = 200, col.line = "grey74")
            })

## empirical distribution of sample means for various sample sizes
B <- 1000
n <- round(10^(seq(from = 1, to = 2.5, length = 4)), 0)
names(n) <- paste0("n", n)
getSampleMeans <- function(n, B) colMeans(matrix(rnorm(n * B), nrow = n))
x <- data.frame(sapply(n, getSampleMeans, B))

## using the "extended formula interface" in lattice
jFormula <- as.formula(paste("~", paste(names(n), sep = "", collapse = " + ")))
## building the formula programmatically is slicker than the alternative, which
## is hard wiring to "~ n10 + n32 + n100 + n316", which is not a crime
densityplot(jFormula, x, xlab = "sample means",
            auto.key = list(x = 0.9, y = 0.9, corner = c(1, 1),
                            reverse.rows = TRUE))

## keeping the data "tidy", i.e. tall and skinny, for a happier life
xTallSkinny <- stack(x)
names(xTallSkinny) <- c("x","n")
xTallSkinny$n <- factor(xTallSkinny$n, levels = colnames(x))
densityplot(~ x, xTallSkinny, xlab = "sample means", groups = n,
            auto.key = list(x = 0.9, y = 0.9, corner = c(1, 1),
                            reverse.rows = TRUE))