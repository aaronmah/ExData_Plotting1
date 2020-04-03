fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")

#plot3 - across types of data collection
baltData <- subset(NEI,NEI$fips=="24510")
baltSums <- tapply(baltData$Emissions, baltData$year,sum)
baltdf <- data.frame(years=names(baltSums), totals=baltSums)
baltdf$years <- as.numeric(as.character(baltdf$years))

png(filename="plot3.png",width=720, height=320)
library(ggplot2)
with(baltData,
     qplot(year, Emissions, facets = .~type)
)
dev.off()