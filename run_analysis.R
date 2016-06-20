## Downloading the  Data

```{r}
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
```

###Unzip the file

```{r}
unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

```{r}
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
```

###The files that will be used to load data are listed as follows:

test/subject_test.txt

test/X_test.txt

test/y_test.txt

train/subject_train.txt

train/X_train.txt

train/y_train.txt


###Reading data from the targeted files

```{r}
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
str(dataActivityTest)
str(dataActivityTrain)
```

###Reading the subject files 

```{r}
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
str(dataSubjectTrain)
str(dataSubjectTrain)
```

###Reading Featured files

```{r}
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
```

## Merging the training and the test sets to create one data set

```{r}
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
```

### Naming the Variables 
```{r}
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
```

##.Merge columns to get the data frame Data for all data

```{r}
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
Data
```

##The mean and standard deviation for each measurement

```{r}
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
```

## Name the activities in the data set
```{r}
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
```

##labels the data set with descriptive variable names

In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.In this part, Names of Feteatures will labelled using descriptive variable names.

prefix t is replaced by time

Acc is replaced by Accelerometer

Gyro is replaced by Gyroscope

prefix f is replaced by frequency

Mag is replaced by Magnitude

BodyBody is replaced by Body

```{r}
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
```

```{r}
(names(Data))
Data
```

## Independent tidy data set and ouput its out put

```{r}
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
```
