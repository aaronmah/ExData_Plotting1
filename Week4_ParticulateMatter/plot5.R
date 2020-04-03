fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='data.zip')
unzip('data.zip')

NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")

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