library(reshape2)
library(dplyr)
library(tidyr)

setwd("D:/Portfolio/Github/GettingNCleaning")
# modify setwd ("") based on your working directory

## Creating a "data" directory within WD
if(!file.exists("data")){dir.create("data")}


## Downloading the dataset.zip file to "data directory
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileUrl, "./data/dataset.zip")
unzip("./data/dataset.zip", exdir = "./data")

setwd("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset")
# setwd inside UCI HAR Dataset folder

## Merges the training and the test sets to create one data set.
subject_train <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/test/y_test.txt")

# add column names
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
featureNames <- read.table("D:/Portfolio/Github/GettingNCleaning/data/UCI HAR Dataset/features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

## Extracts only the measurements on the mean and 
## standard deviation for each measurement.

mean_std_cols <- grepl("mean\\(\\)", names(combined)) |
        grepl("std\\(\\)", names(combined))

mean_std_cols[1:2] <- TRUE

combined <- combined[, mean_std_cols]

## Uses descriptive activity names to name the activities in the data set.
## Appropriately labels the data set with descriptive variable names.

combined$activity <- factor(combined$activity, labels=c("Walking",
"Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

## From the data set in step 4, creates a second, 
## independent tidy data set with the average of each 
## variable for each activity and each subject.

melted <- melt(combined, id=c("subjectID","activity"))
tidy_data <- dcast(melted, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy_data, "tidy.csv", row.names=FALSE)
