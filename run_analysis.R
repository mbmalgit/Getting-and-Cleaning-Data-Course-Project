temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip (temp, exdir = ".")
unlink(temp)

## Reading Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

# 1. Merges the training and the test sets to create one data set.
df <- rbind(X_train,X_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

MST_subset <- grep("mean()|std()", features[, 2]) 
df <- df[,MST_subset]


# 4. Appropriately labels the data set with descriptive activity names.
new_names <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(df) <- new_names[MST_subset]

subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

df <- cbind(subject,activity, df)


# 3. Uses descriptive activity names to name the activities in the data set
act_group <- factor(df$activity)
levels(act_group) <- activity_labels[,2]
df$activity <- act_group


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

if (!"reshape2" %in% installed.packages()) {
  install.packages("reshape2")
}
library("reshape2")

# melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "tidy_data.txt"

baseData <- melt(df,(id.vars=c("subject","activity")))
seconddf <- dcast(baseData, subject + activity ~ variable, mean)
names(seconddf)[-c(1:2)] <- paste("[mean of]" , names(seconddf)[-c(1:2)] )
write.table(seconddf, "tidy_data.txt", sep = ",")

