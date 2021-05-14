fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
ActivityTestdata <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTraindata <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTraindata <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTestdata  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTestdata  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTraindata <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

Subjectdata <- rbind(SubjectTraindata, SubjectTestdata)
Activitydata<- rbind(ActivityTraindata, ActivityTestdata)
Featuresdata<- rbind(FeaturesTraindata, FeaturesTestdata)

names(Subjectdata)<-c("subject")
names(Activitydata)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Featuresdata)<- dataFeaturesNames$V2
Combinedata <- cbind(Subjectdata, Activitydata)
Data <- cbind(Featuresdata, Combinedata)
Data
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
Data$activity <- factor(Data$activity,labels=activityLabels$V2)
head(Data$activity,30)
library(data.table)
dtalldata <- data.table(Data)
tidydata <- dtalldata[,lapply(.SD,mean), by = .(activity, subject)]
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
