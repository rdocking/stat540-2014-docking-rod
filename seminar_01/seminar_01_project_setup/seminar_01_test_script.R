# Sample code from 
# http://www.stat.ubc.ca/~jenny/STAT545A/block01_basicsWorkspaceWorkingDirProject.html

# Set variables
a <- 2
b <- -3
sigSq <- 0.5

# Sample from uniform distribution
x <- runif(40)
# Calculate y values from normal distribution
y <- a + b * x + rnorm(40, sd = sqrt(sigSq))
(avgX <- mean(x))

# Write results to file and plot
write(avgX, "avgX.txt")
plot(x, y)
abline(a, b, col = "purple")
dev.print(pdf, "toylinePlot.pdf")