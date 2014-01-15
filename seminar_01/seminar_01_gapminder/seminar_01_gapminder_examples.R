# STAT540 seminar_01 gapminder examples - care and feeding of data frames
# Code is from http://www.stat.ubc.ca/~jenny/STAT545A/block02_careFeedingData.html

# Import data from file
gDat <- read.delim("gapminderDataFiveYear.txt")

# ... or from a URL
#gdURL <- "http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt"
#gDat <- read.delim(file = gdURL)

# Inspect data frame
str(gDat)   # structure
head(gDat)  # head
tail(gDat)  # tail

# More ways to query data frames
names(gDat) # column names 
ncol(gDat)  # number of columns
length(gDat) # length of vectors
head(rownames(gDat)) # row names
dim(gDat) # dimensions - row x columns
nrow(gDat) # number of rows
summary(gDat) # statistical summary

# Figure tests with lattice package
library(lattice)
xyplot(lifeExp ~ year, data = gDat) # Note - y ~ x
xyplot(lifeExp ~ gdpPercap, gDat)
xyplot(lifeExp ~ gdpPercap, gDat, subset = country == "Colombia")
xyplot(lifeExp ~ gdpPercap, gDat, 
       subset = country == "Colombia", 
       type = c("p", "r")) # From panel.xyplot help: 'p' for point, 'r' for regression
xyplot(lifeExp ~ gdpPercap | continent, gDat, subset = year == 2007) # faceting example
xyplot(lifeExp ~ gdpPercap, gDat, group = continent, 
       subset = year == 2007, # subset by year
       auto.key = TRUE)       # add auto legend?

# Back to the str() examples
str(gDat)
head(gDat$lifeExp) # single variable from frame
summary(gDat$lifeExp)
densityplot(~lifeExp, gDat)
summary(gDat$year)
table(gDat$year) # summarize counts
class(gDat$continent) # it's a factor!
summary(gDat$continent) # notice it's a different summary for factors
levels(gDat$continent)
nlevels(gDat$continent)
table(gDat$continent)
barchart(table(gDat$continent)) # Default is for horizontal bars
dotplot(table(gDat$continent), type = "h", col.line = NA)
dotplot(table(gDat$continent), type = c("p", "h"), col.line = NA)
str(gDat$continent)
xyplot(lifeExp ~ gdpPercap, gDat, subset = year == 2007, group = continent, 
       auto.key = TRUE)
xyplot(lifeExp ~ gdpPercap | continent, gDat, subset = year == 2007)

# Subset examples
subset(gDat, subset = country == "Uruguay") # good
gDat[1621:1632,] # not so gppd
subset(gDat, country == 'Uruguay') # How I'd usually write it
subset(gDat, subset = country == "Mexico", select = c(country, year, lifeExp))

# One more regression example
xyplot(lifeExp ~ year, gDat, subset = country == "Colombia", type = c("p", "r"))
(minYear <- min(gDat$year))
myFit <- lm(lifeExp ~ I(year - minYear), gDat, subset = country == "Colombia")
summary(myFit)

# Using with() to make a function take a data frame subset
with(subset(gDat, subset = country == "Colombia"), cor(lifeExp, gdpPercap))