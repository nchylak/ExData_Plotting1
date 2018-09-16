### Download and unzip
hpc_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(hpc_url, "hpc.zip")
unzip("hpc.zip")
file.remove("hpc.zip")

### Read relevant rows
txt <- "household_power_consumption.txt"
relevant_rows <- grep("^[12]/2/2007", readLines(txt))
hpc <- read.table(txt, skip = relevant_rows[[1]] - 1, # Skip all rows before start of relevant rows
                  nrows = length(relevant_rows), # Select the number of relevant rows
                  sep = ";", na.strings = "?") # NAs are coded as "?"

### Add header
header <- read.table("household_power_consumption.txt", nrows = 1, sep = ";")
names(hpc) <- unlist(header[1,])

### Concatenate date and time and convert to datetime format
hpc$Date <- paste(hpc$Date, hpc$Time)
hpc$Date <- strptime(hpc$Date, format = "%d/%m/%Y %H:%M:%S")
names(hpc)[1] <- "datetime"
hpc <- hpc[,-2] # Time column is redundant now

### Plot graphic to PNG
png("plot1.png", width = 480, height = 480)
hist(hpc$Global_active_power, main = "Global Active Power",
     col = "Red", xlab = "Global Active Power (kilowatts)", ylim = c(0,1200))
dev.off()