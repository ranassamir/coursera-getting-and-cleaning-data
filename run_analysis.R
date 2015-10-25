setwd("~/Coursera/Data Science/03 - Getting and Cleaning Data/Course_Project")

labels <- read.csv("UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")
features <- read.csv("UCI HAR Dataset/features.txt",header=FALSE,sep="")
features[,2] = gsub('[-()]', '', features[,2])

xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")
ytrain <- read.csv("UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
subjecttrain <- read.csv("UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")

training <- xtrain
training[,562] <- ytrain
training[,563] <- subjecttrain

xtest <- read.csv("UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
ytest <- read.csv("UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
subjecttest <- read.csv("UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")

test <- xtest
test[,562] <- ytrain
test[,563] <- subjecttrain

fulldataset = rbind(training,test)

selectedCols <- grep("mean.*|std.*",features[,2])
features <- features[selectedCols,]
selectedCols <- c(selectedCols,562,563)
fulldataset <- fulldataset[,selectedCols]
colnames(fulldataset) <- c(features$V2,"Activity", "Subject")

fulldataset$Activity <- labels[fulldataset$Activity,2]

fulldataset$Activity <- as.factor(fulldataset$Activity)
fulldataset$Subject <- as.factor(fulldataset$Subject)

tidydata = aggregate(fulldataset, by=list(activity = fulldataset$Activity, subject=fulldataset$Subject), mean)
tidydata$Activity <- NULL
tidydata$Subject <- NULL

write.table(tidydata, "tidydata.txt", sep="\t")
