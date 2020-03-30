---
title: "CODEBOOK.md"
output: 
  html_document:
    toc: true
    toc_float: true
    theme: default
    code_download: true
    highlight: tango
---

# Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. I will be graded by my peers on a series of yes/no questions related to the project. I will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

# Data Project

One of the most exciting areas in all of data science right now is wearable computing.. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[Human Activity Recognition Using Smartphone](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here are the data for the project:

[Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

We will create one R script called run_analysis.R that does the following.

Step 1. Load library needed for the project and download the Dataset.zip to the working directory
Step 2. Merges the training and the test sets to create one data set.
Step 3. Extracts only the measurements on the mean and standard deviation for each measurement.
Step 4. Uses descriptive activity names to name the activities in the data set
Step 5. Appropriately labels the data set with descriptive variable names.
Step 6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Step 1
```
library(reshape2)
library(dplyr)
library(tidyr)

setwd("~/Portfolio/GettingNCleaning")
# modify based on your working directory

## Creating a "data" directory within WD
if(!file.exists("data")){dir.create("data")}
## Downloading the dataset.zip file to "data directory
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileUrl, "./data/dataset.zip")
unzip("./data/dataset.zip", exdir = "./data")
setwd("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset")
```

## Step 2
```{r}
## Merges the training and the test sets to create one data set.
subject_train <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/test/y_test.txt")
```

```{r}
head(subject_train)
dim(subject_train)
```
```{r}
head(subject_test)
dim(subject_test)
```
```{r}
head(X_train)
dim(X_train)
head(X_test)
dim(X_test)
head(y_train)
dim(y_train)
head(y_test)
dim(y_test)
```


```{r}
# add column names
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
featureNames <- read.table("~/Portfolio/GettingNCleaning/data/UCI HAR Dataset/features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"
```

```{r}
head(subject_train)
dim(subject_train)
head(subject_test)
dim(subject_test)
head(X_train)
dim(X_train)
head(X_test)
dim(X_test)
head(y_train)
dim(y_train)
head(y_test)
dim(y_test)
```


```{r}
# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)
head(combined)
```


## Step 3 
```{r}
## Extracts only the measurements on the mean and 
## standard deviation for each measurement.

mean_std_cols <- grepl("mean\\(\\)", names(combined)) |
    grepl("std\\(\\)", names(combined))

mean_std_cols[1:2] <- TRUE

combined <- combined[, mean_std_cols]
head(combined)
```

## Step 4 and 5
```{r}
## Uses descriptive activity names to name the activities in the data set.
## Appropriately labels the data set with descriptive variable names.

combined$activity <- factor(combined$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
head(combined)
```

## Step 6
```{r}
## From the data set in step 4, creates a second, 
## independent tidy data set with the average of each 
## variable for each activity and each subject.

melted <- melt(combined, id=c("subjectID","activity"))
tidy_data <- dcast(melted, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy_data, "tidy.csv", row.names=FALSE)
head(melted)
dim(melted)
head(tidy_data)
dim(tidy_data)
```


