rm(list = ls(all = TRUE))

getwd()
setwd("C:\\Users\\KIRTAN 1\\getting and cleaning\\train")
library(plyr)
library(data.table)
library(dplyr)
### I
####Merge the training and test sets 

x_train <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\train\\X_train.txt")
y_train <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\train\\y_train.txt")
subject_train <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\train\\subject_train.txt")

setwd("C:\\Users\\KIRTAN 1\\getting and cleaning\\test")
x_test <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\test\\X_test.txt")
y_test <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\test\\y_test.txt")
subject_test <- read.table("C:\\Users\\KIRTAN 1\\getting and cleaning\\test\\subject_test.txt")


#### create 'x' data set
x_data <- rbind(x_train, x_test)

#### create 'y' data set
y_data <- rbind(y_train, y_test)

#### create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

#### II 
#### Extracting the measurements on the mean 
####and sd for each measurement
setwd("C:\\Users\\KIRTAN 1\\getting and cleaning")
features <- read.table("features.txt")

#### get only columns with mean() or std() 
####in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", 
                              features[, 2])

#### subset the desired columns
x_data <- x_data[, mean_and_std_features]

#### correct the column names
names(x_data) <- features[mean_and_std_features, 2]

#### III
#### Using descriptive activity names to name 
####the activities in the data set
activities <- read.table("activity_labels.txt")

#### update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

#### correct column name
names(y_data) <- "activity"

#### IV
#### Appropriately label the data set 
### with descriptive variable names
#### correct column name
names(subject_data) <- "subject"

#### bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

#### V
#### Create a second, independent tidy data set with 
####the average of each variable
#### for each activity and each subject

#### 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity),
                       function(x) colMeans(x[, 1:66]))

write.table(averages_data, 
            "averages_data.txt", row.name=FALSE)
