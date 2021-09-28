firstly we download and unzip data from the url:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

then read all the tables into dataframes
activity_labels, features, subject_test, subject_train
X_test, X_train, y_test, y_train

Merging the training and the test sets to create one data set df
Extracting only the measurements on the mean and standard deviation for each measurement. 
Using descriptive activity names to name the activities in the data set
Appropriately re-labels the data set with descriptive activity names. removing brackets and subsetting.
Creating a final, independent tidy data set with the average of each variable for each activity and each subject. 
Melting data and calculating averages, then write it to "tidy_dataset.txt"
