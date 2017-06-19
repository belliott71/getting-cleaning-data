# Merge Train and Test - read train table
x_train<-read.table("./data/UCI HAR dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR dataset/train/subject_train.txt")

# Reading test table
x_test<-read.table("./data/UCI HAR dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR dataset/test/subject_test.txt")

# Read activity labels:
activityLabels<-read.table("./data/UCI HAR dataset/activity_labels.txt")

# Read feature vector:

features<-read.table("./data/UCI HAR dataset/features.txt")

# Assign column names:

colnames(x_train)<-features[,2]
colnames(y_train)<-"ActivityId"
colnames(subject_train)<-"SubjectId"
colnames(x_test)<-features[,2]
colnames(y_test)<-"ActivityId"
colnames(subject_test)<-"SubjectId"

colnames(activityLabels)<- c('ActivityId','ActivityType')

# Merging all data:
mergetrain<- cbind(y_train,subject_train,x_train)
mergetest<- cbind(y_test,subject_test,x_test)
dataset<-rbind(mergetrain,mergetest)

#Extracts only the measurements on the mean and standard deviation for each measurement

# Read column names:
columnnames<-colnames(dataset)

##Mean and Standard deviation:
mean_std<-(grepl("ActivityId",columnnames)|grepl("SubjectId",columnnames)|
           grepl("mean",columnnames)|grepl("std",columnnames))
##Subset from dataset:
Mean_Std_Set<-dataset[,mean_std== TRUE]

#Using descriptive activity names to name the activities in the data set:
desactnames<-merge(Mean_Std_Set, activityLabels, by="ActivityId", all.x=TRUE)

#Creating a second independent tidy data set:

tidydata <- aggregate(. ~SubjectId + ActivityId, desactnames, mean)
tidydata <- tidydata[order(tidydata$SubjectId, tidydata$ActivityId),]

write.table(tidydata,"tidydata.txt", row.name=FALSE)