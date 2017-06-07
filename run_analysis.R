#Merging the training and the test sets to create one data set
train<-read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
test<-read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

activitytest<-read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
activitytrain<-read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

subjecttest<-read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectrain<-read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

activity<-rbind(activitytrain, activitytest) ##create one column of activities 
subject<-rbind(subjectrain, subjecttest)   ##create one column of subjects

merged<-rbind(train, test)
merged<-cbind(subject, activity, merged)  ##create one data set containing subjects, activity and measurements

#Exctrating only the measurements on the mean and standard deviation for each measurement.
features<-read.table("./UCI HAR Dataset/features.txt", header = FALSE)
colnames(merged)[3:563]<-as.character(features$V2)
extract<-merged[, c(1, 2, grep("mean|std", names(merged)))] 

#Using descriptive activity names to name the activities in the data set
extract[, 2]<-gsub("1", "walking", extract[, 2])
extract[, 2]<-gsub("2", "walking_upstairs", extract[, 2])
extract[, 2]<-gsub("3", "walking_downstairs", extract[, 2])
extract[, 2]<-gsub("4", "sitting", extract[, 2])
extract[, 2]<-gsub("5", "standing", extract[, 2])
extract[, 2]<-gsub("6", "laying", extract[, 2])

#Appropriately labeling the data set with descriptive variable names.
names(extract)<-c("subjects", "activities_label", as.character(grep("mean|std", features$V2, value = TRUE)))

#create a second, independent tidy data set with the average of each variable for each activity and 
#each subject.
library(plyr)
data_final<-ddply(extract, c("subjects", "activities_label"), function(x) colMeans(x[, 3:81]))

