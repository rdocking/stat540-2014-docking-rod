# Sample code from 
# http://www.stat.ubc.ca/~jenny/STAT545A/block01_basicsWorkspaceWorkingDirProject.html

# Set variables
a <- 2
b <- -8
sigSq <- 0.5
n <- 400

# Sample from uniform distribution
x <- runif(n)
# Calculate y values from normal distribution
y <- a + b * x + rnorm(n, sd = sqrt(sigSq))
(avgX <- mean(x))

# Write results to file and plot
write(avgX, "avgX.txt")
plot(x, y)
abline(a, b, col = "blue")
dev.print(pdf, "toylinePlot.pdf")