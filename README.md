# Getting and Cleaning Data Course Project

## About this project
The goal of this project is to prepare tidy data that can be used for later analysis. This repository contains the following files: 
- `run_analysis.R`, the R script that is used to prepare the tidy data
- `tidy_dataset.txt`, independent tidy data set, which is the output of running `run_analysis.R`
- `README.md` which provides an overview of this project and the flow of `run_analysis.R` R script
- `CodeBook.md`, the code book which provides description of variables in the `tidy_dataset.txt`

## About the dataset
The data in this project represents data collected from the embedded accelerometer and gyroscope from Samsung Galaxy SII smartphone. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were recorded. Each feature is normalized and bounded within [-1,1]

The original dataset is obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Tidying the data
The R script `run_analysis.R` will do the following steps:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Before going into step 1, we should first download and unzip the dataset, and look on what files are inside.

### Step 0A. Look what is inside the .zip file
The zip file contains test and train folders. In this project, we omit everything inside `Inertial Signals` folders in both training and test folders. Here are some explanations about the files that we care about:
- `features.txt`, 561 variable names which will be matched with the readings from test and train dataset
- `activity_labels.txt`, contains labels with 6 levels with its descriptive activity. This will later be matched with activity records from train and test dataset.

Inside train folder:
- `subject_train.txt`:  subject for each observation (total 7352 observations)
- `X_train.txt`: Dataset containing records from 7352 observations and 561 variables
- `y_train.txt`: Dataset containing activity labels from 7352 observations

Inside test folder:
- `subject_test.txt`:  subject for each observation (total 2947 observations)
- `X_test.txt`: Dataset containining records from 2947 observations and 561 variables
- `y_test.txt`: Dataset containing activity labels from 2947 observations

Detailed description of the features can be read in `features_info.txt`.

### Step 0B. Import dataset into R environment
Before going into step 1, we need to import the dataset into R working environment. As the dataset is separated with space, `read.table` function is used to store the contents into variables. Correct working directory must be set beforehand. Also, the later part of the code will use dplyr library. Hence, it must be first initialized.
```r
library(dplyr)

#set working directory
setwd("") 

#Import dataset
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
features <- read.table("./features.txt")
activity_labels<- read.table("./activity_labels.txt")
```
### Step 1. Merges the training and the test sets to create one data set
We will first create empty data frame called `df`. Afterwards, using cbind (column bind) and rbind (row bind) command, we create the merged dataset. Lastly, we change names of variables with the following rules:
- First column changed to `subject`
- Last column changed to `activity`
- The 561 columns in between are matched with data frame we obtain from `features.txt`
```r
#create empty dataframe
df <- data_frame()

#Merge data frame and change names of variables
df <- cbind(subject_train, X_train, y_train) %>%
        rbind(cbind(subject_test, X_test, y_test)) %>%
        setNames(c("subject", as.character(features[[2]]), "activity"))
```
### Step 2. Extracts only the measurements on the mean and standard deviation for each measurement
We only care with variables showing mean and standard deviation. Hence we will exclude all variables without `mean()` and `std()` components. Note that variables with `meanFreq()` and additional vectors, such as  `gravityMean, tBodyAccMean, tBodyGyroMean, etc.`are excluded.
```r
mean_sd_index <- grep("\\bmean()\\b|std()", names(df)) #Obtain indexes of selected variables
selected_df <- df[,c(1,mean_sd_index,563)] #Create selected data frame
```
### Step 3. Uses descriptive activity names to name the activities in the data set
Labels (1-6) in `activity` column are matched and changed into their descriptive activities, accordingly. 
```r
selected_df$activity <- factor(selected_df$activity, 
                                 levels = activity_labels[, 1], labels = activity_labels[, 2])
```
### Step 4. Appropriately labels the data set with descriptive variable names
Variable names obtained from `features.txt` are modified to make them more descriptive.
```r
names(selected_df) <- gsub("^f", "frequency-", names(selected_df))
names(selected_df) <- gsub("^t", "time-", names(selected_df))
names(selected_df) <- gsub("\\(|\\)", "", names(selected_df))
names(selected_df) <- gsub("Mag", "Magnitude", names(selected_df))
names(selected_df) <- gsub("BodyBody", "Body", names(selected_df))
names(selected_df) <- gsub("Acc", "Accelerometer", names(selected_df))
names(selected_df) <- gsub("Gyro", "Gyroscope", names(selected_df))
```
### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Create summarized data frame with grand mean of each variables, group by subject and activity
```r
summary_df <- selected_df %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
```
Lastly, we write the independent tidy data set we just created
```r
write.table(summary_df, "tidy_dataset.txt", row.names = FALSE)
```
