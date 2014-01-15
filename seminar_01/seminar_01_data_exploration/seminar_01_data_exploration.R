# STAT540 Seminar01 Data exploration tutorial
# Code is from:
# http://www.ugrad.stat.ubc.ca/~stat540/seminars/seminar01_basic-data-exploration.html
library(knitr)

# Preamble --------------------------------------------------------------------

# Load the downloaded dataset
prDat <- read.table("GSE4051_MINI.txt", header = TRUE, row.names = 1)
str(prDat)

# Check working directories
getwd()  # is working directory what you think it should be?
list.files()  # do see GSE4051_MINI.txt sitting there?!?
#setwd()  # use with moderation

# Test what happens when we load the data frame without the normal arguments
prDat_no_args <- read.table("GSE4051_MINI.txt")
str(prDat_no_args)
head(prDat_no_args)
identical(prDat, prDat_no_args)
# This is true, so there seems to be no difference, at least on my machine

# Exercises ---------------------------------------------------------------

# How many rows are there?
(num_rows <- nrow(prDat)) 
(dimensions <- dim(prDat)) 

# How many columns are there?
(num_cols <- ncol(prDat))
(frame_length <- length(prDat))

# Inspection of the data frame using head, tail, and other indexing:
head(prDat)
tail(prDat)
# sample(prDat) - not quite sure on this one

# What does row correspond to -- different genes or different mice?
# Based on the inspection of the data frame, all the rows correspond to different mice

# What are the variable names?
(var_names <- names(prDat))

# What flavour is each variable?
(var_flavours <- str(prDat))

# Check that each integer between 1 and the number of rows occurs once and only once in the dataset
(expected_row_nums <- seq(1, nrow(prDat)))
(sorted_sample_nums <- sort(prDat$sample))
identical(expected_row_nums, sorted_sample_nums)
# This comparison returns TRUE - so each row number occurs exactly once

# For each factor variable, what are the levels?
# We observed above that there were two factorial variables - devStage and gType
levels(prDat$devStage)
levels(prDat$gType)

# How many observations do we have for each level of devStage? 
table(prDat$devStage)
# For gType?
table(prDat$gType)

# Perform a cross-tabulation of devStage and gType.
table(prDat$devStage, prDat$gType)

# If you had to take a wild guess, what do you think the intended experimental design was? 
# What actually happened in real life?
# I suspect the intention was to have 4 replicates of each genotype and developmental stage
# (for a total of 5*2*4 == 40 observations)
# In real life, it looks like one sample was lost (NrlKO, E16)

# For each quantitative variable, what are the extremes? How about average or median? 
# Various ways to do this:
summary(prDat) # This gives the ranges for all the variables, as well as averages and means
# Or for just crabHammer:
min(prDat$crabHammer)
mean(prDat$crabHammer)
median(prDat$crabHammer)
max(prDat$crabHammer)
range(prDat$crabHammer)
fivenum(prDat$crabHammer)
quantile(prDat$crabHammer)

# Indexing and subsetting -----------------------------------------------------

# Create a new data.frame called weeDat only containing observations for 
# which expression of poisonFang is above 7.5.
weeDat <- subset(prDat, subset=poisonFang > 7.5)

# For how many observations poisonFang > 7.5? 
nrow(weeDat)

# How do they break down by genotype and developmental stage?
table(weeDat$devStage, weeDat$gType)

# Print the observations with row names "Sample_16" and "Sample_38" to screen,
# showing only the 3 gene expression variables.
indices <- c("16", "38")
subset(prDat, sample %in% indices, 
       select = c("crabHammer", "eggBomb", "poisonFang"))

# Addition after checking the answers:
prDat[c("Sample_16", "Sample_38"), c("crabHammer", "eggBomb", "poisonFang")]

# Which samples have expression of eggBomb less than the 0.10 quantile?
# First find the 0.10 quantile:
(threshold <- quantile(prDat$eggBomb, probs = 0.1))
subset(prDat, eggBomb < threshold)

# Addition after checking the answers
rownames(prDat[prDat$eggBomb < quantile(prDat$eggBomb, 0.1), ])
