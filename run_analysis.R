library(reshape2)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")
unzip("data.zip")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

meanStd <- grep(".*mean.*|.*std.*", features[,2])
meanStd.names <- features[meanStd,2]
meanStd.names = gsub('-mean', 'Mean', meanStd.names)
meanStd.names = gsub('-std', 'Std', meanStd.names)
meanStd.names <- gsub('[-()]', '', meanStd.names)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")[meanStd]
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, y_train, x_train)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[meanStd]
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, x_test)

data <- rbind(train, test)
colnames(data) <- c("subject", "activity", meanStd.names)

data$activity <- factor(data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
data$subject <- as.factor(data$subject)
data.melted <- melt(data, id = c("subject", "activity"))
data.mean <- dcast(data.melted, subject + activity ~ variable, mean)

write.table(data.mean, "tidy_data.txt", row.names = FALSE, quote = FALSE)