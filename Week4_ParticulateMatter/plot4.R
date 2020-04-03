fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")


#plot 4 - coal emissions
png(filename="plot4.png")
coalSCC <- grepl("Coal",SCC$Short.Name)
coalCodes <- SCC$SCC[coalSCC]
coalData <- subset(NEI, NEI$SCC %in% coalCodes)

coalYearSplit <- tapply(coalData$Emissions, coalData$year, sum)
coaldf <- data.frame(years=names(coalYearSplit), totals=coalYearSplit)
coaldf$years <- as.numeric(as.character(coaldf$years))

plot(coaldf$years, coaldf$totals, xlab="Year", ylab="Totals", main="Total Coal Emissions", type="b")
dev.off()