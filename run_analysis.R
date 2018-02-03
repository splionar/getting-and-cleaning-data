library(dplyr)

#0. Import data
setwd("/home/stefan/datasciencecoursera/cleaningdata/UCI HAR Dataset") #set working directory
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
features <- read.table("./features.txt")
activity_labels<- read.table("./activity_labels.txt")

#1. Merges the training and the test sets to create one data set.
df <- data_frame()
df <- cbind(subject_train, X_train, y_train) %>%
        rbind(cbind(subject_test, X_test, y_test)) %>%
        setNames(c("subject", as.character(features[[2]]), "activity"))

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_sd_index <- grep("\\bmean()\\b|std()", names(df))
selected_df <- df[,c(1,mean_sd_index,563)]

#3. Uses descriptive activity names to name the activities in the data set
selected_df$activity <- factor(selected_df$activity, 
                                 levels = activity_labels[, 1], labels = activity_labels[, 2])

#4. Appropriately labels the data set with descriptive variable names.
names(selected_df) <- gsub("^f", "frequency-", names(selected_df))
names(selected_df) <- gsub("^t", "time-", names(selected_df))
names(selected_df) <- gsub("\\(|\\)", "", names(selected_df))
names(selected_df) <- gsub("Mag", "Magnitude", names(selected_df))
names(selected_df) <- gsub("BodyBody", "Body", names(selected_df))
names(selected_df) <- gsub("Acc", "Accelerometer", names(selected_df))
names(selected_df) <- gsub("Gyro", "Gyroscope", names(selected_df))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summary_df <- selected_df %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

# output summarized data frame"
write.table(summary_df, "tidy_dataset.txt", row.names = FALSE)
