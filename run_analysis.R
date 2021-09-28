temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip (temp, exdir = ".")
unlink(temp)

## Reading Data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# 1. Merges the training and the test sets to create one data set.
df <- rbind(X_train,X_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

MST_subset <- grep("mean()|std()", features[, 2]) 
df <- df[,MST_subset]


# 3. Adding descriptive activity names to name the activities in the data set. Removing brackets and subsetting.
new_names <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(df) <- new_names[MST_subset]

subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

df <- cbind(subject,activity, df)

# 4. Appropriately labeling the data set with descriptive variable names. 
activity_group <- factor(df$activity)
levels(activity_group) <- activity_labels[,2]
df$activity <- activity_group


# 5. From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject, writing result into tidy_dataset.txt

library("reshape2")
baseData <- melt(df,(id.vars=c("subject","activity")))
final_df <- dcast(baseData, subject + activity ~ variable, mean)
names(final_df)[-c(1:2)] <- paste("means of" , names(final_df)[-c(1:2)] )
write.table(final_df, "tidy_dataset.txt", sep = ",")

