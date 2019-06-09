library(reshape2)

filename <- "getdata_dataset.zip"

# Download and unzip the dataset
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

#reading Activity data and labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
featuresNames <- read.table("UCI HAR Dataset/features.txt")

# Extract only the data on mean and standard deviation
featuresMeanStd <- grep(".*mean.*|.*std.*", featuresNames[,2])

#Loading datasets
activityTest  <- read.table("UCI HAR Dataset/test/Y_test.txt" )
activityTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjectTest  <- read.table("UCI HAR Dataset/test/subject_test.txt")
test  <- read.table("UCI HAR Dataset/test/X_test.txt" ) [featuresMeanStd]
train <- read.table("UCI HAR Dataset/train/X_train.txt") [featuresMeanStd]

# combine files into one dataset
train <- cbind(subjectTrain, activityTrain, train)
test <- cbind(subjectTest, activityTest, test)
combined <- rbind(train, test)
colnames(combined) <- c("subject", "activity", featuresMeanStd.names)
combined$activity <- factor(combined$activity, levels = activityLabels[,1], labels = activityLabels[,2])

combined.melted <- melt(combined, id = c("subject", "activity"))
combined.mean <- dcast(combined.melted, subject+activity~variable, mean)

write.table(combined.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
