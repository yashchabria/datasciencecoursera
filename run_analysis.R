#downloaded the file from:
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# extract it to ./data3 folder.


## 1. Merges the training and the test sets.

Y_train <- read.table("./data3/train/y_train.txt", header = FALSE)
Y_test <- read.table("./data3/test/y_test.txt", header = FALSE)
X_train <- read.table("./data3/train/X_train.txt", header = FALSE)
X_test <- read.table("./data3/test/X_test.txt", header = FALSE)

subjectTest<- read.table("./data3/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("./data3/train/subject_train.txt", header = FALSE)

yData <- rbind(Y_train, Y_test)
xData <- rbind(X_train, X_test)
subjectData <- rbind(subjectTrain, subjectTest)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./data3/features.txt")
names(features) <- c("featid", "featname")

indexes <- grep("-mean\\(\\)|-std\\(\\)", features$featname) 
xData <- xData[, indexes] 
names(xData) <- gsub("\\(|\\)", "", (features[indexes, 2]))





#3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data3/activity_labels.txt")

#4. Appropriately labels the data set with descriptive variable names.
names(activities) <- c('accountID', 'accountName')
yData[, 1] = activities[yData[, 1], 2]


names(yData) <- "Activity"
names(subjectData) <- "Subject"

#5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
tidyDataSet <- cbind(subjectData, yData, xData)



p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"


#########################################################################################################
# Write Files out
 
write.table(tidyDataSet, file =  "./data3/tidyDataSet.csv", row.names =FALSE)
write.table(tidyDataAVGSet,file= "./data3/tidyDataAVG.csv",row.names =FALSE)

