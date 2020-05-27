library(dplyr)

#Reading Activity Labels
activity_labels <- read.table(".//UCI HAR Dataset//activity_labels.txt")

#Reading Features
features <- read.table(".//UCI HAR Dataset//features.txt")

#Reading the Data from the Training Set
X_train <- read.table(".//UCI HAR Dataset//train//X_train.txt")
Y_train <- read.table(".//UCI HAR Dataset//train//y_train.txt")
Sub_train <- read.table(".//UCI HAR Dataset//train//subject_train.txt")

#Reading the Data from the Testing Set
X_test <- read.table(".//UCI HAR Dataset//test//X_test.txt")
Y_test <- read.table(".//UCI HAR Dataset//test//y_test.txt")
Sub_test <- read.table(".//UCI HAR Dataset//test//subject_test.txt")

#Merging the Data Sets
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
SUB <- rbind(Sub_train, Sub_test)

#Extracing measurements on the mean and standard deviation for each measurement
select_features <- features[grep("mean()|std()", features[,2]),]

#Keeping only the selcted features in our DataSet
X <- X[,select_features[,1]]

#Appropriately naming and organizing data 
colnames(Y) <- "activity"
Y$activity_label <- factor(Y$activity, labels = as.character(activity_labels[,2]))
activity_label <- Y[,-1]
colnames(X) <- features[select_features[,1],2]
colnames(SUB) <- "subject"

#From the data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject
final_DataSet <- cbind(X, activity_label, SUB)
str(final_DataSet)
tidyData <- final_DataSet %>% group_by(activity_label, subject) %>% summarize_each(funs(mean))
tidyData
write.table(tidyData, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
