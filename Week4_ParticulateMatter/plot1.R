fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")


#plot 1 - overall emissions trends
png(filename="plot1.png")
yearSum <- tapply(NEI$Emissions,NEI$year, sum)
dataYear <- data.frame(year=names(yearSum), totals=yearSum)
dataYear$year <- round(as.numeric(as.character(dataYear$year)),0)
dataYear$totals <-round(as.numeric(as.character(dataYear$totals)),0)
plot(dataYear$year,dataYear$totals, xlab="Year", ylab="Totals", type="p", pch=20, ylim=c(0,max(dataYear$totals)), xlim=c(1998,2009), main="Total Emissions")
lines(dataYear)

text(dataYear$totals,x=dataYear$year+0.5, y=dataYear$totals-500000)
dev.off()