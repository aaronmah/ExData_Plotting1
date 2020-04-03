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

#plot2 - specific to baltimore
png(filename="plot2.png")
baltData <- subset(NEI,NEI$fips=="24510")
baltSums <- tapply(baltData$Emissions, baltData$year,sum)
baltdf <- data.frame(years=names(baltSums), totals=baltSums)
baltdf$years <- as.numeric(as.character(baltdf$years))
plot(baltdf$years,baltdf$totals, pch=20, type="b", ylab="Total Emissions", xlab="Years", main="Total Emissions in Baltimore")
dev.off()

#plot3 - across types of data collection
png(filename="plot3.png",width=720, height=320)
library(ggplot2)
with(baltData,
     qplot(year, Emissions, facets = .~type)
     )
dev.off()

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

#plot 5 - motor vehicle emissions in Baltimore
png(filename="plot5.png")
library(dplyr)
motorSCC <- filter(SCC,
                   grepl("Vehicle", Short.Name)|
                   grepl("Vehicle", SCC.Level.One)|
                   grepl("Vehicle", SCC.Level.Two)|
                   grepl("Vehicle", SCC.Level.Three)|
                   grepl("Vehicle", SCC.Level.Four)|
                   grepl("Vehicle", EI.Sector)
)
motorCodes <- motorSCC$SCC
motorData <- subset(NEI, NEI$SCC %in% motorCodes)

baltMotor <- subset(motorData, motorData$fips=="24510")
baltdata <- tapply(baltMotor$Emissions, baltMotor$year, sum)
baltdf <- data.frame(year=names(baltdata),totals=baltdata)
baltdf$year <- as.numeric(as.character(baltdf$year))
plot(baltdf$year, baltdf$totals, type="b", xlab="Year", ylab="Total Emissions", main="Motor Vehicle Emissions in Baltimore")
dev.off()

#plot6
png(filename="plot6.png", width=720, height=320)
par(mfrow=c(1,3))
LAmotor <- subset(motorData, motorData$fips=="06037")
LAmotordata <- tapply(LAmotor$Emissions, LAmotor$year, sum)
LAdf <- data.frame(year=names(LAmotordata), totals=LAmotordata)
LAdf$year <- as.numeric(as.character(LAdf$year))

plot(LAdf$year, LAdf$totals, ylim=c(0,10000), xlab="Year", ylab="Total Emissions", type="n", main="Overall")
points(LAdf$year, LAdf$totals, col="blue")
lines(LAdf$year, LAdf$totals, col="blue")

points(baltdf$year, baltdf$totals, col="red")
lines(baltdf$year, baltdf$totals, col="red")
legend("topright", legend=c("LA","Baltimore"), col=c("blue","red"), lty=1)

plot(baltdf$year, baltdf$totals, type="b", xlab="Year", ylab="Total Emissions", main="Baltimore")
plot(LAdf$year, LAdf$totals, type="b", xlab="Year", ylab="Total Emissions", main="LA")
dev.off()
