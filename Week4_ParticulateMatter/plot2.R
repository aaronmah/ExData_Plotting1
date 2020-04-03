fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")

#plot2 - specific to baltimore
png(filename="plot2.png")
baltData <- subset(NEI,NEI$fips=="24510")
baltSums <- tapply(baltData$Emissions, baltData$year,sum)
baltdf <- data.frame(years=names(baltSums), totals=baltSums)
baltdf$years <- as.numeric(as.character(baltdf$years))
plot(baltdf$years,baltdf$totals, pch=20, type="b", ylab="Total Emissions", xlab="Years", main="Total Emissions in Baltimore")
dev.off()